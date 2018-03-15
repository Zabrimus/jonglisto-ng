package vdr.jonglisto.logging

import ch.qos.logback.classic.LoggerContext
import org.slf4j.LoggerFactory
import ch.qos.logback.classic.Logger

class LogUtil {

    public static def getConfiguredLoggers() {
        getAllLoggers.stream().filter(s | s.level !== null || getAllAppender(s).size > 0)
    }

    public static def getAllLoggers() {
        val ctx = LoggerFactory.getILoggerFactory() as LoggerContext
        return ctx.loggerList
    }

    public static def getAllAppender(Logger logger) {
        logger.iteratorForAppenders.toList
    }

    public static def getLogLevel(Logger logger) {
        logger.level.toString
    }

    public static def getLoggerName(Logger logger) {
        logger.name
    }

}
