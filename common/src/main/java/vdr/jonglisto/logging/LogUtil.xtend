package vdr.jonglisto.logging

import ch.qos.logback.classic.Level
import ch.qos.logback.classic.Logger
import ch.qos.logback.classic.LoggerContext
import ch.qos.logback.classic.net.SyslogAppender
import ch.qos.logback.core.Appender
import ch.qos.logback.core.rolling.FixedWindowRollingPolicy
import ch.qos.logback.core.rolling.RollingFileAppender
import java.io.File
import java.util.stream.Collectors
import org.slf4j.LoggerFactory
import java.util.Properties
import vdr.jonglisto.configuration.Configuration
import java.io.FileWriter
import java.io.FileReader
import vdr.jonglisto.xtend.annotation.Log
import java.io.IOException
import ch.qos.logback.classic.spi.ILoggingEvent

@Log("jonglisto.logutil")
class LogUtil {

    static def saveConfig() {
        val prop = new Properties()

        // directory
        prop.put("LogDirectory", logDirectory)

        // syslog
        prop.put("SyslogFacility", syslogFacility)

        configuredLoggers.forEach(s | {
            val app = getAppender(s)
            val level = getLogLevel(s)

            prop.put("appender." + s.name, app.name)
            prop.put("level." + s.name, level)
        })

        log.info("Save logging configuration to " + Configuration.getInstance.customDirectory + "/jonglisto-logging.cfg")

        try {
            val out = new FileWriter(new File(Configuration.getInstance.customDirectory + "/jonglisto-logging.cfg"))
            prop.store(out, "custom jonglisto-ng logging configuration")
        } catch (IOException exc) {
            throw new RuntimeException("unable to save " + Configuration.getInstance.customDirectory + "/jonglisto-logging.cfg", exc)
        }       
    }

    static def loadConfig() {
        try {
            log.info("Read logging configuration from " + Configuration.getInstance.customDirectory + "/jonglisto-logging.cfg")

            val reader = new FileReader(new File(Configuration.getInstance.customDirectory + "/jonglisto-logging.cfg"))
            val prop = new Properties
            prop.load(reader)

            logDirectory = prop.get("LogDirectory") as String
            syslogFacility = prop.get("SyslogFacility") as String

            prop.keySet.stream().forEach(s | {
                val k = s as String
                if (k.startsWith("appender.")) {
                    val name = k.substring("appender.".length)
                    val l = allLoggers.findFirst[x | x.name == name]

                    log.info("Set Appender for " + name + " to " + prop.get(k))

                    if (l !== null) {
                        setAppender(l, getAppender(prop.get(k) as String))
                    }
                } else if (k.startsWith("level.")) {
                    val name = k.substring("level.".length)

                    val l = allLoggers.findFirst[x | x.name == name]

                    log.info("Set Level for " + name + " to " + prop.get(k))

                    if (l !== null) {
                        setLevel(l, getLevel(prop.get(k) as String))
                    }
                }
            })
        } catch (Exception e) {
            // custom configuration do not exists or has some errors -> fallback to default
            log.warn("Unable to read logging configuration " + Configuration.getInstance.customDirectory + "/jonglisto-logging.cfg", e)
            return
        }
    }

    static def getConfiguredLoggers() {
        getAllLoggers.stream().filter(s | s.level !== null && getAppender(s) !== null)
    }

    static def getAllLoggers() {
        val ctx = LoggerFactory.getILoggerFactory() as LoggerContext
        return ctx.loggerList.stream().filter(s | !"AppenderHolder".equals(s.name)).collect(Collectors.toList())
    }

    static def getAppender(String name) {
        val root = LoggerFactory.getLogger("AppenderHolder") as Logger
        return root.getAppender(name)
    }

    static def getAppender(Logger logger) {
        val apps = logger.iteratorForAppenders.toList
        if (apps.size > 0) {
            return apps.get(0);
        } else {
            return null;
        }
    }

    static def getLogLevel(Logger logger) {
        return if (logger.level !== null) logger.level.levelStr else "OFF"
    }

    static def getLevel(String level) {
        return Level.toLevel(level)
    }

    static def getLoggerName(Logger logger) {
        logger.name
    }

    static def setAppender(Logger logger, Appender<ILoggingEvent> appender) {
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

    static def setLevel(Logger logger, Level level) {
        logger.level = level
    }

    static def disableLogger(Logger logger) {
        val l = logger.appender
        logger.level = Level.OFF

        if (l !== null) {
            logger.detachAppender(l)
        }
    }

    static def getLogDirectory() {
        val app = getAppender("FILE") as RollingFileAppender<ILoggingEvent>
        return new File(app.file).parent
    }

    static def getSyslogFacility() {
        val app = getAppender("SYSLOG") as SyslogAppender
        return app.facility
    }

    static def setLogDirectory(String dir) {
        val app = getAppender("FILE") as RollingFileAppender<ILoggingEvent>
        app.file = dir + "/jonglisto-ng.log"

        val policy = app.rollingPolicy as FixedWindowRollingPolicy
        policy.fileNamePattern = dir + "/jonglisto-ng.%i.log"
    }

    static def setSyslogFacility(String fac) {
        val app = getAppender("SYSLOG") as SyslogAppender
        app.facility = fac
    }
}
