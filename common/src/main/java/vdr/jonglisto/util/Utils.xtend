package vdr.jonglisto.util

import com.cronutils.model.Cron
import com.cronutils.model.CronType
import com.cronutils.model.definition.CronDefinitionBuilder
import com.cronutils.model.time.ExecutionTime
import com.cronutils.parser.CronParser
import java.io.Closeable
import org.threeten.bp.Instant
import org.threeten.bp.ZoneId
import org.threeten.bp.ZonedDateTime

import static extension org.apache.commons.lang3.StringUtils.*
import java.util.concurrent.ThreadLocalRandom
import vdr.jonglisto.configuration.Configuration
import java.io.IOException

class Utils {

    static def normalizeChannelName(String name) {
        return name.stripAccents //
        .replaceAll("\\&", "and") //
        .replaceAll("\\+", "plus") //
        .replaceAll("\\*", "star") //
        .replaceAll("HD 1", "1") //
        .replaceAll("HD 2", "2") //
        .replaceAll("HD 3", "3") //
        .replaceAll("HD 4", "4") //
        .replaceAll("HD 5", "5") //
        .replaceAll("HD 6", "6") //
        .replaceAll("HD 7", "7") //
        .replaceAll("HD 8", "8") //
        .replaceAll("HD 9", "9") //
        .replaceAll("II", "2") //
        .replaceAll("III", "3") //
        .replaceAll("7", "sieben") //
        .replaceAll("\\s+\\(*HD\\)*$", "") //
        .replaceAll("\\s+\\(S\\)$", "") //
        .replaceAll("\\s+\\(*HD\\)*$", "") //
        .replaceAll("[^A-Za-z0-9]", "") //
        .trim() //
        .toLowerCase();
    }

    static val CronParser QUARTZ_CRON_PARSER = new CronParser(CronDefinitionBuilder.instanceDefinitionFor(CronType.QUARTZ));

    def static nextRand() {
        return ThreadLocalRandom.current().nextInt(Integer.MAX_VALUE);
    }

    def static getNextScheduleTime(String cronAsString, String dateFormat, String timeFormat) {
        val cron = QUARTZ_CRON_PARSER.parse(cronAsString)
        val nextTime = nextExecutionInMillis(System.currentTimeMillis(), cron) / 1000;

        if (nextTime == 0) {
            return "-"
        } else {
            return DateTimeUtil.toDate(nextTime, dateFormat) + " " + DateTimeUtil.toTime(nextTime, timeFormat)
        }
    }

    def static getNextScheduleTime(String cronAsString) {
        val cron = QUARTZ_CRON_PARSER.parse(cronAsString)
        return nextExecutionInMillis(System.currentTimeMillis(), cron) / 1000;
    }

    def static long nextExecutionInMillis(long currentTimeInMillis, String timeFormat) {
        val cron = QUARTZ_CRON_PARSER.parse(timeFormat)
        return nextExecutionInMillis(System.currentTimeMillis(), cron) / 1000;
    }

    private def static long nextExecutionInMillis(long currentTimeInMillis, Cron cron) {
        try {
            val currentInstant = Instant.ofEpochMilli(currentTimeInMillis);
            return ExecutionTime.forCron(cron).timeToNextExecution(ZonedDateTime.ofInstant(currentInstant, ZoneId.of(Configuration.instance.defaultZoneStr)))
                    .transform(s | currentInstant.plus(s).toEpochMilli())
                    .or(-1L);
        } catch (Exception e) {
            // ignore
            return -1L;
        }
    }

    /**
     * Executes a procedure on a resource (i.e.: an object that's {@link Closeable})
     * which takes care of closing the resource properly, even in case the procedure
     * exits prematurely through an exception.
     *
     * Adapted from: http://matcherror.blogspot.nl/2013/08/implementing-try-with-resources-in-xtend.html by John Kozlov.
     * Copied from: https://github.com/dslmeinte/Xtend-utils by Meinte Boersma.
     */
    def static <T extends Closeable, R> R using(T resource, (T)=>R procedure) {
        // this value is kept in case a Throwable from close() overwrites a Throwable from try {}:
        var Throwable mainThrowable
        try {
            procedure.apply(resource)
        } catch (Throwable t) {
            mainThrowable = t
            throw new RuntimeException(t)
        } finally {
            if (mainThrowable === null) {
                if (resource !== null) {
                    try {
                        resource.close
                    } catch (IOException exc) {
                        // ignore
                    }
                }
            } else {
                try {
                    resource.close
                } catch (Throwable unused) {
                    // (ignore because mainThrowable is present)
                }
            }
        }
    }
}
