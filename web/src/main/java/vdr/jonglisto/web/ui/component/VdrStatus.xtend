package vdr.jonglisto.web.ui.component

import com.vaadin.icons.VaadinIcons
import com.vaadin.shared.ui.ContentMode
import com.vaadin.ui.Button
import com.vaadin.ui.GridLayout
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.Label
import com.vaadin.ui.Panel
import com.vaadin.ui.TextArea
import com.vaadin.ui.UI
import com.vaadin.ui.VerticalLayout
import com.vaadin.ui.Window
import com.vaadin.ui.themes.ValoTheme
import de.steinwedel.messagebox.MessageBox
import java.util.List
import java.util.stream.Collectors
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class VdrStatus {
    val CPanel panel
    val GridLayout grid
    val VDR vdr

    new(VDR vdr) {
        this.vdr = vdr

        grid = new GridLayout(3, 2) => [
            setSizeFull

            // row 1
            addComponent(new Label("IP:"))
            addComponent(new Label(vdr.ip))
            addComponent(new Label(VaadinIcons.QUESTION_CIRCLE.html, ContentMode.HTML))

            // row 2
            addComponent(new Label("SVDRP port:"))
            addComponent(new Label(String.valueOf(vdr.port)))
            addComponent(new Label(VaadinIcons.QUESTION_CIRCLE.html, ContentMode.HTML))
        ]

        val layout = new VerticalLayout => [
            addComponent(grid)
            addComponent(new HorizontalLayout => [
                button(it, "Plugins") [
                    addClickListener(s | showPlugins)
                ]

                button(it, "SVDRP") [
                    addClickListener(s | svdrpCommand)
                ]
            ])
        ]

        val refreshButton = new Button() => [
            icon = VaadinIcons.REFRESH
            description = "Refresh"
            width = "22px"
            styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
            addClickListener(s | refreshStatus)
        ]

        panel = new CPanel(vdr.name) => [
            width = "320px"
            addComponent(layout)
            addHeaderComponent(refreshButton)
        ]
    }

    def getPanel() {
        return panel
    }

    private def refreshStatus() {
        getPingStatus(true)
        getSvdrpStatus(true)
    }

    private def svdrpCommand() {
        val commandResult = new TextArea => [ setSizeFull ]

        val verticalLayout = new VerticalLayout => [
            comboBox(it, Configuration.get.defaultSvdrpCommand) [
                width = "100%"
                caption = "Command"
                selectedItem = null

                addSelectionListener(s | {
                    commandResult.value = SvdrpClient.get.processCommand(vdr, s.value).createResult
                })

                newItemHandler = [ s | commandResult.value = SvdrpClient.get.processCommand(vdr, s).createResult]
            ]

            addComponentsAndExpand(commandResult)
        ]

        val window = new Window("SVDRP Command") => [
            width = "600px"
            height = "600px"
            center
            content = verticalLayout
        ]

        UI.current.addWindow(window)
    }

    private def showPlugins() {
        var plugins = SvdrpClient.get.getPlugins(vdr)

        if (plugins !== null) {
            plugins.sortInplace[s1,s2 | s1.plugin.compareTo(s2.plugin)]

            val grid = new GridLayout(3, plugins.size)

            for (s : plugins) {
                grid.addComponent(new Label(s.plugin))
                grid.addComponent(new Label(s.version))
                grid.addComponent(new Label(s.description))
            }

            grid.width = "800px"

            val panel = new Panel() => [
                content = grid;
                setSizeUndefined
            ]

            MessageBox.create()
                .withCaption("Plugins")
                .withMessage(panel)
                .open();
        } else {
            MessageBox.createWarning()
                .withCaption("plugins")
                .withMessage("No plugins found. System or VDR halted?")
                .open();
        }
    }

    private def getPingStatus(boolean updateGrid) {
        val result = getStatusHtml(Configuration.get.pingHost(vdr))

        if (updateGrid) {
            grid.replaceComponent(grid.getComponent(2, 0), new Label(result, ContentMode.HTML))
        }

        return result
    }

    private def getSvdrpStatus(boolean updateGrid) {
        val result = getStatusHtml(SvdrpClient.get.pingHost(vdr))

        if (updateGrid) {
            grid.replaceComponent(grid.getComponent(2, 1), new Label(result, ContentMode.HTML))
        }

        return result
    }

    private def getStatusHtml(boolean b) {
        if (b) {
            return VaadinIcons.CHECK.html
        } else {
            return VaadinIcons.CLOSE.html
        }
    }

    private def createResult(List<String> lines) {
        if (lines === null || lines.size == 0) {
            return "<no response received>"
        } else {
            return lines.stream.collect(Collectors.joining("\n"))
        }
    }
}
