package vdr.jonglisto.logging

import ch.qos.logback.classic.Logger
import ch.qos.logback.classic.LoggerContext
import org.slf4j.LoggerFactory
import java.util.stream.Collectors
import ch.qos.logback.core.FileAppender
import java.io.File
import ch.qos.logback.classic.Level
import ch.qos.logback.core.Appender
import ch.qos.logback.core.rolling.RollingFileAppender
import ch.qos.logback.core.rolling.FixedWindowRollingPolicy

class LogUtil {

    public static def getConfiguredLoggers() {
        getAllLoggers.stream().filter(s | s.level !== null && getAppender(s) !== null)
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

    public static def getLevel(String level) {
        return Level.toLevel(level)
    }

    public static def getLoggerName(Logger logger) {
        logger.name
    }

    public static def setAppender(Logger logger, Appender appender) {
        val l = logger.appender

        if (l !== null && l.name.equals(appender.name)) {
            // appender already exists
            return
        }

        logger.addAppender(appender)

        if (l !== null) {
            logger.detachAppender(l)
        }
    }

    public static def setLevel(Logger logger, Level level) {
        logger.level = level
    }

    public static def disableLogger(Logger logger) {
        val l = logger.appender
        logger.level = Level.OFF

        if (l !== null) {
            logger.detachAppender(l)
        }
    }

    public static def getLogDirectory() {
        val app = getAppender("FILE") as RollingFileAppender
        return new File(app.file).parent
    }

    public static def setLogDirectory(String dir) {
        val app = getAppender("FILE") as RollingFileAppender
        app.file = dir + "/jonglisto-ng.log"

        val policy = app.rollingPolicy as FixedWindowRollingPolicy
        policy.fileNamePattern = dir + "/jonglisto-ng.%i.log"
    }
}
