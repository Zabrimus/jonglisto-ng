package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.data.TreeData
import com.vaadin.data.provider.TreeDataProvider
import com.vaadin.server.FileDownloader
import com.vaadin.server.StreamResource
import com.vaadin.server.StreamResource.StreamSource
import com.vaadin.shared.ui.dnd.DropEffect
import com.vaadin.shared.ui.dnd.EffectAllowed
import com.vaadin.shared.ui.grid.DropMode
import com.vaadin.ui.Button
import com.vaadin.ui.Grid.SelectionMode
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.Label
import com.vaadin.ui.Layout
import com.vaadin.ui.Panel
import com.vaadin.ui.TextField
import com.vaadin.ui.TreeGrid
import com.vaadin.ui.components.grid.EditorOpenEvent
import com.vaadin.ui.components.grid.EditorOpenListener
import com.vaadin.ui.components.grid.TreeGridDragSource
import com.vaadin.ui.components.grid.TreeGridDropTarget
import com.vaadin.ui.dnd.DragSourceExtension
import com.vaadin.ui.dnd.DropTargetExtension
import java.io.BufferedWriter
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.OutputStreamWriter
import java.io.StringWriter
import java.util.ArrayList
import java.util.Collection
import java.util.HashSet
import java.util.List
import java.util.logging.Level
import java.util.stream.Collectors
import javax.annotation.PostConstruct
import vdr.jonglisto.model.BaseDataWithName
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.EpgProvider
import vdr.jonglisto.model.EpgProvider.Provider
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.Utils
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.themes.ValoTheme
import com.vaadin.ui.Notification
import com.vaadin.ui.Notification.Type
import com.vaadin.ui.renderers.ComponentRenderer

@Log
@CDIView(MainUI.CHANNEL_CONFIG_VIEW)
class ChannelConfigView extends BaseView {

    private static val COLUMN_NAME = "NAME"
    private static val COLUMN_METADATA = "METADATA"
    private static val COLUMN_FREQUENCE = "FREQUENCE"
    private static val COLUMN_BOUQUET = "BOUQUET"
    private static val COLUMN_ACTION = "ACTION"

    var Panel tvmPanel
    var Panel tvspPanel

    var TreeGrid<BaseDataWithName> treeGrid

    @PostConstruct
    def void init() {
        super.init(BUTTON.CHANNELCONFIG)
    }

    protected override createMainComponents() {
        horizontalLayout(this) [
            addComponent(getChannelDownloadButton(messages.createChannelsConf, "channels.conf"))

            button(it, messages.deleteChannel) [
                addClickListener[
                    treeGrid.selectedItems.forEach(ch |
                        try {
                            if (ch instanceof Channel) {
                                if (ch.name == Channel.ROOT_GROUP && ch.id === null) {
                                    throw new RuntimeException("do nothing")
                                }
                            }

                            treeGrid.treeData.removeItem(ch)
                        } catch (Exception e) {
                            // ignore problems which could happen if a channel is already deleted
                            // or the root group shall be deleted
                        }
                    )
                    treeGrid.dataProvider.refreshAll
                ]
            ]

            button(it, messages.channelConfigNewGroup) [
                addClickListener[
                    treeGrid.treeData.addRootItems(new Channel("New Group"))
                    treeGrid.dataProvider.refreshAll
                ]
            ]

            button(it, messages.channelConfigAutomapping) [
                addClickListener[
                    epgProviderAutoMapping()
                ]

                visible = config.isDatabaseConfigured
            ]

            val download1 = getChannelMapDownloadButton(messages.createChannelMap, "channelmap.conf")
            download1.visible = config.isDatabaseConfigured
            addComponent(download1)

            val download2 = getMappingDownloadButton(messages.createExtMapping, "mapping.jonglisto")
            download2.visible = config.isDatabaseConfigured
            addComponent(download2)
        ]

        addComponentsAndExpand(createMainLayout)
    }

    private def createMainLayout() {
        val channels = svdrp.channels

        val h = new HorizontalLayout()
        h.setSizeFull
        h.spacing = false

        /**************************
         * TreeGrid
         *************************/
        treeGrid = new TreeGrid<BaseDataWithName>();
        treeGrid.dataProvider = getTreeDataProvider(channels)
        treeGrid.addColumn([s | s.displayName]) //
            .setCaption(messages.captionName) //
            .setId(COLUMN_NAME) //
            .setSortable(false) //
            .setEditorComponent(new TextField(), [ BaseDataWithName s, String b | renameGroupProvider(s, b) ]) //
            .editable = true

        treeGrid.addColumn([s | s.metadata]).setCaption(messages.captionSource).setId(COLUMN_METADATA).sortable = false
        treeGrid.addColumn([s | s.frequence]).setCaption(messages.captionFrequence).setId(COLUMN_FREQUENCE).sortable = false
        treeGrid.addColumn([s | s.bouquet]).setCaption(messages.captionBouquet).setId(COLUMN_BOUQUET).sortable = false

        treeGrid.addColumn([s | createAction(s)]) //
           .setRenderer(new ComponentRenderer()) //
           .setId(COLUMN_ACTION) //
           .setSortable(false)

        treeGrid.editor.addOpenListener(new EditorOpenListener<BaseDataWithName>() {
            override onEditorOpen(EditorOpenEvent<BaseDataWithName> event) {
                val parent = (treeGrid.dataProvider as TreeDataProvider<BaseDataWithName>).treeData.getParent(event.bean)

                if (parent !== null) {
                    event.source.cancel
                }
            }
        })

        treeGrid.height = "100%"
        treeGrid.width = null
        treeGrid.selectionMode = SelectionMode.MULTI
        treeGrid.editor.enabled = true

        // DragSource
        val channelDragSource = new TreeGridDragSource<BaseDataWithName>(treeGrid);

        channelDragSource.effectAllowed = EffectAllowed.MOVE;
        channelDragSource.setDragDataGenerator("text") [s | s.name]

        // DragTarget
        val channelDropTarget = new TreeGridDropTarget<BaseDataWithName>(treeGrid, DropMode.ON_TOP)
        channelDropTarget.dropEffect = DropEffect.MOVE;

        channelDragSource.addGridDragStartListener[ s | channelDragSource.dragData = s.draggedItems ]

        channelDragSource.addGridDragEndListener[ items | {
                // System.err.println("Dragged: " + items.draggedItems)
            }
        ]

        channelDropTarget.addGridDropListener[ event | {
                // check if drag data is available
                if (!event.dragData.isPresent || !(event.dropTargetRow.get instanceof Channel)) {
                    // do nothing
                    return
                }

                // Get the target Grid's items
                val dataProvider = event.getComponent().getDataProvider() as TreeDataProvider<BaseDataWithName>

                val treeData = dataProvider.getTreeData()

                val target = event.dropTargetRow.get as Channel

                // check if drag data is a EpgProvider
                if (event.dragData.get instanceof EpgProvider) {
                    if (target.id !== null) {
                        // an EpgProvider can only be dropped on a Channel if not already present
                        if (!treeData.getChildren(target).contains(event.dragData.get)) {
                            try {
                                // create a copy of the EpgProvider
                                val p = event.dragData.get as EpgProvider
                                val addEpg = new EpgProvider(p.provider, p.epgid, p.name, p.normalizedName)
                                treeData.addItem(target, addEpg)
                            } catch (Exception e) {
                                log.log(Level.INFO, "Ignoring error: ", e);
                            }
                        }
                    }
                } else {
                    // move selected items to the new location
                    (event.dragData.get as Collection<BaseDataWithName>).forEach[ data |
                        val isChannel = data instanceof Channel

                        if ((target.id === null) && isChannel && ((data as Channel).id !== null)) {
                            // drag Channel and drop onto node
                            treeData.setParent(data, target)

                            if (treeData.getChildren(target).size > 0) {
                                // move to second position and then move to first
                                treeData.moveAfterSibling(data, treeData.getChildren(target).get(0))
                                treeData.moveAfterSibling(treeData.getChildren(target).get(0), data)
                            }
                        } else if ((target.id !== null) && isChannel && ((data as Channel).id === null)) {
                            // drag node and drop onto Channel
                            // invalid => ignore this request
                        } else if ((target.id === null) && isChannel && ((data as Channel).id === null)) {
                            // drag node and drop onto node
                            treeData.moveAfterSibling(data, target)
                        } else {
                            // drag Channel or EpgProvider and drop onto channel
                            if (isChannel) {
                                treeData.setParent(data, treeData.getParent(target))
                                treeData.moveAfterSibling(data, target)
                            } else {
                                treeData.setParent(data, target)
                            }
                        }
                        treeGrid.deselectAll
                    ]
                }
                dataProvider.refreshAll
            }
        ]

        h.addComponentsAndExpand(treeGrid)

        /*****************************
         * Panel epg provider TVM
        *****************************/
        tvmPanel = panel(h, "TVM") [
            height = "100%"
            width = null

            verticalLayout(it) [
                config.epgProvider //
                    .filter(s | s.provider == Provider.TVM && s.visible) //
                    .sortBy[it.name.toUpperCase] //
                    .forEach[ s | label(it, s.name).addDragSource(s)]
            ]

            addPanelDropTarget(it)

            visible = config.isDatabaseConfigured
        ]

        /*****************************
         * Panel epg provider TVSP
        *****************************/
        tvspPanel = panel(h, "TVSP") [
            height = "100%"
            width = null

            verticalLayout(it) [
                config.epgProvider //
                    .filter(s | s.provider == Provider.TVSP && s.visible) //
                    .sortBy[it.name.toUpperCase] //
                    .forEach[ s | label(it, s.name).addDragSource(s)]
            ]

            addPanelDropTarget(it)

            visible = config.isDatabaseConfigured
        ]

        return h
    }

    private def createAction(BaseDataWithName name) {
        if (name instanceof Channel) {
            val button = new Button()
            button.icon = VaadinIcons.PLAY
            button.description = messages.epgSwitchChannel
            button.width = "22px"
            button.styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS

            button.addClickListener(s | {
                try {
                    svdrp.switchChannel(selectedVdr, name.id)
                } catch (Exception e) {
                    Notification.show(messages.epgErrorSwitchFailed, Type.ERROR_MESSAGE)
                }
            })

            return button
        } else {
            return null;
        }
    }

    private def displayName(BaseDataWithName n) {
        if (n instanceof EpgProvider) {
            return n.provider + ":" + n.name
        } else {
            return n.name
        }
    }

    private def metadata(BaseDataWithName n) {
        if (n instanceof Channel) {
            if (n.id !== null) {
                val r = if (n.radio) messages.typeRadio else messages.typeTv
                val e = if (n.encrypted) messages.typeEncrypted else messages.typeFree

                return String.format("%s, %s, %s", n.source, r, e)
            } else {
                return null
            }
        } else {
            return null
        }
    }

    private def frequence(BaseDataWithName n) {
        if (n instanceof Channel) {
            return n.frequence
        } else {
            return null
        }
    }

    private def bouquet(BaseDataWithName n) {
        if (n instanceof Channel) {
            return n.bouquet
        } else {
            return null
        }
    }

    private def renameGroupProvider(BaseDataWithName baseData, String newName) {
        baseData.name = newName

        if (baseData instanceof Channel) {
            baseData.group = newName
        }

        treeGrid.dataProvider.refreshAll
    }

    def addDragSource(Label label, EpgProvider source) {
        val dragSource = new DragSourceExtension<Label>(label)
        dragSource.dragData = source
    }

    def addPanelDropTarget(Panel panel) {
        val dropTarget = new DropTargetExtension<Panel>(panel);
        dropTarget.addDropListener(event | {
                if (event.dragData.isPresent) {
                    // Get the target Grid's items
                    val dataProvider = (event.dragSourceComponent.get as TreeGrid<BaseDataWithName>).dataProvider as TreeDataProvider<BaseDataWithName>

                    (event.dragData.get as Collection<BaseDataWithName>).forEach[ data |
                        if (data instanceof EpgProvider) {
                            dataProvider.treeData.removeItem(data)
                        }
                    ]

                    dataProvider.refreshAll
                }
            }
        )
    }

    private def getTreeDataProvider(List<Channel> list) {
        val treeData = new TreeData<BaseDataWithName>

        // get all groups / channels
        val groups = list.stream().map(m | m.group).distinct().map(s | new Channel(s)).collect(Collectors.toList())
        val channelInGroups = list.stream().collect(Collectors.groupingBy([m | m.group], Collectors.toList()));

        // add root level items
        treeData.addItems(null, groups);
        groups.forEach(g | treeData.addItems(g, channelInGroups.get(g.name)))

        return new TreeDataProvider<BaseDataWithName>(treeData);
    }

    private def getChannelDownloadButton(Layout layout, String caption, String filename) {
        return getDownloadButton(layout, caption, filename, [createChannelsConf])
    }

    private def getMappingDownloadButton(Layout layout, String caption, String filename) {
        return getDownloadButton(layout, caption, filename, [createInternalMappingConf])
    }

    private def getChannelMapDownloadButton(Layout layout, String caption, String filename) {
        return getDownloadButton(layout, caption, filename, [createChannelMap])
    }

    private def getDownloadButton(Layout layout, String caption, String filename, () => String sb) {
        val downloadButton = new Button(caption);

        val source = new StreamSource() {
            override getStream() {
                val arrayOutputStream = new ByteArrayOutputStream();
                val bufferedWriter = new BufferedWriter(new OutputStreamWriter(arrayOutputStream));

                bufferedWriter.append(sb.apply)
                bufferedWriter.flush

                return new ByteArrayInputStream(arrayOutputStream.toByteArray());
            }
        }

        val resource = new StreamResource(source, filename);
        resource.setMIMEType("text/plain");

        val fileDownloader = new FileDownloader(resource);
        fileDownloader.setOverrideContentType(false);
        fileDownloader.extend(downloadButton);

        return downloadButton;
    }

    private def createChannelsConf() {
        val channelsConf = new StringBuilder()

        // 1. save the group root element
        treeGrid.treeData.rootItems.forEach[ ch |
            if (ch instanceof Channel) {
                if (ch.name == Channel.ROOT_GROUP && ch.id === null) {
                    channelsConf.appendChildren(treeGrid.treeData.getChildren(ch))
                }
            }
        ]

        // 2. save all other channels
        treeGrid.treeData.rootItems.forEach[ ch |
            if (ch instanceof Channel) {
                if (ch.name != Channel.ROOT_GROUP) {
                    channelsConf.appendChannel(ch)
                    channelsConf.appendChildren(treeGrid.treeData.getChildren(ch))
                }
            }
        ]

        return channelsConf.toString
    }

    private def createInternalMappingConf() {
        val mapping = new ArrayList<String>
        val data = treeGrid.treeData

        data.rootItems.forEach[g |
            // iterate over all groups
            data.getChildren(g).forEach[ch |
                // iterator over all channels
                val epgprovider = data.getChildren(ch)

                if (epgprovider.size > 0) {
                    val eset = new HashSet<String>()

                    epgprovider.forEach[ e |
                        // iterate over all epg provider
                        if ((ch as Channel).normalizedName != Utils.normalizeChannelName(e.name)) {
                            eset.add(e.name)
                        }
                    ]

                    if (eset.size > 0) {
                        mapping.add(String.format("%s|%s", ch.name, eset.stream.collect(Collectors.joining("|"))))
                    }
                }
            ]
        ]

        return mapping.sortInplace.stream.collect(Collectors.joining("\n"))
    }

    private def createChannelMap() {
        val mapping = new StringWriter
        val data = treeGrid.treeData

        mapping.append("//\n")
        mapping.append("// channelmap.conf for epg2vdr daemon\n")
        mapping.append("// created by vdr jonglisto (https://github.com/Zabrimus/vdr-jonglisto-ng)\n")
        mapping.append("//\n\n")

        data.rootItems.forEach[g |
            mapping.append("// ------------------------------------------\n")
            mapping.append("// channel group: ").append(g.name).append("\n")
            mapping.append("// ------------------------------------------\n\n")

            data.getChildren(g).forEach[ch |
                val channel = ch as Channel
                val header = new StringWriter
                val chmapping = new StringWriter

                header.append("// vdr: ").append(channel.name).append("\n")
                chmapping.append("vdr:000:0:0 = ").append(channel.id).append("\n")

                data.getChildren(channel).forEach[m |
                    val epgprov = m as EpgProvider

                    switch (epgprov.provider) {
                        case Provider.TVM: {
                            header.append("// tvm: ")
                            chmapping.append("tvm:").append(epgprov.epgid).append(":2").append(" = ").append(channel.id).append("\n")
                        }
                        case Provider.TVSP: {
                            header.append("// tvsp: ")
                            chmapping.append("tvsp:").append(epgprov.epgid).append(":1").append(" = ").append(channel.id).append("\n")
                        }
                        case Provider.EPGDATA: {
                            header.append("// epgdata: ")
                            chmapping.append("epgdata:").append(epgprov.epgid).append(":3").append(" = ").append(channel.id).append("\n")
                        }
                    }
                    header.append(epgprov.name).append("\n")
                ]
                mapping.append(header.toString)
                mapping.append(chmapping.toString)
                mapping.append("\n")
            ]
        ]

        return mapping.toString
    }

    private def appendChildren(StringBuilder sb, List<BaseDataWithName> list) {
        list.forEach[sb.appendChannel(it)]
    }

    private def void appendChannel(StringBuilder sb, BaseDataWithName ch) {
        if (ch instanceof Channel) {
            if (ch.id === null) {
                sb.append(":").append(ch.name).append("\n")
            } else {
                sb.append(ch.raw).append("\n")
            }
        }
    }

    private def epgProviderAutoMapping() {
        // create map for faster access
        val epgProvider = config.epgProvider.stream().collect(Collectors.groupingBy([m | m.normalizedName], Collectors.toList()));

        treeGrid.treeData.rootItems.forEach [ rootItem |
            treeGrid.treeData.getChildren(rootItem).forEach[child |
                val ch = child as Channel
                val m = epgProvider.get(ch.normalizedName)
                if ((m !== null) && (m.size > 0) && !ch.radio) {
                    m.forEach[provider |
                        try {
                            // add a copy of the existing provider
                            val newProvider = new EpgProvider(provider.provider, provider.epgid, provider.name, provider.normalizedName)
                            treeGrid.treeData.addItem(ch, newProvider)
                        } catch (Exception e) {
                            // it's possible that the mapping already exists
                            // => ignore this exception
                            log.fine("Ignoring error in epgProviderAutoMapping: " + e.localizedMessage)
                        }
                    ]
                }
            ]
        ]

        treeGrid.dataProvider.refreshAll
    }

    override protected def void changeVdr(VDR vdr) {
       // not used in this view
    }
}
