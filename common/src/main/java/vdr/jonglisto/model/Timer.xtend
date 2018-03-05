package vdr.jonglisto.model

import java.io.Serializable
import java.time.DayOfWeek
import java.time.Instant
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import vdr.jonglisto.util.DateTimeUtil
import java.util.regex.Pattern

@Accessors
@EqualsHashCode
@ToString
class Timer extends BaseData implements Serializable {
    public enum SearchType {
        EPGSEARCH, EPGD, EPG2TIMER
    }

    static val epgsearchPattern = Pattern.compile(".*?<epgsearch>.*?<searchtimer>(.*?)</searchtimer>.*?");
    static val epgdPattern = Pattern.compile(".*?<epgd>.*?<autotimerid>(.*?)</autotimerid>.*?");
    static val epg2timerPattern = Pattern.compile(".*?<epg2timer>(.*?)</epg2timer>.*?");
    static val remoteTimersPattern = Pattern.compile(".*?<remotetimers>(.*?)</remotetimers>.*?");

    static val dateParseFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    static val timeParseFormatter = DateTimeFormatter.ofPattern("HH:mm")
    static val currentZoneOffset = DateTimeUtil.currentZoneOffset

    private static val ENABLED = 1;
    private static val INSTANT = (1 << 1);
    private static val VPS     = (1 << 2);
    private static val ACTIVE  = (1 << 3);

    private var int id
    private var String channelId
    private var String days
    private var String date
    private var byte[] time = newByteArrayOfSize(4)
    private var int priority
    private var int lifetime
    private var String path
    private var String aux
    private var int flags

    private boolean isRemote
    private boolean isRemoteTimer
    private boolean isEpgdTimer
    private boolean isEpgsearchTimer
    private boolean isEpg2TimerTimer
    private SearchType searchType;
    private String searchName
    private String remoteTimerId;

    private var long startEpoch
    private var long endEpoch
    private var long duration

    def isWeekday(DayOfWeek day) {
        if (days === null) {
            return true
        }

        switch(day) {
            case MONDAY:    return days.charAt(0) == 'M'.charAt(0)
            case TUESDAY:   return days.charAt(1) == 'T'.charAt(0)
            case WEDNESDAY: return days.charAt(2) == 'W'.charAt(0)
            case THURSDAY:  return days.charAt(3) == 'T'.charAt(0)
            case FRIDAY:    return days.charAt(4) == 'F'.charAt(0)
            case SATURDAY:  return days.charAt(5) == 'S'.charAt(0)
            case SUNDAY:    return days.charAt(6) == 'S'.charAt(0)
        }
    }

    def void setWeekday(DayOfWeek day, boolean active) {
        if (days === null) {
            days = "-------"
        }

        val sb = new StringBuilder(days);

        switch(day) {
            case MONDAY: {
                    if (active) {
                        sb.setCharAt(0, 'M'.charAt(0))
                    } else {
                        sb.setCharAt(0, '-'.charAt(0))
                    }
                }

            case TUESDAY: {
                    if (active) {
                        sb.setCharAt(1, 'T'.charAt(0))
                    } else {
                        sb.setCharAt(1, '-'.charAt(0))
                    }
                }

            case WEDNESDAY: {
                    if (active) {
                        sb.setCharAt(2, 'W'.charAt(0))
                    } else {
                        sb.setCharAt(2, '-'.charAt(0))
                    }
                }

            case THURSDAY: {
                    if (active) {
                        sb.setCharAt(3, 'T'.charAt(0))
                    } else {
                        sb.setCharAt(3, '-'.charAt(0))
                    }
                }

            case FRIDAY: {
                    if (active) {
                        sb.setCharAt(4, 'F'.charAt(0))
                    } else {
                        sb.setCharAt(4, '-'.charAt(0))
                    }
                }

            case SATURDAY: {
                    if (active) {
                        sb.setCharAt(5, 'S'.charAt(0))
                    } else {
                        sb.setCharAt(5, '-'.charAt(0))
                    }
                }

            case SUNDAY: {
                    if (active) {
                        sb.setCharAt(6, 'S'.charAt(0))
                    } else {
                        sb.setCharAt(6, '-'.charAt(0))
                    }
                }
        }

        days = sb.toString

        if (days == '-------') {
            days = null
        }
    }

    def setWeekdays(String wd) {
        days = wd
    }

    def isRepeatingTimer() {
        return days !== null
    }

    def isEnabled() {
        return flags.bitwiseAnd(ENABLED) == ENABLED
    }

    def void setEnabled(boolean b) {
        if (b) {
            flags = flags.bitwiseOr(ENABLED)
        } else {
            flags = flags.bitwiseAnd(ENABLED.bitwiseNot)
        }
    }

    def isVps() {
        return flags.bitwiseAnd(VPS) == VPS
    }

    def void setVps(boolean b) {
        if (b) {
            flags = flags.bitwiseOr(VPS)
        } else {
            flags = flags.bitwiseAnd(VPS.bitwiseNot)
        }
    }

    def isInstant() {
        return flags.bitwiseAnd(INSTANT) == INSTANT
    }

    def isActive() {
        return flags.bitwiseAnd(ACTIVE) == ACTIVE
    }

    def getStartTime() {
        if (startEpoch === 0 && date !== null) {
            val start = LocalDateTime.from(LocalDate.parse(date, dateParseFormatter).atStartOfDay());
            startEpoch = start.withHour(time.get(0) as int).withMinute(time.get(1) as int).toEpochSecond(currentZoneOffset)
        }

        return startEpoch
    }

    def getEndTime() {
        if (endEpoch === 0 && date !== null) {
            val end = LocalDateTime.from(LocalDate.parse(date, dateParseFormatter).atStartOfDay());

            var dayAdjust = 0
            if ((time.get(0) * 60 + time.get(1)) > (time.get(2) * 60 + time.get(3))) {
                dayAdjust = 1
            }

            endEpoch = end.withHour(time.get(2) as int).withMinute(time.get(3) as int).plusDays(dayAdjust).toEpochSecond(currentZoneOffset)
        }

        return endEpoch
    }

     def getDuration() {
        if (duration === 0) {
            duration = endTime - startTime
        }

        return duration
    }

    def getStartAsString() {
        var builder = new StringBuilder
        return builder.append(String.format("%02d", time.get(0))).append(":").append(String.format("%02d", time.get(1))).toString
    }

    def setStartAsString(String timeValue) {
        val sp = timeValue.split(":")
        time.set(0, new Byte(sp.get(0)).byteValue)
        time.set(1, new Byte(sp.get(1)).byteValue)
    }

    def setEndAsString(String timeValue) {
        val sp = timeValue.split(":")
        time.set(2, new Byte(sp.get(0)).byteValue)
        time.set(3, new Byte(sp.get(1)).byteValue)
    }

    def getEndAsString() {
        var builder = new StringBuilder
        return builder.append(String.format("%02d", time.get(2))).append(":").append(String.format("%02d", time.get(3))).toString
    }

    def getStartDate() {
        LocalDateTime.ofInstant(Instant.ofEpochSecond(startTime), ZoneId.systemDefault()).toLocalDate()
    }

    def getEndDate() {
        LocalDateTime.ofInstant(Instant.ofEpochSecond(startTime + getDuration), ZoneId.systemDefault()).toLocalDate()
    }

    def getStartDateTime() {
        LocalDateTime.ofInstant(Instant.ofEpochSecond(startTime), ZoneId.systemDefault())
    }

    def getEndDateTime() {
        LocalDateTime.ofInstant(Instant.ofEpochSecond(startTime + getDuration), ZoneId.systemDefault())
    }

    def setStartDate(LocalDate date) {
        date = date.format(dateParseFormatter)
    }

    def setStartEpoch(long epoch) {
        val dateTime = LocalDateTime.ofInstant(Instant.ofEpochSecond(epoch), ZoneId.systemDefault())
        setStartDate(dateTime.toLocalDate())
        setStartAsString(dateTime.format(timeParseFormatter))
    }

    def setEndEpoch(long epoch) {
        val dateTime = LocalDateTime.ofInstant(Instant.ofEpochSecond(epoch), ZoneId.systemDefault())
        setEndAsString(dateTime.format(timeParseFormatter))
    }

    def setRemote(boolean rem) {
        isRemote = rem
    }

    def updateSearchTimerInfo() {
        // is this an epgsearch timer?
        val epgsearchMatcher = epgsearchPattern.matcher(aux)
        if (epgsearchMatcher.matches()) {
            searchType = SearchType.EPGSEARCH
            searchName = epgsearchMatcher.group(1)
        }

        // is this an epg2timer timer?
        val epg2timerMatcher = epg2timerPattern.matcher(aux)
        if (epg2timerMatcher.matches()) {
            searchType = SearchType.EPG2TIMER
            searchName = epgsearchMatcher.group(1)
        }

        // is this an epgd timer?
        val epgdMatcher = epgdPattern.matcher(aux)
        if (epgdMatcher.matches()) {
            searchType = SearchType.EPGD
            searchName = epgdMatcher.group(1);
        }

        // is this a remote timer?
        val remoteMatcher = remoteTimersPattern.matcher(aux)
        if (remoteMatcher.matches()) {
            remoteTimerId = remoteMatcher.group(1)
        }
    }

    def toVdrString() {
        val sb = new StringBuilder().append(flags).append(":").append(channelId).append(":")

        if (days !== null) {
            sb.append(days)

            if (date !== null) {
                sb.append("@")
            }
        }

        if (date !== null) {
            sb.append(date)
        }

        sb.append(":")
        sb.append(String.format("%02d%02d:%02d%02d:%d:%d:%s:", time.get(0), time.get(1), time.get(2), time.get(3), priority, lifetime, path))
        if (aux !== null) {
            sb.append(aux)
        }

        return sb.toString
    }
}
