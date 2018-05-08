package vdr.jonglisto.web.ui.component

import com.vaadin.ui.Alignment
import com.vaadin.ui.Button
import com.vaadin.ui.Composite
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.Notification
import com.vaadin.ui.Panel
import com.vaadin.ui.VerticalLayout
import javax.inject.Inject
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.web.i18n.Messages

// @Log("jonglisto.web")
@SuppressWarnings("serial")
class ToolsComponent extends Composite {
    @Inject
    Config config

    @Inject
    Svdrp svdrp

    @Inject
    Messages messages

    def showAll() {
        createLayout(null)
        return this
    }

    private def void createLayout(String user) {
        val root = new VerticalLayout()

        // EPG Copy Panel
        val copyPanel = new Panel("Copy Tool")
        val copyLayout = new HorizontalLayout()

        val vdrListSource = new NativeSelect(messages.configToolsSource, config.getVdrNames(null))
        vdrListSource.emptySelectionAllowed = false
        copyLayout.addComponent(vdrListSource)

        val vdrListDest = new NativeSelect(messages.configToolsDest, config.getVdrNames(null))
        vdrListDest.emptySelectionAllowed = false
        copyLayout.addComponent(vdrListDest)

        val epgCopyButton = new Button(messages.configToolsCopyEpg)
        epgCopyButton.addClickListener(s | {
            if (vdrListSource.selectedItem.isPresent && vdrListDest.selectedItem.isPresent) {
                val source = vdrListSource.selectedItem.get
                val dest = vdrListDest.selectedItem.get

                if (source != dest) {
                    try {
                        svdrp.copyEpg(source, dest)
                    } catch (Exception e) {
                        Notification.show(e.message)
                    }
                } else {
                    Notification.show("Source and dest VDR are the same");
                }
            } else {
                Notification.show("Please select source and dest VDR");
            }
        })

        val channelCopyButton = new Button(messages.configToolsCopyChannel)
        channelCopyButton.addClickListener(s | {
            if (vdrListSource.selectedItem.isPresent && vdrListDest.selectedItem.isPresent) {
                val source = vdrListSource.selectedItem.get
                val dest = vdrListDest.selectedItem.get

                if (source != dest) {
                    try {
                        svdrp.copyChannels(source, dest)
                    } catch (Exception e) {
                        Notification.show(e.message)
                    }
                } else {
                    Notification.show("Source and dest VDR are the same");
                }
            } else {
                Notification.show("Please select source and dest VDR");
            }
        })

        copyLayout.addComponent(epgCopyButton)
        copyLayout.setComponentAlignment(epgCopyButton,  Alignment.BOTTOM_CENTER);

        copyLayout.addComponent(channelCopyButton)
        copyLayout.setComponentAlignment(channelCopyButton,  Alignment.BOTTOM_CENTER);

        copyPanel.content = copyLayout

        root.addComponent(copyPanel)
        compositionRoot = root
    }
}
