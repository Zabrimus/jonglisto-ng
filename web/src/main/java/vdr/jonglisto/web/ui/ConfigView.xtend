package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.TextField
import com.vaadin.ui.TwinColSelect
import com.vaadin.ui.themes.ValoTheme
import de.steinwedel.messagebox.ButtonOption
import de.steinwedel.messagebox.MessageBox
import java.util.logging.Level
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.configuration.jaxb.favourite.Favourites.Favourite
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@CDIView(MainUI.CONFIG_VIEW)
class ConfigView extends BaseView {

    @Inject
    private Svdrp svdrp

    @Inject
    private Config config

    @Inject
    private Messages messages

    private NativeSelect<String> favourites

    private TwinColSelect<Channel> channelSelect

    @PostConstruct
    def void init() {
        super.init(BUTTON.CONFIG)
    }

    protected override createMainComponents() {

        val channelFavouriteTab = verticalLayout [
            horizontalLayout(it) [
                favourites = nativeSelect(it) [
                    items = config.favourites.favourite.map[s|s.name]
                    emptySelectionAllowed = true

                    addSelectionListener(s | {
                        if (s.selectedItem.isPresent) {
                            channelSelect.visible = true
                            channelSelect.value = config.favourites.favourite //
                                                            .findFirst(f | f.name == s.selectedItem.get) //
                                                            .channel.map[c | svdrp.getChannel(c)] //
                                                            .toSet
                        } else {
                            channelSelect.visible = false
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

            channelSelect = twinColSelect(it, messages.configFavouriteList) [
                items = svdrp.channels
                itemCaptionGenerator = [it.name]
                visible = false

                addValueChangeListener(s | {
                    val channels = config.favourites.favourite.findFirst(f | f.name == favourites.selectedItem.get).channel
                    channels.clear
                    channels.addAll(channelSelect.value.map[c | c.id])
                })
            ]
        ]

        val tabsheet = tabsheet[
            addTab(channelFavouriteTab, messages.configFavouriteChannel)

            addStyleName(ValoTheme.TABSHEET_FRAMED);
            addStyleName(ValoTheme.TABSHEET_PADDED_TABBAR);
        ]

        addComponentsAndExpand(tabsheet)
    }

    override protected def void changeVdr(VDR vdr) {
        // not used
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
            .withCaption("TODO: List")
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
        channelSelect.visible = false
    }

}
