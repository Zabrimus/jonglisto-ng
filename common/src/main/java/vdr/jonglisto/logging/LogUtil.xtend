package vdr.jonglisto.logging

import ch.qos.logback.classic.Logger
import ch.qos.logback.classic.LoggerContext
import org.slf4j.LoggerFactory
import java.util.stream.Collectors

class LogUtil {

    public static def getConfiguredLoggers() {
        getAllLoggers.stream().filter(s | s.level !== null || getAppender(s) !== null)
    }

    public static def getAllLoggers() {
        val ctx = LoggerFactory.getILoggerFactory() as LoggerContext
        return ctx.loggerList.stream().filter(s | !"AppenderHolder".equals(s.name)).collect(Collectors.toList())
    }

    public static def getAppender(String name) {
        val root = LoggerFactory.getLogger("AppenderHolder") as Logger
        return root.getAppender(name)
    }

    public static def getAppender(Logger logger) {
        val apps = logger.iteratorForAppenders.toList
        if (apps.size > 0) {
            return apps.get(0);
        } else {
            return null;
        }
    }

    public static def getLogLevel(Logger logger) {
        return if (logger.level !== null) logger.level.levelStr else "OFF"
    }

    public static def getLoggerName(Logger logger) {
        logger.name
    }

}
