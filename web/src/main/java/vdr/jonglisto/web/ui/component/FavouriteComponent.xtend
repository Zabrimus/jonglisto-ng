package vdr.jonglisto.web.ui.component

import com.vaadin.ui.Composite
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.TextField
import com.vaadin.ui.TwinColSelect
import de.steinwedel.messagebox.ButtonOption
import de.steinwedel.messagebox.MessageBox
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.configuration.jaxb.favourite.Favourites.Favourite
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Channel
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log("jonglisto.web")
@SuppressWarnings("serial")
class FavouriteComponent extends Composite {
    @Inject
    Svdrp svdrp

    @Inject
    Config config

    @Inject
    Messages messages

    String currentUser

    NativeSelect<String> favourites

    TwinColSelect<Channel> channelSelect

    def showAll() {
        currentUser = null
        createLayout(null)
        return this
    }

    def showUser() {
        currentUser = SecurityUtils.subject.principal as String
        createLayout(currentUser)
        return this
    }

    private def void createLayout(String user) {
        val root = verticalLayout [
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
                            log.info("save of favourites failed", e)

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
