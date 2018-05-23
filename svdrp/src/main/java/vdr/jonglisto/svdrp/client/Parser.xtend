package vdr.jonglisto.svdrp.client

import java.time.DayOfWeek
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.time.temporal.TemporalAdjusters
import java.util.ArrayList
import java.util.List
import java.util.concurrent.atomic.AtomicReference
import java.util.regex.Pattern
import java.util.stream.Collectors
import org.apache.commons.lang3.SerializationUtils
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.EpgsearchCategory
import vdr.jonglisto.model.EpgsearchChannelGroup
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.Recording
import vdr.jonglisto.model.Timer
import vdr.jonglisto.model.VDRDiskStat
import vdr.jonglisto.model.VDROsd
import vdr.jonglisto.model.VdrPlugin
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.util.Utils
import vdr.jonglisto.xtend.annotation.Log

import static extension org.apache.commons.lang3.StringUtils.*

@Log("jonglisto.svdrp.client")
class Parser {
    static val namePattern = Pattern.compile("(\\d+) (.*?)(;(.*?))*:(\\d+):(.*?)$")
    static val recordingPattern = Pattern.compile("(\\d+) (\\d{2}.\\d{2}.\\d{2} \\d{2}:\\d{2}) (\\d+:\\d+)(\\*?) (.*)$")
    static val recordingDateFormatter = DateTimeFormatter.ofPattern("dd.MM.yy HH:mm");
    static val pluginPattern = Pattern.compile("^(.*?) (.*?) - (.*?)$")
    static val statPattern = Pattern.compile("(\\d+)MB (\\d+)MB.*?")

    static def List<Channel> parseChannel(List<String> input) {
        val result = new ArrayList<Channel>()
        val lastGroup = new AtomicReference<String>()

        // set a root value for the group
        lastGroup.set(Channel.ROOT_GROUP)

        input.forEach [ s |
            {
                val sp = s.split(":")

                if (sp.length == 2) {
                    lastGroup.set(sp.get(1))
                } else {
                    val matcher = namePattern.matcher(s)

                    if (!matcher.matches) {
                        throw new RuntimeException("Probleme mit " + sp.get(0))
                    }

                    val ch = new Channel

                    ch.raw = s.substring(s.ordinalIndexOf(" ", 2)+1)

                    ch.group = lastGroup.get
                    ch.radio = "0" == sp.get(5) || "1" == sp.get(5)

                    ch.encrypted = "0" != sp.get(8)
                    ch.source = sp.get(3)
                    ch.number = Integer.valueOf(matcher.group(1))
                    ch.id = sp.get(3) + "-" + sp.get(10) + "-" + sp.get(11) + "-" + sp.get(9)

                    ch.bouquet = matcher.group(4)
                    ch.frequence = Long.valueOf(matcher.group(5))
                    if (ch.frequence == 0) {
                        ch.frequence = null
                    }

                    val idx2 = matcher.group(2).indexOf(",")
                    if (idx2 == -1) {
                        ch.name = matcher.group(2).trim
                    } else {
                        ch.name = matcher.group(2).substring(0, idx2).trim
                    }

                    ch.normalizedName = Utils.normalizeChannelName(ch.name)

                    result.add(ch)
                }
            }
        ]

        return result
    }

    static def List<Epg> parseEpg(List<String> input) {
        val result = new ArrayList<Epg>()
        val lastChannel = new AtomicReference<String>()
        val lastEpg = new AtomicReference<Epg>(new Epg)

        input.forEach [ s |
            {
                var code = s.substring(0, 1)
                var String data

                switch code {
                    case 'e': {
                    }
                    case 'c': {
                    }
                    default: {
                        data = s.substring(2)
                        if (code != 'D') {
                            lastEpg.get.addData(s)
                        }
                    }
                }

                switch code {
                    case 'C': {
                        lastChannel.set(data.extractChannel);
                        lastEpg.get.channelId = lastChannel.get
                    }
                    case 'E': {
                        lastEpg.get.eventData = data
                    }
                    case 'T': {
                        lastEpg.get.title = data
                    }
                    case 'S': {
                        lastEpg.get.shortText = data
                   }
                    case 'D': {
                        lastEpg.get.description = data
                    }
                    case 'R': {
                        lastEpg.get.parentalRating = data
                    }
                    case 'V': {
                        lastEpg.get.vps = Long.parseLong(data)
                    }
                    case 'e': {
                        if (lastEpg.get.channelId === null) {
                            lastEpg.get.channelId = lastChannel.get
                        }

                        lastEpg.get.genre = lastEpg.get.findPattern(Configuration.getInstance().epgGenre)
                        lastEpg.get.category = lastEpg.get.findPattern(Configuration.getInstance().epgCategory)
                        lastEpg.get.season = lastEpg.get.findPattern(Configuration.getInstance().epgSeriesSeason)
                        lastEpg.get.part = lastEpg.get.findPattern(Configuration.getInstance().epgSeriesPart)
                        lastEpg.get.parts = lastEpg.get.findPattern(Configuration.getInstance().epgSeriesParts)

                        for (custom : Configuration.getInstance().epgCustom) {
                            lastEpg.get.findPattern(custom)
                        }

                        result.add(lastEpg.get)
                        lastEpg.set(new Epg)
                    }
                    case 'L': {
                        lastEpg.get.lifetime = Integer.parseInt(data)
                    }
                    case 'P': {
                        lastEpg.get.priority = Integer.parseInt(data)
                    }
                    case '@': {
                        lastEpg.get.aux = data
                    }
                    default: {
                        /* do nothing */ /* X G */
                    }
                }
            }
        ]

        return result
    }

    static def List<Timer> parseTimer(List<String> input) {
        val result = new ArrayList<Timer>()

        input.forEach(s | {
            val timer = new Timer

            // get id
            val ix = s.indexOf(" ")
            timer.id = Integer.parseInt(s.substring(0, ix))

            val parts = s.substring(ix+1).split(":")

            // simple values
            timer.flags = Integer.parseInt(parts.get(0))
            timer.channelId = parts.get(1)
            timer.priority = Integer.parseInt(parts.get(5))
            timer.lifetime = Integer.parseInt(parts.get(6))
            timer.path = parts.get(7)

            try {
                timer.aux = parts.get(8)
            } catch (ArrayIndexOutOfBoundsException e) {
                timer.aux = null
            }

            // time values
            val byte[] time = newByteArrayOfSize(4)
            time.set(0, Byte.valueOf(parts.get(3).substring(0,2)))
            time.set(1, Byte.valueOf(parts.get(3).substring(2)))
            time.set(2, Byte.valueOf(parts.get(4).substring(0,2)))
            time.set(3, Byte.valueOf(parts.get(4).substring(2)))
            timer.time = time

            // date/weekday
            var String weekdays
            var String date

            val wd = parts.get(2)
            val idx = wd.indexOf('@')
            if (idx > 0) {
                weekdays = wd.substring(0, idx)
                date = wd.substring(idx+1)
            } else {
                if (wd.charAt(0) == '-'.charAt(0) || wd.charAt(0) == 'M'.charAt(0)) {
                    weekdays = wd
                } else {
                    date = wd
                }
            }

            timer.date = date
            timer.setWeekdays(weekdays)

            result.add(timer)
        })

        // analyze repeating timer and add them separately
        val repeatingTimer = new ArrayList<Timer>
        result.stream.filter(s | s.repeatingTimer).forEach(timer | {
            var LocalDate startDate = if (timer.startDate === null) LocalDate.now(Configuration.instance.defaultZoneId).minusDays(1)  else timer.startDate.minusDays(1)

            for (i : 1 ..< 8) {
                if (timer.isWeekday(DayOfWeek.of(i))) {
                    val newDates = startDate.next(DayOfWeek.of(i))

                    val newTimer1 = SerializationUtils.clone(timer);
                    newTimer1.startDate = newDates.get(0)
                    newTimer1.startEpoch = 0
                    newTimer1.endEpoch = 0

                    val newTimer2 = SerializationUtils.clone(timer);
                    newTimer2.startDate = newDates.get(1)
                    newTimer2.startEpoch = 0
                    newTimer2.endEpoch = 0

                    repeatingTimer.add(newTimer1)
                    repeatingTimer.add(newTimer2)
                }
            }
        })

        // remove all repeating timer and add the new ones
        val r = result.stream.filter(s | !s.isRepeatingTimer).collect(Collectors.toList)
        r.addAll(repeatingTimer)

        return r;
    }

    static def List<Recording> parseRecording(List<String> input) {
        val result = new ArrayList<Recording>()

        input.forEach(s | {
            val recording = new Recording

            val matcher = recordingPattern.matcher(s)
            if (!matcher.matches) {
                throw new RuntimeException("Probleme mit " + s)
            }

            recording.id = Long.parseLong(matcher.group(1))
            recording.path = matcher.group(5).trim
            recording.seen = matcher.group(4) != '*'
            recording.start = LocalDateTime.parse(matcher.group(2), recordingDateFormatter).toEpochSecond(DateTimeUtil.currentZoneOffset)

            val durationParts = matcher.group(3).split(":")
            recording.length = Integer.parseInt(durationParts.get(0)) * 60 * 60 + Integer.parseInt(durationParts.get(1)) * 60

            result.add(recording)
        })

        return result
    }

    static def parsePlugin(String line) {
        val matcher = pluginPattern.matcher(line)
        if (matcher.matches) {
            return new VdrPlugin(matcher.group(1), matcher.group(2), matcher.group(3))
        }

        return null
    }

    static def parseStat(String line) {
        val matcher = statPattern.matcher(line)
        if (matcher.matches) {
            return new VDRDiskStat(Long.parseLong(matcher.group(1)), Long.parseLong(matcher.group(2)))
        }

        return new VDRDiskStat(0,0)
    }

    static def parseEpgsearchList(String line) {
        val result = new EpgsearchSearchTimer
        val splitted = line.split(":")

        // save all values
        var i = 0
        for (EpgsearchSearchTimer.Field field : EpgsearchSearchTimer.Field.values){
            result.setField(field, splitted.get(i))
            i = i + 1
        }

        result.splitCategories

        if (line != result.createSvdrpLine()) {
            log.error("Mismatch found in epgsearch timer parsing/creating!")
            log.error("Original:  " + line)
            log.error("Generated: " + result.createSvdrpLine())
        }

        return result
    }

    @SuppressWarnings("unchecked")
    static def parseEpgsearchCategory(String line) {
        val splitted = line.split("\\|")
        val result = new EpgsearchCategory

        result.id = Integer.parseInt(splitted.get(0))
        result.internalName = splitted.get(1)
        result.publicName = splitted.get(2)

        if (splitted.get(3).isNotEmpty) {
            result.values = splitted.get(3).split(",").stream.collect(Collectors.toList)
        }

        if (splitted.length >= 5) {
            result.searchMode = Integer.valueOf(splitted.get(4))
        }

        return result
    }

    @SuppressWarnings("unchecked")
    static def parseEpgsearchChannelGroup(String line) {
        val splitted = line.split("\\|").stream.collect(Collectors.toList)
        val result = new EpgsearchChannelGroup

        result.name = splitted.remove(0)
        result.channelIds = splitted

        return result
    }

    static def VDROsd parseRemoteOsd(List<String> input) {
        val osd = new VDROsd

        input.forEach(s | {
            val type = String.valueOf(s.charAt(0))
            val line = s.substring(2)

            switch(type) {
                case 'T': osd.title = line
                case 'C': osd.addLayout(Integer.valueOf(line))
                case 'I': osd.addMenuItem(type, line)
                case 'S': osd.addMenuItem(type, line)
                case 'X': osd.textBlock = line
                case 'R': osd.red = line
                case 'G': osd.green = line
                case 'Y': osd.yellow = line
                case 'B': osd.blue = line
                case 'M': osd.statusMessage = line
            }
        })

        return osd
    }

    /* helper methods */
    private static def extractChannel(String line) {
        return line.substring(0, line.indexOf(" "))
    }

    private static def setEventData(Epg epg, String line) {
        try {
            val splitted = line.split(" ")
            epg.eventId = splitted.get(0)
            epg.startTime = Long.valueOf(splitted.get(1))
            epg.duration = Long.valueOf(splitted.get(2))
        } catch (Exception e) {
            // FIXME: Das ist keine Lösung

            println("Error: " + line)
            // e.printStackTrace
            System.exit(1)
        }
    }

    private static def next(LocalDate start, DayOfWeek day) {
        val today = LocalDate.now(Configuration.instance.defaultZoneId)
        var resultDate = start.with(TemporalAdjusters.next(day))

        while (resultDate.isBefore(today)) {
            resultDate = resultDate.with(TemporalAdjusters.next(day));
        }

        return #[resultDate, resultDate.with(TemporalAdjusters.next(day))]
    }
}
