package vdr.jonglisto.web.ui.component

import com.vaadin.data.provider.ListDataProvider
import com.vaadin.ui.CustomComponent
import com.vaadin.ui.Grid
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.TextField
import com.vaadin.ui.components.grid.GridRowDragger
import de.steinwedel.messagebox.ButtonOption
import de.steinwedel.messagebox.MessageBox
import java.util.ArrayList
import java.util.logging.Level
import java.util.stream.Collectors
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.configuration.jaxb.favourite.Favourites.Favourite
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Channel
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*
import com.vaadin.ui.Button
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.themes.ValoTheme
import com.vaadin.ui.Notification
import com.vaadin.ui.Notification.Type
import com.vaadin.ui.renderers.ComponentRenderer
import vdr.jonglisto.model.VDR

@Log
class ExtFavouriteComponent extends CustomComponent {

    @Inject
    private Svdrp svdrp

    @Inject
    private Config config

    @Inject
    private Messages messages

    private VDR currentVdr

    private String currentUser

    private NativeSelect<String> favourites

    private Grid<Channel> leftGrid;
    private Grid<Channel> rightGrid;


    def showAll() {
        currentUser = null
        createLayout(null)

        setSizeFull
        return this
    }

    def showUser() {
        currentUser = SecurityUtils.subject.principal as String
        createLayout(currentUser)
        return this
    }

    def void changeVdr(VDR vdr) {
        currentVdr = vdr
    }

    private def void createLayout(String user) {
        leftGrid = new Grid<Channel>
        leftGrid.addColumn(s | s.name).setCaption("Name").sortable = false
        leftGrid.addColumn(s | s.metadata).setCaption(messages.captionSource).sortable = false
        leftGrid.addColumn(s | s.action).setRenderer(new ComponentRenderer()).setCaption("").sortable = false

        leftGrid.setSizeFull

        // Multi selection throws a client error
        // leftGrid.setSelectionMode(SelectionMode.MULTI);

        rightGrid = new Grid<Channel>
        rightGrid.addColumn(s | s.name).setCaption("Name").sortable = false
        rightGrid.addColumn(s | s.metadata).setCaption(messages.captionSource).sortable = false
        rightGrid.addColumn(s | s.action).setRenderer(new ComponentRenderer()).setCaption("").sortable = false
        rightGrid.setSizeFull

        // Multi selection throws a client error
        // rightGrid.setSelectionMode(SelectionMode.MULTI);

        // enable sorting of right grid
        new GridRowDragger<Channel>(rightGrid);

        // enable dragging left to right and vice versa
        val leftToRight = new GridRowDragger<Channel>(leftGrid, rightGrid);
        val rightToLeft = new GridRowDragger<Channel>(rightGrid, leftGrid);

        rightToLeft.getGridDropTarget().addDropListener(s | updateLeftGrid())
        leftToRight.getGridDropTarget().addDropListener(s | updateFavourites())

        val root = verticalLayout [
            horizontalLayout(it) [
                favourites = nativeSelect(it) [
                    items = config.favourites.favourite.map[s|s.name]
                    emptySelectionAllowed = true

                    addSelectionListener(s | {
                        if (s.selectedItem.isPresent) {
                            leftGrid.visible = true
                            rightGrid.visible = true

                            val rightList = config.favourites.favourite.stream() //
                                            .filter(f | f.name == s.selectedItem.get) //
                                            .findFirst.get //
                                            .channel.stream() //
                                            .distinct //
                                            .map(c | svdrp.getChannel(c)) //
                                            .collect(Collectors.toList())

                            rightGrid.dataProvider = new ListDataProvider(new ArrayList(rightList));
                            rightGrid.columns.forEach[c | c.sortable = false]

                            updateLeftGrid()
                        } else {
                            leftGrid.visible = false
                            rightGrid.visible = false
                        }
                    })
                ]

                button(it, messages.configFavouriteRename) [
                    addClickListener(s | {
                        if (favourites.selectedItem.isPresent) {
                            renameList
                        }
                    })
                ]

                button(it, messages.configFavouriteNew) [
                    addClickListener(s | {
                        addNewList
                    })
                ]

                button(it, messages.configFavouriteDelete) [
                    addClickListener(s | {
                        if (favourites.selectedItem.isPresent) {
                            deleteList(favourites.selectedItem.get)
                        }
                    })
                ]

                button(it, messages.configFavouriteSave) [
                    addClickListener(s | {
                        try {
                            config.saveFavourites()
                        } catch (Exception e) {
                            log.log(Level.WARNING, "save of favourites failed", e)

                            MessageBox.createWarning()
                            .withCaption(messages.configFavouriteSave)
                            .withMessage(messages.configFavouriteSave + ": " + e.message)
                            .open();
                        }
                    })
                ]
            ]

            val h = new HorizontalLayout()
            h.setSizeFull
            h.addComponent(leftGrid)
            h.addComponent(rightGrid)

            addComponentsAndExpand(h)
        ]

        compositionRoot = root
    }

    private def addNewList() {
        val input = new TextField("name");

        MessageBox.createQuestion()
            .withCaption(messages.configFavouriteNew)
            .withMessage(input)
            .withOkButton([
                    val newFav = new Favourite
                    newFav.name = input.value
                    config.favourites.favourite.add(newFav)

                    favourites.items = config.favourites.favourite.map[s|s.name]
                    favourites.selectedItem = input.value
                ], ButtonOption.caption("OK"))
            .withCancelButton()
            .open();
    }

    private def renameList() {
        val input = new TextField;
        input.value = favourites.selectedItem.get

        MessageBox.createQuestion()
            .withCaption("Name")
            .withMessage(input)
            .withOkButton([
                    config.favourites.favourite.findFirst[f | f.name == favourites.selectedItem.get].name = input.value
                    favourites.items = config.favourites.favourite.map[s|s.name]
                    favourites.selectedItem = input.value
                ], ButtonOption.caption("OK"))
            .withCancelButton()
            .open();
    }


    private def deleteList(String name) {
        val fav = config.favourites.favourite.findFirst[f | f.name == name]
        config.favourites.favourite.remove(fav)
        favourites.items = config.favourites.favourite.map[s|s.name]
    }

    private def updateLeftGrid() {
        val leftList = new ArrayList(svdrp.channels)
        leftList.removeAll((rightGrid.dataProvider as ListDataProvider<Channel>).items)
        leftGrid.dataProvider = new ListDataProvider(leftList)
        leftGrid.columns.forEach[c | c.sortable = false]

        updateFavourites
    }

    private def updateFavourites() {
        val list = config.favourites.favourite.findFirst[f | f.name == favourites.selectedItem.get]
        val items = (rightGrid.dataProvider as ListDataProvider<Channel>).items.stream().map(s | s.id).collect(Collectors.toList())

        list.channel.clear
        list.channel.addAll(items)
    }

    private def metadata(Channel ch) {
        if (ch.id !== null) {
            val r = if (ch.radio) messages.typeRadio else messages.typeTv
            val e = if (ch.encrypted) messages.typeEncrypted else messages.typeFree

            return String.format("%s, %s, %s, %s", ch.source, r, e, ch.bouquet)
        } else {
            return null
        }
    }

    private def action(Channel ch) {
        val playButton = new Button()
        playButton.icon = VaadinIcons.PLAY
        playButton.description = messages.epgSwitchChannel
        playButton.width = "22px"
        playButton.styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS

        playButton.addClickListener(s | {
            try {
                svdrp.switchChannel(currentVdr, ch.id)
            } catch (Exception e) {
                log.log(Level.INFO, "Switch channel failed", e)
                Notification.show(messages.epgErrorSwitchFailed, Type.ERROR_MESSAGE)
            }
        })

        return playButton
    }

}