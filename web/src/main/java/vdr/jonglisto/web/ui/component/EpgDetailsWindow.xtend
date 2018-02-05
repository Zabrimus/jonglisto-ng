package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.icons.VaadinIcons
import com.vaadin.server.FileResource
import com.vaadin.shared.ui.ContentMode
import com.vaadin.ui.Alignment
import com.vaadin.ui.Button
import com.vaadin.ui.ComponentContainer
import com.vaadin.ui.CssLayout
import com.vaadin.ui.Image
import com.vaadin.ui.Label
import com.vaadin.ui.TextArea
import com.vaadin.ui.VerticalLayout
import com.vaadin.ui.Window
import com.vaadin.ui.themes.ValoTheme
import java.io.File
import javax.inject.Inject
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.web.util.HtmlSanitizer
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@ViewScoped
class EpgDetailsWindow extends Window {

    @Inject
    private Svdrp svdrp

    @Inject
    private Config config

    @Inject
    private Messages messages

    @Inject
    private ChannelLogo channelLogo

    var TextArea epgArea
    var VDR currentVdr
    var EventGrid parentGrid

    new() {
        super()
    }

    def showWindow(EventGrid parent, VDR vdr, Epg epg, boolean editView, long recordingId) {
        this.currentVdr = vdr
        this.parentGrid = parent

        val scraper = svdrp.getScraperData(if(recordingId !== -1) vdr else null, epg, recordingId)

        caption = createCaption(epg)

        center();

        closable = true
        modal = true
        width = "60%"

        // VDR EPG
        val tab1 = verticalLayout [
            if (scraper?.series !== null) {
                val series = scraper.series
                if (series.banner !== null && series.banner.size > 0) {
                    val image = createImage(series.banner.get(0).value, "banner")

                    if (image !== null) {
                        addComponent(image)
                    }
                }
            }

            val headerLabel = label(it, epg.shortText)
            val header = horizontalLayout(it) [
                it.addComponent(createChannel(epg))
                it.addComponent(headerLabel)
            ]

            header.setComponentAlignment(headerLabel, Alignment.MIDDLE_LEFT)

            addDescription(it, epg.description, editView)
        ]

        var VerticalLayout extended = null
        var CssLayout posterImages = null
        var CssLayout actorImages = null
        var CssLayout fanartImages = null
        var CssLayout seriesImages = null

        // scraper extended epg
        if (scraper?.series !== null) {
            extended = verticalLayout [
                val series = scraper.series

                if (series.banner !== null && series.banner.size > 0) {
                    val image = createImage(series.banner.get(0).value, "banner")

                    if (image !== null) {
                        addComponent(image)
                    }
                }

                val builder = new StringBuilder
                if (series.name !== null) {
                    builder.append(messages.epgName + ": ").append(series.name).append("|")
                }

                if (series.firstAired !== null) {
                    builder.append(messages.epgFirstAired + ": ").append(series.firstAired).append("|")
                }

                if (series.rating !== null) {
                    builder.append(messages.epgRating + ": ").append(series.rating).append("|")
                }

                if (series.status !== null) {
                    builder.append(messages.epgStatus + ": ").append(series.status).append("|")
                }

                builder.append("|")

                if (series.overview !== null) {
                    builder.append(series.overview)
                }

                addDescription(builder.toString, false)

                if (series.episode !== null && series.episode.width > 0) {
                    val image = createImage(series.episode.value, "poster")

                    if (image !== null) {
                        addComponent(image)
                    }
                }
            ]
        }

        if (scraper?.movie !== null) {
            extended = verticalLayout [
                // movie

                val movie = scraper.movie

                val builder = new StringBuilder
                if (movie.title !== null) {
                    builder.append(messages.epgTitleCaption + ": ").append(movie.title)
                    if (movie.originalTitle !== null) {
                        builder.append(" [" + messages.epgOriginal + ": ").append(movie.originalTitle).append("]")
                    }
                    builder.append("|")
                }

                if (movie.tagline !== null) {
                    builder.append(messages.epgTagline + ": ").append(movie.tagline).append("|")
                }

                if (movie.releaseDate !== null) {
                    builder.append(messages.epgDateCaption + ": ").append(movie.releaseDate).append("|")
                }

                if (movie.genre !== null) {
                    builder.append(messages.epgGenreCaption + ": ").append(movie.genre).append("|")
                }

                if (movie.runtime !== null) {
                    builder.append(messages.epgRuntime + ": ").append(movie.runtime).append("|")
                }

                if (movie.budget !== null) {
                    builder.append(messages.epgBudget + ": ").append(movie.budget)
                    if (movie.revenue !== null) {
                        builder.append(" , " + messages.epgRevenue + ": ").append(movie.revenue)
                    }

                    builder.append("|")
                }

                if (movie.popularity !== null) {
                    builder.append(messages.epgPopularity + ": ").append(movie.popularity)
                    if (movie.voteAverage !== null) {
                        builder.append(" , " + messages.epgVote + ": ").append(movie.voteAverage)
                    }

                    builder.append("|")
                }

                if (movie.adult !== null) {
                    builder.append(messages.epgAdult + ": ").append(movie.adult).append("|")
                }

                if (movie.homepage !== null) {
                    builder.append(messages.epgHomepage + ": ").append(movie.homepage).append("|")
                }

                builder.append("|")
                builder.append(movie.overview)
                addDescription(builder.toString, false)
            ]
        }

        if (config.showScraperImages) {
            // Poster
            val seriesPoster = scraper?.series?.poster?.size > 0
            val moviePoster = scraper?.movie?.poster?.size > 0
            if (seriesPoster || moviePoster) {
                posterImages = new CssLayout

                if (seriesPoster) {
                    for (s : scraper.series.poster) {
                        if (s.width > 0) {
                            val image = createImage(s.value, "poster")

                            if (image !== null) {
                                posterImages.addComponent(image)
                            }
                        }
                    }
                }

                if (moviePoster) {
                    for (s : scraper.movie.poster) {
                        if (s.width > 0) {
                            val image = createImage(s.value, "poster")

                            if (image !== null) {
                                posterImages.addComponent(image)
                            }
                        }
                    }
                }
            }

            // Fanart
            val seriesFanart = scraper?.series?.fanart?.size > 0
            val movieFanart = scraper?.movie?.fanart?.size > 0
            if (seriesFanart || movieFanart) {
                fanartImages = new CssLayout

                if (seriesFanart) {
                    for (s : scraper.series.fanart) {
                        if (s.width > 0) {
                            val image = createImage(s.value, "fanart")

                            if (image !== null) {
                                fanartImages.addComponent(image)
                            }
                        }
                    }
                }

                if (movieFanart) {
                    for (s : scraper.movie.fanart) {
                        if (s.width > 0) {
                            val image = createImage(s.value, "fanart")

                            if (image !== null) {
                                fanartImages.addComponent(image)
                            }
                        }
                    }
                }
            }

            // Actor
            val seriesActor = scraper?.series?.actor?.size > 0
            val movieActor = scraper?.movie?.actor?.size > 0
            if (seriesActor || movieActor) {
                actorImages = new CssLayout

                if (seriesActor) {
                    for (s : scraper.series.actor) {
                        if (s.width > 0) {
                            val actorImage = createActorImage(s.path, "actor", s.role, s.name)

                            if (actorImage !== null) {
                                actorImages.addComponent(actorImage)
                            }
                        }
                    }
                }

                if (movieActor) {
                    for (s : scraper.movie.actor) {
                        if (s.width > 0) {
                            val actorImage = createActorImage(s.path, "actor", s.role, s.name)

                            if (actorImage !== null) {
                                actorImages.addComponent(actorImage)
                            }
                        }
                    }
                }
            }

            // Series images
            if (scraper?.series?.banner?.size > 0) {
                if (seriesImages === null) {
                    seriesImages = new CssLayout
                }

                for (s : scraper.series.banner) {
                    if (s.width > 0) {
                        val image = createImage(s.value, "banner")

                        if (image !== null) {
                            seriesImages.addComponent(image)
                        }
                    }
                }
            }

            if (scraper?.series?.seasonPoster !== null) {
                if (seriesImages === null) {
                    seriesImages = new CssLayout
                }

                if (scraper.series.seasonPoster.width > 0) {
                    val image = createImage(scraper.series.seasonPoster.value, "seasonposter")

                    if (image !== null) {
                        seriesImages.addComponent(image)
                    }
                }
            }
        }

        val extendedEpg = extended
        val poster = posterImages
        val actor = actorImages
        val fanart = fanartImages
        val series = seriesImages

        val tabsheet = tabsheet[
            addTab(tab1, messages.epgTabStandard)

            if (extendedEpg !== null) {
                addTab(extendedEpg, messages.epgTabExtended)
            }

            if (poster !== null) {
                addTab(poster, messages.epgTabPoster)
            }

            if (actor !== null) {
                addTab(actor, messages.epgTabActor)
            }

            if (fanart!== null) {
                addTab(fanart, messages.epgTabFanart)
            }

            if (series !== null) {
                addTab(series, messages.epgTabSeries)
            }

            addStyleName(ValoTheme.TABSHEET_FRAMED);
            addStyleName(ValoTheme.TABSHEET_PADDED_TABBAR);
        ]

        setContent(
            verticalLayout [
                addComponent(tabsheet)

                horizontalLayout(it) [
                    button(it, messages.epgClose) [
                        addCloseButtonClickListener
                    ]

                    if (editView) {
                        button(it, messages.epgSave) [
                            it.addClickListener(s | {
                                svdrp.saveEpgData(config.epgVdr, epg, epgArea.value)
                                close
                            })
                        ]
                    }

                    if (parentGrid !== null && !editView) {
                        button(it, messages.epgSwitchChannel) [
                            icon = VaadinIcons.PLAY
                            description = messages.epgSwitchChannel
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | parentGrid.actionPlay(epg))
                        ]

                        button(it, messages.epgSearchRetransmission) [
                            icon = VaadinIcons.SEARCH
                            description = messages.epgSearchRetransmission
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | { close; parentGrid.actionSearch(epg) })
                        ]

                        button(it, messages.epgEditEpg) [
                            icon = VaadinIcons.EDIT
                            description = messages.epgEditEpg
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | { close; parentGrid.actionEdit(epg) })
                        ]

                        button(it, messages.epgRecord) [
                            icon = VaadinIcons.CIRCLE
                            description = messages.epgRecord
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | { close; parentGrid.actionRecord(epg) })
                        ]

                        button(it, messages.epgAlarm) [
                            icon = VaadinIcons.ALARM
                            description = messages.epgAlarm
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | { close; parentGrid.actionAlarm(epg) })
                        ]
                    }
                ]
            ]
        )

        return this
    }

    def createCaption(Epg epg) {
        return String.format("%s  [%s,  %s - %s (%s)]",
            epg.title,
            DateTimeUtil.toDate(epg.startTime, messages.formatDate),
            DateTimeUtil.toTime(epg.startTime, messages.formatTime),
            DateTimeUtil.toTime(epg.startTime + epg.duration, messages.formatTime),
            DateTimeUtil.toTime(epg.duration, messages.formatTime)
        )
    }

    def addDescription(ComponentContainer container, String description, boolean editView) {
        // clean description
        val epgdesc = HtmlSanitizer.clean(description)

        if (!editView) {
            // prepare html code
            val str = epgdesc.replaceAll("\\|", "\n") //
                        .replaceAll("(?m)^([a-zA-Z]\\w*?:)", "<b>$1</b>") //
                        .replaceAll("\\n", "<br/>");

            label(container, str) [
                contentMode = ContentMode.HTML
                width = "100%"
            ]

        } else {
            val str = epgdesc.replaceAll("\\|", "\n");

            epgArea = textArea(container, messages.epgEditEpg, str) [
                width = "100%"
            ]
        }
    }

    def addCloseButtonClickListener(Button b) {
        b.addClickListener(s | {
            close
        })
    }

    private def createChannel(Epg ev) {
        val channel = svdrp.getChannel(ev.channelId)

        // channel can be null, if the channel id do not exists anymore
        if (channel !== null) {
            val name = channel.name
            val image = channelLogo.getImage(name)

            if (image !== null) {
                image.data = name
                return image
            } else {
                val label = new Label(name)
                label.data = name
                return label
            }
        } else {
            val label = new Label("")
            label.data = "<unknown>"
            return label
        }
    }

    private def createImage(String scraperPath, String style) {
        if (scraperPath !== null) {
            val newPath = scraperPath.changeScraperPath
            val file = new File(newPath)

            if (file.exists) {
                val resource = new FileResource(new File(newPath));
                val image = new Image(null, resource);
                image.styleName = style

                return image
            } else {
                log.info("Cannot open file: " + newPath + ", original path: " + scraperPath)
                return null;
            }
        } else {
            log.info("Scraper path is empty")
            return null
        }
    }

    private def createActorImage(String scraperPath, String style, String role, String name) {
        if (scraperPath !== null) {
            val newPath = scraperPath.changeScraperPath
            val file = new File(newPath)

            if (file.exists) {
                val resource = new FileResource(new File(newPath));
                val image = new Image(null, resource);
                image.styleName = style

                return new ActorImage(image, role, name)
            } else {
                log.info("Cannot open file: " + newPath + ", original path: " + scraperPath)

                return null;
            }
        } else {
            log.info("Scraper path is empty")
            return null
        }
    }

    private def changeScraperPath(String input) {
        for (s : config.scraperPath) {
            if (input.startsWith(s.replace)) {
                return s.to + input.substring(s.replace.length)
            }
        }

        return input
    }
}
