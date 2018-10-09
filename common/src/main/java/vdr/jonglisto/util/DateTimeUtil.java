package vdr.jonglisto.util;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

import vdr.jonglisto.configuration.Configuration;

public class DateTimeUtil {

    public static String toTime(long unixTime, String timeFormat) {
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern(timeFormat);
        return LocalDateTime.ofInstant(Instant.ofEpochSecond(unixTime), Configuration.getInstance().getDefaultZoneId()).toLocalTime().format(timeFormatter);
    }

    public static String toDurationTime(long unixTime, String timeFormat) {
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern(timeFormat);
        return LocalDateTime.ofInstant(Instant.ofEpochSecond(unixTime), ZoneId.of("UTC")).toLocalTime().format(timeFormatter);
    }

    public static String toTime(String timeFormat) {
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern(timeFormat);
        return LocalDateTime.now(Configuration.getInstance().getDefaultZoneId()).format(timeFormatter);
    }

    public static String toDate(long unixTime, String dateFormat) {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern(dateFormat);
        return LocalDateTime.ofInstant(Instant.ofEpochSecond(unixTime), Configuration.getInstance().getDefaultZoneId()).toLocalDate().format(dateFormatter);
    }

    public static String toDate(LocalDateTime ldt, String dateFormat) {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern(dateFormat);
        return ldt.format(dateFormatter);
    }

    public static String toTime(LocalDateTime ldt, String timeFormat) {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern(timeFormat);
        return ldt.format(dateFormatter);
    }

    public static String toDateName(long unixTime, String dateFormat) {
        return toDate(unixTime, "EEEE, " + dateFormat);
    }

    public static LocalDateTime toDateTime(long unixTime) {
        return LocalDateTime.ofInstant(Instant.ofEpochSecond(unixTime), Configuration.getInstance().getDefaultZoneId());
    }

    public static ZoneOffset getCurrentZoneOffset() {
        Instant instant = Instant.now();
        ZoneId systemZone = Configuration.getInstance().getDefaultZoneId();
        return systemZone.getRules().getOffset(instant);
    }
}
