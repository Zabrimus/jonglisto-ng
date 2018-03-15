package vdr.jonglisto.web.ui.component

import ch.qos.logback.classic.Logger
import com.vaadin.ui.Composite
import com.vaadin.ui.Grid
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.renderers.ComponentRenderer
import javax.inject.Inject
import vdr.jonglisto.logging.LogUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*
import com.vaadin.data.provider.ListDataProvider
import ch.qos.logback.classic.Level

@Log("jonglisto.web")
class LoggingComponent extends Composite {

    @Inject
    private Messages messages

    private Grid<Logger> grid

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
                        grid.items = LogUtil.configuredLoggers.filter[app | !"AppenderHolder".equals(app.name)]
                    })
                ]

                button(it, "All Loggers") [
                    addClickListener(s | {
                        grid.items = LogUtil.allLoggers.filter[app | !"AppenderHolder".equals(app.name)]
                    })
                ]

                button(it, "Save configuration") [
                    addClickListener(s | {
                        saveUpdateConfig()
                    })
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

        select.addSelectionListener(s | {
            logger.level = Level.toLevel(select.selectedItem.get)
        })

        return select
    }

    private def changeAppender(Logger logger) {
        val appList = #["CONSOLE", "FILE", "SYSLOG"]

        val select = new NativeSelect(null, appList)
        select.emptySelectionAllowed = true

        val app = LogUtil.getAppender(logger);
        if (appList.contains(app.name)) {
            select.selectedItem = app.name
        }

        select.addSelectionListener(s | {
            logger.detachAndStopAllAppenders
            if (s.selectedItem.isPresent) {
                logger.addAppender(LogUtil.getAppender(s.selectedItem.get))
            }
        })

        return select
    }

    private def getLoggerName(Logger logger) {
        return LogUtil.getLoggerName(logger)
    }

    def saveUpdateConfig() {
        (grid.dataProvider as ListDataProvider<Logger>).items.forEach[s | {
            println(s.name + " --> " + s.level.levelStr)
        }]

    }
}
