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
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.Recording
import vdr.jonglisto.model.Timer
import vdr.jonglisto.model.VdrPlugin
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.util.Utils
import vdr.jonglisto.xtend.annotation.Log

@Log
class Parser {
    static val namePattern = Pattern.compile("(\\d+) (.*?) (.*?)(;(.*?))*:(\\d+):(.*?)$")
    static val recordingPattern = Pattern.compile("(\\d+) (\\d{2}.\\d{2}.\\d{2} \\d{2}:\\d{2}) (\\d+:\\d+)(\\*?) (.*)$")
    static val recordingDateFormatter = DateTimeFormatter.ofPattern("dd.MM.yy HH:mm");
    static val pluginPattern = Pattern.compile("^(.*?) (.*?) - (.*?)$")

    static def List<Channel> parseChannel(List<String> input) {
        val result = new ArrayList<Channel>()
        val lastGroup = new AtomicReference<String>()

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

                    val idx = s.indexOf(" ")
                    ch.raw = s.substring(idx+1)

                    ch.group = lastGroup.get
                    ch.radio = "0" == sp.get(5) || "1" == sp.get(5)

                    ch.encrypted = "0" != sp.get(8)
                    ch.source = sp.get(3)
                    ch.number = Integer.valueOf(matcher.group(1))
                    ch.id = matcher.group(2)
                    ch.bouquet = matcher.group(5)
                    ch.frequence = Long.valueOf(matcher.group(6))
                    if (ch.frequence == 0) {
                        ch.frequence = null
                    }

                    val idx2 = matcher.group(3).indexOf(",")
                    if (idx2 == -1) {
                        ch.name = matcher.group(3).trim
                    } else {
                        ch.name = matcher.group(3).substring(0, idx2).trim
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

                        lastEpg.get.genre = lastEpg.get.findPattern(Configuration.get.epgGenre)
                        lastEpg.get.category = lastEpg.get.findPattern(Configuration.get.epgCategory)
                        lastEpg.get.season = lastEpg.get.findPattern(Configuration.get.epgSeriesSeason)
                        lastEpg.get.part = lastEpg.get.findPattern(Configuration.get.epgSeriesPart)
                        lastEpg.get.parts = lastEpg.get.findPattern(Configuration.get.epgSeriesParts)

                        for (custom : Configuration.get.epgCustom) {
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
            var LocalDate startDate = if (timer.startDate === null) LocalDate.now.minusDays(1)  else timer.startDate.minusDays(1)

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

    def static parsePlugin(String line) {
        val matcher = pluginPattern.matcher(line)
        if (matcher.matches) {
            return new VdrPlugin(matcher.group(1), matcher.group(2), matcher.group(3))
        }

        return null
    }

    def static parseEpgsearchList(String line) {
        val result = new EpgsearchSearchTimer
        val splitted = line.split(":")

        // save all values
        var i = 0
        for (EpgsearchSearchTimer.Field field : EpgsearchSearchTimer.Field.values){
            result.setField(field, splitted.get(i))
            i = i + 1
        }

        return result
    }

/*
       ($timer->{id},               # 1 - unique search timer id
         $timer->{pattern},          # 2 - the search term
         $timer->{use_time},         # 3 - use time? 0/1
         $timer->{time_start},       # 4 - start time in HHMM
         $timer->{time_stop},        # 5 - stop time in HHMM
         $timer->{use_channel},      # 6 - use channel? 0 = no,  1 = Intervall, 2 = Channel group, 3 = FTA only
         $timer->{channels},         # 7 - if 'use channel' = 1 then channel id[|channel id] in vdr format,
                                     #     one entry or min/max entry separated with |, if 'use channel' = 2
                                     #     then the channel group name
         $timer->{matchcase},        # 8 - match case? 0/1
         $timer->{mode},             # 9 - search mode:
                                     #      0 - the whole term must appear as substring
                                     #      1 - all single terms (delimiters are blank,',', ';', '|' or '~')
                                     #          must exist as substrings.
                                     #      2 - at least one term (delimiters are blank, ',', ';', '|' or '~')
                                     #          must exist as substring.
                                     #      3 - matches exactly
                                     #      4 - regular expression
         $timer->{use_title},        #10 - use title? 0/1
         $timer->{use_subtitle},     #11 - use subtitle? 0/1
         $timer->{use_descr},        #12 - use description? 0/1
         $timer->{use_duration},     #13 - use duration? 0/1
         $timer->{min_duration},     #14 - min duration in minutes
         $timer->{max_duration},     #15 - max duration in minutes
         $timer->{has_action},       #16 - use as search timer? 0/1
         $timer->{use_days},         #17 - use day of week? 0/1
         $timer->{which_days},       #18 - day of week (0 = sunday, 1 = monday...)
         $timer->{is_series},        #19 - use series recording? 0/1
         $timer->{directory},        #20 - directory for recording
         $timer->{prio},             #21 - priority of recording
         $timer->{lft},              #22 - lifetime of recording
         $timer->{bstart},           #23 - time margin for start in minutes
         $timer->{bstop},            #24 - time margin for stop in minutes
         $timer->{use_vps},          #25 - use VPS? 0/1
         $timer->{action},           #26 - action:
                                     #      0 = create a timer
                                     #      1 = announce only via OSD (no timer)
                                     #      2 = switch only (no timer)
         $timer->{use_extepg},       #27 - use extended EPG info? 0/1  #TODO
         $timer->{extepg_infos},     #28 - extended EPG info values. This entry has the following format #TODO
                                     #     (delimiter is '|' for each category, '#' separates id and value):
                                     #     1 - the id of the extended EPG info category as specified in
                                     #         epgsearchcats.conf
                                     #     2 - the value of the extended EPG info category
                                     #         (a ':' will be tranlated to "!^colon^!", e.g. in "16:9")
         $timer->{avoid_repeats},    #29 - avoid repeats? 0/1
         $timer->{allowed_repeats},  #30 - allowed repeats
         $timer->{comp_title},       #31 - compare title when testing for a repeat? 0/1
         $timer->{comp_subtitle},    #32 - compare subtitle when testing for a repeat? 0/1
         $timer->{comp_descr},       #33 - compare description when testing for a repeat? 0/1
         $timer->{comp_extepg_info}, #34 - compare extended EPG info when testing for a repeat? #TODO
                                     #     This entry is a bit field of the category ids.
         $timer->{repeats_in_days},  #35 - accepts repeats only within x days
         $timer->{delete_after},     #36 - delete a recording automatically after x days
         $timer->{keep_recordings},  #37 - but keep this number of recordings anyway
         $timer->{switch_before},    #38 - minutes before switch (if action = 2)
         $timer->{pause},            #39 - pause if x recordings already exist
         $timer->{use_blacklists},   #40 - blacklist usage mode (0 none, 1 selection, 2 all)
         $timer->{sel_blacklists},   #41 - selected blacklist IDs separated with '|'
         $timer->{fuzzy_tolerance},  #42 - fuzzy tolerance value for fuzzy searching
         $timer->{use_for_fav},      #43 - use this search in favorites menu (0 no, 1 yes)
         $timer->{results_menu},           #44 - menu to display results
         $timer->{autodelete},             #45 - delMode ( 0 = no autodelete, 1 = after x recordings, 2 = after y days after 1. recording)
         $timer->{del_after_recs},         #46 - delAfterCountRecs (x recordings)
         $timer->{del_after_days},         #47 - delAfterDaysOfFirstRec (y days)
         $timer->{searchtimer_from},       #48 - useAsSearchTimerFrom (if "use as search timer?" = 2)
         $timer->{searchtimer_until},      #49 - useAsSearchTimerTil (if "use as search timer?" = 2)
         $timer->{ignore_missing_epgcats}, #50 - ignoreMissingEPGCats
         $timer->{unmute},                 #51 - unmute sound if off when used as switch timer
         $timer->{min_match},              #52 - the minimum required match in percent when descriptions are compared to avoid repeats (-> 33)
         $timer->{unused}) = split(/:/, $line);
*/

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
        val today = LocalDate.now
        var resultDate = start.with(TemporalAdjusters.next(day))

        while (resultDate.isBefore(today)) {
            resultDate = resultDate.with(TemporalAdjusters.next(day));
        }

        return #[resultDate, resultDate.with(TemporalAdjusters.next(day))] as List<LocalDate>
    }

    private static class LoopBreakException extends RuntimeException {
    }
}
