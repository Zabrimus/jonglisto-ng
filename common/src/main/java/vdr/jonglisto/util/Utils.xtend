package vdr.jonglisto.util

import java.io.Closeable
import vdr.jonglisto.configuration.Configuration

import static extension org.apache.commons.lang3.StringUtils.*

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
            throw t
        } finally {
            if (mainThrowable === null) {
                resource.close
            } else {
                try {
                    resource.close
                } catch (Throwable unused) {
                    // (ignore because mainThrowable is present)
                }
            }
        }
    }

    def static Configuration getJonglisto() {
        return Configuration.get
    }
}
