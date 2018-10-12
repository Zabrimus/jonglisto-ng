package vdr.jonglisto.web.ui.component

import com.vaadin.icons.VaadinIcons
import com.vaadin.shared.ui.ContentMode
import com.vaadin.ui.Alignment
import com.vaadin.ui.Button
import com.vaadin.ui.ComboBox
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
import java.util.Optional
import java.util.stream.Collectors
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.util.NetworkUtils
import vdr.jonglisto.web.i18n.Messages

import static vdr.jonglisto.web.xtend.UIBuilder.*

// @Log("jonglisto.web")
class VdrStatus {

    Svdrp svdrp = new Svdrp()

    Config config = new Config()

    var CPanel panel
    var GridLayout grid
    var ComboBox<String> box
    var VDR vdr

    var Messages messages

    def setVdr(VDR vdr) {
        val currentUser = SecurityUtils.subject
        this.vdr = vdr

        if (messages === null) {
            messages = new Messages
        }

        grid = new GridLayout(3, 4) => [
            setSizeFull

            // row 1
            addComponent(new Label("IP:"))
            addComponent(new Label(vdr.ip))
            addComponent(new Label(VaadinIcons.QUESTION_CIRCLE.html, ContentMode.HTML))

            // row 2
            addComponent(new Label("SVDRP port:"))
            addComponent(new Label(String.valueOf(vdr.port)))
            addComponent(new Label(VaadinIcons.QUESTION_CIRCLE.html, ContentMode.HTML))

            // row 3
            addComponent(new Label("Disk Free:"))
            addComponent(new Label("0"))
            addComponent(new Label(""))

            // row 4
            val last = vdr.lastSeen
            var String lastStr
            if (last !== null) {
                lastStr = DateTimeUtil.toTime(last, messages.formatTime) + " " + DateTimeUtil.toDate(last, messages.formatDate)
            } else {
                lastStr = "never"
            }

            addComponent(new Label(messages.mainLastSeen))
            addComponent(new Label(lastStr))
            addComponent(new Label(""))
        ]

        val layout = new VerticalLayout => [
            addComponent(grid)
            addComponent(new HorizontalLayout => [
                button(it, "Plugins") [
                    addClickListener(s | showPlugins)
                ]

                if (currentUser.isPermitted("svdrp:execute")) {
                    button(it, "SVDRP") [
                        addClickListener(s | svdrpCommand)
                    ]
                }
            ])
        ]

        val refreshButton = new Button() => [
            icon = VaadinIcons.REFRESH
            description = "Refresh"
            width = "22px"
            styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
            addClickListener(s | refreshStatus)
        ]

        var Button wolButton = null
        if (vdr.mac !== null) {
            wolButton = new Button() => [
                icon = VaadinIcons.FLIGHT_TAKEOFF
                description = "Wake on lan"
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | NetworkUtils.sendWol(vdr))
            ]
        }

        val tmpWol = wolButton
        panel = new CPanel(vdr.name) => [
            width = "320px"
            addComponent(layout)
            addHeaderComponent(refreshButton)

            if (tmpWol !== null) {
                addHeaderComponent(tmpWol)
            }
        ]

        return this
    }

    def getPanel() {
        return panel
    }

    def refreshStatus() {
        getPingStatus()
        getSvdrpStatus()
        getDiskStatus()
        getLastSeen()
    }

    private def svdrpCommand() {
        val commandResult = new TextArea => [ setSizeFull ]

        val verticalLayout = new VerticalLayout => [
            horizontalLayout(it) [
                width = "100%"

                box = comboBox(it, config.defaultSvdrpCommand) [
                    width = "100%"
                    caption = "Command"
                    selectedItem = null
                    textInputAllowed = true

                    newItemProvider = [ s | {
                        val list = config.defaultSvdrpCommand
                        list.add(s)
                        box.items = list
                        box.selectedItem = s

                        return Optional.of(s)
                    }]
                ]

                val execute = button(it, "Execute") [
                    addClickListener(s | {
                        commandResult.value = svdrp.processCommand(vdr, box.optionalValue).createResult
                    })
                ]

                it.setExpandRatio(box, 3.0f)
                it.setComponentAlignment(execute, Alignment.BOTTOM_RIGHT)
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
        var plugins = svdrp.getPlugins(vdr)

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

    private def void getPingStatus() {
        val result = getStatusHtml(config.pingHost(vdr))
        grid.replaceComponent(grid.getComponent(2, 0), new Label(result, ContentMode.HTML))
    }

    private def void getSvdrpStatus() {
        val result = getStatusHtml(svdrp.pingHost(vdr))
        grid.replaceComponent(grid.getComponent(2, 1), new Label(result, ContentMode.HTML))
    }

    private def void getDiskStatus() {
        val result = svdrp.getStat(vdr)
        if (result !== null) {
            grid.replaceComponent(grid.getComponent(1, 2), new Label(result.toStringFree))
        }
    }

    private def void getLastSeen() {
        val result = vdr.lastSeen

        val last = vdr.lastSeen
        var String lastStr
        if (last !== null) {
            lastStr = DateTimeUtil.toTime(last, messages.formatTime) + " " + DateTimeUtil.toDate(last, messages.formatDate)
        } else {
            lastStr = "never"
        }

        if (result !== null) {
            grid.replaceComponent(grid.getComponent(1, 3), new Label(lastStr))
        }
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
