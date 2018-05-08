package vdr.jonglisto.web.ui.component

import ch.qos.logback.classic.Logger
import com.vaadin.data.provider.ListDataProvider
import com.vaadin.ui.Composite
import com.vaadin.ui.Grid
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.Notification
import com.vaadin.ui.TextField
import com.vaadin.ui.renderers.ComponentRenderer
import java.io.File
import java.util.HashMap
import java.util.Map
import vdr.jonglisto.logging.LogUtil

import static vdr.jonglisto.logging.LogUtil.*
import static vdr.jonglisto.web.xtend.UIBuilder.*

// @Log("jonglisto.web")
@SuppressWarnings("serial", "unchecked")
class LoggingComponent extends Composite {
//    @Inject
//    private Messages messages

    Grid<Logger> grid
    Map<String, NativeSelect<String>> levelSelectBoxes = new HashMap<String, NativeSelect<String>>
    Map<String, NativeSelect<String>> appenderSelectBoxes = new HashMap<String, NativeSelect<String>>

    TextField logfileField
    NativeSelect<String> syslogSelect

    def showAll() {
        createLayout()
        return this
    }

    private def void createLayout() {
        grid = new Grid
        grid.setSizeFull

        grid.addColumn(s| getLoggerName(s)) //
                .setCaption("Logger") //
                .setId("NAME") //
                .setExpandRatio(1) //
                .setMinimumWidthFromContent(true)

        grid.addColumn(s| changeLogLevel(s)) //
                .setCaption("Log Level") //
                .setId("LOGLEVEL") //
                .setRenderer(new ComponentRenderer())
                .setExpandRatio(1) //
                .setMinimumWidthFromContent(true)

        grid.addColumn(s| changeAppender(s)) //
                .setCaption("Appender") //
                .setId("Appender") //
                .setRenderer(new ComponentRenderer())
                .setExpandRatio(1) //
                .setMinimumWidthFromContent(true)

        val root = verticalLayout [
            horizontalLayout(it) [
               button(it, "Configured Loggers") [
                    addClickListener(s | {
                        levelSelectBoxes.clear
                        appenderSelectBoxes.clear
                        grid.items = LogUtil.configuredLoggers.filter[app | !"AppenderHolder".equals(app.name)]
                    })
                ]

                button(it, "All Loggers") [
                    addClickListener(s | {
                        levelSelectBoxes.clear
                        appenderSelectBoxes.clear
                        grid.items = LogUtil.allLoggers.filter[app | !"AppenderHolder".equals(app.name)]
                    })
                ]

                button(it, "Save/Update configuration") [
                    addClickListener(s | {
                        saveUpdateConfig()
                    })
                ]
            ]

            horizontalLayout(it) [
                logfileField = textField(it, LogUtil.logDirectory) [
                    caption = "Directory"
                    width = "50em"
                    value = LogUtil.logDirectory
                ]

                syslogSelect = nativeSelect(it) [
                    caption = "Syslog"
                    items = #["KERN", "USER", "MAIL", "DAEMON", "AUTH", "SYSLOG", "LPR", "NEWS", "UUCP", "CRON", "AUTHPRIV", "FTP", "NTP", "AUDIT", "ALERT", "CLOCK", "LOCAL0", "LOCAL1", "LOCAL2", "LOCAL3", "LOCAL4", "LOCAL5", "LOCAL6", "LOCAL7"]
                    selectedItem = LogUtil.syslogFacility
                ]
            ]

            addComponentsAndExpand(grid)
        ]


        compositionRoot = root
    }

    private def changeLogLevel(Logger logger) {
        val select = new NativeSelect(null, #["ALL", "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF"])
        select.emptySelectionAllowed = false
        select.selectedItem = LogUtil.getLogLevel(logger)

        levelSelectBoxes.put(logger.name, select)

        return select
    }

    private def changeAppender(Logger logger) {
        val appList = #["CONSOLE", "FILE", "SYSLOG"]

        val select = new NativeSelect(null, appList)
        select.emptySelectionAllowed = true

        val app = LogUtil.getAppender(logger);
        if (app !== null && appList.contains(app.name)) {
            select.selectedItem = app.name
        }

        appenderSelectBoxes.put(logger.name, select)

        return select
    }

    private def getLoggerName(Logger logger) {
        return LogUtil.getLoggerName(logger)
    }

    def saveUpdateConfig() {
        // search for a file config
        val logger = (grid.dataProvider as ListDataProvider<Logger>).items.findFirst[s | appenderSelectBoxes.get(s.name).selectedItem.isPresent && appenderSelectBoxes.get(s.name).selectedItem.get.equals("FILE")]

        if (logger !== null) {
            // check if directory exists and is readable/writeable
            val file = new File(logfileField.value + "/jonglisto-ng.log")
            try {
                if (file.exists) {
                    if (file.isDirectory) {
                        Notification.show(file.absolutePath + " is a directory. This is not allowed!")
                        return
                    } else if (!file.canRead || !file.canWrite) {
                        Notification.show("No permission to read/write file " + file.absolutePath)
                        return
                    }
                } else if (!file.createNewFile) {
                    Notification.show("No permission to read/write file " + file.absolutePath)
                    return
                }
            } catch (Exception e) {
                Notification.show("No permission to read/write file " + file.absolutePath)
                return
            }
        }

        // change file name of FILE appender
        if (logfileField.getValue().trim().length > 0) {
            LogUtil.logDirectory = logfileField.getValue().trim()
        }

        // change syslog facility of SYSLOG appender
        if (syslogSelect.getSelectedItem().isPresent) {
            LogUtil.syslogFacility = syslogSelect.getSelectedItem().get()
        }

        // change configuration
        (grid.dataProvider as ListDataProvider<Logger>).items.forEach(s | {
            val level = levelSelectBoxes.get(s.name).selectedItem
            val appender = appenderSelectBoxes.get(s.name).selectedItem

            if (appender.isPresent && level.isPresent) {
                if (level.get == "OFF") {
                    // delete logger
                    LogUtil.disableLogger(s)
                } else {
                    LogUtil.setAppender(s, LogUtil.getAppender(appender.get))
                    LogUtil.setLevel(s, LogUtil.getLevel(level.get))
                }
            } else {
                // delete logger
                LogUtil.disableLogger(s)
            }
        })

        LogUtil.saveConfig
    }
}
