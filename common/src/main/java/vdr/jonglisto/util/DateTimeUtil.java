package vdr.jonglisto.util;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

public class DateTimeUtil {

    public static String toTime(long unixTime, String timeFormat) {
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern(timeFormat);
        return LocalDateTime.ofInstant(Instant.ofEpochSecond(unixTime), ZoneId.systemDefault()).toLocalTime().format(timeFormatter);
    }

    public static String toDurationTime(long unixTime, String timeFormat) {
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern(timeFormat);
        return LocalDateTime.ofInstant(Instant.ofEpochSecond(unixTime), ZoneId.of("UTC")).toLocalTime().format(timeFormatter);
    }

    public static String toTime(String timeFormat) {
        return toTime(Math.toIntExact(System.currentTimeMillis() / 1000L), timeFormat);
    }

    public static String toDate(long unixTime, String dateFormat) {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern(dateFormat);
        return LocalDateTime.ofInstant(Instant.ofEpochSecond(unixTime), ZoneId.systemDefault()).toLocalDate().format(dateFormatter);
    }

    public static String toDateName(long unixTime, String dateFormat) {
        return toDate(unixTime, "EEEE, " + dateFormat);
    }

    public static LocalDateTime toDateTime(long unixTime) {
        return LocalDateTime.ofInstant(Instant.ofEpochSecond(unixTime), ZoneId.systemDefault());
    }

    public static ZoneOffset getCurrentZoneOffset() {
        Instant instant = Instant.now();
        ZoneId systemZone = ZoneId.systemDefault();
        return systemZone.getRules().getOffset(instant);
    }
}
