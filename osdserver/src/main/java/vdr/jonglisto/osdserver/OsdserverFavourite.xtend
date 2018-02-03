package vdr.jonglisto.osdserver

import java.util.ArrayList
import java.util.List
import java.util.Locale
import java.util.stream.Collectors
import org.apache.commons.lang3.text.WordUtils
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.VDR
import vdr.jonglisto.osdserver.i18n.Messages
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.util.DateTimeUtil
import java.time.LocalDateTime

class OsdserverFavourite {

    val OsdserverConnection connection
    val Messages messages
    val VDR vdr
    var List<String> channels
    var List<Epg> epg
    var timeOffset = 0L

    new(VDR vdr, OsdserverConnection connection, String localeStr) {
        this.vdr = vdr
        this.connection = connection
        val locale = Locale.forLanguageTag(localeStr)
        this.messages = new Messages(locale)
    }

    def show() {
        var String osdPart

        val favList = Configuration.instance.favourites.favourite

        if (favList === null || favList.size == 0) {
            // no list defined
            return
        }

        connection.send("menu=New Menu '" + messages.titleFavourite.replace("'", "\\'") + "'", 200)
        connection.send("menu.setColumns 15", 200)
        connection.send("menu.EnableEvent close", 200)

        for (var i = 0; i < favList.size; i++) {
            connection.send("fav" + i + "=menu.AddNew OsdItem " + favList.get(i).name, 200)
            connection.send("fav" + i + ".EnableEvent keyOk", 200)
        }

        connection.send("fav0.SetCurrent", 200)
        connection.send("menu.Show", 200)

        osdPart = "menu"

        while (true) {
            val response = sleepEvent(osdPart)

            if (response.code == 300) {
                val r = response.message.split(" ")
                var int menuId
                var int submenuId

                if (r.get(0).startsWith("fav")) {
                    if (r.get(1) == "keyOk") {
                        osdPart = "submenu"

                        connection.send("enterlocal", 200)

                        menuId = Integer.valueOf(r.get(0).substring(3))

                        connection.send("submenu=New Menu '" + messages.titleFavourite.replace("'", "\\'") + ": " + favList.get(menuId).name + "'", 200)
                        connection.send("submenu.SetColumns 12 6 6 20", 200)
                        connection.send("submenu.EnableEvent keyRed keyGreen keyYellow close", 200)

                        connection.send("submenu.SetColorKeyText -red '" + messages.timeMinus30.replace("'", "\\'") + "'")
                        connection.send("submenu.SetColorKeyText -green '"+ messages.timePlus30.replace("'", "\\'") + "'")
                        connection.send("submenu.SetColorKeyText -yellow '" + messages.timeSelect.replace("'", "\\'") + "'")
                        connection.send("submenu.SetColorKeyText -blue '" + messages.epgInfo.replace("'", "\\'") + "'")

                        connection.send("time=submenu.AddNew OsdItem -unselectable '--- " + messages.whatsOnAt.replace("'", "\\'")  + " " + DateTimeUtil.toTime(System.currentTimeMillis() / 1000 + timeOffset, "HH:mm") + "'", 200)

                        val timeList = Configuration.instance.epgTimeSelect.stream.collect(Collectors.joining(" "))
                        connection.send("timesel=submenu.AddNew EditListItem Zeit " + messages.timeNow + " " + timeList)

                        channels = favList.get(menuId).channel

                        for (var i = 0; i < channels.size; i++) {
                            connection.send("subfav" + i + "=submenu.AddNew OsdItem ''", 200)
                            connection.send("subfav" + i + ".EnableEvent keyBlue keyOk", 200)
                        }

                        connection.send("_focus.addsubmenu submenu", 200)
                        connection.send("submenu.Show", 200)

                        fillWithTimeOffset

                        connection.send("submenu.Show", 200)
                    }
                } else if (r.get(0).startsWith("subfav")) {
                    submenuId = Integer.valueOf(r.get(0).substring(6))
                    switch (r.get(1)) {
                        case "keyOk": {
                            // Switch to channel
                            val ch = SvdrpClient.getInstance().getChannel(channels.get(submenuId))
                            SvdrpClient.getInstance().switchChannel(vdr, ch.id)
                            return
                        }

                        case "keyBlue": {
                            osdPart = "epgmenu"

                            connection.send("enterlocal", 200)

                            connection.send("epgmenu = New Menu 'Epg'", 200)
                            connection.send("epgmenu.setColumns 15", 200)
                            connection.send("epgmenu.EnableEvent close", 200)

                            val entry = epg.get(submenuId)

                            // header

                            val start = DateTimeUtil.toTime(entry.startTime, messages.formatTime.replace("'", "\\'"))
                            val end = DateTimeUtil.toTime(entry.startTime + entry.duration, messages.formatTime.replace("'", "\\'"))
                            val date = DateTimeUtil.toDateName(entry.startTime, messages.formatDate.replace("'", "\\'"))

                            connection.send("epgmenu.AddNew OsdItem -unselectable '" + date + " " + start + " - " + end + "'", 200)
                            connection.send("epgmenu.AddNew OsdItem -unselectable ''", 200)
                            connection.send("epgmenu.AddNew OsdItem -unselectable '" + entry.title.replace("'", "\\'") + "'", 200)
                            connection.send("epgmenu.AddNew OsdItem -unselectable '" + entry.shortText.replace("'", "\\'") + "'", 200)
                            connection.send("epgmenu.AddNew OsdItem -unselectable ''", 200)

                            // create description
                            val desc = entry.description.split("\\|").stream.map(s | WordUtils.wrap(s, 60).split("\n")).flatMap(s | s.stream).collect(Collectors.toList)
                            desc.forEach[s | {
                               connection.send("epgmenu.AddNew OsdItem  '" + s.replace("'", "\\'") + "'", 200)
                            }]

                            connection.send("_focus.addsubmenu epgmenu", 200)
                            connection.send("epgmenu.Show", 200)
                        }
                    }
                } else if (r.get(0) == "menu") {
                    if (r.get(1) == "close") {
                        connection.send("delete menu", 200)
                        return
                    }
                } else if (r.get(0) == "submenu") {
                    switch (r.get(1)) {
                        case "close": {
                            osdPart = "menu"
                            connection.send("delete submenu", 200)
                            connection.send("leavelocal")

                            val showResponse = connection.send("menu.show")
                            if (showResponse.code == 420) {
                                // menu really closed -> return
                                return
                            }
                        }

                        case "keyRed": {
                            timeOffset = timeOffset - 30 * 60
                            fillWithTimeOffset
                            connection.send("submenu.Show", 200)
                        }

                        case "keyGreen": {
                            timeOffset = timeOffset + 30 * 60
                            fillWithTimeOffset
                            connection.send("submenu.Show", 200)
                        }

                        case "keyYellow": {
                            var resp = connection.send("timesel.GetValue -name -quoted")
                            if (resp.code != 500) {
                                resp = connection.readResponse
                            }

                            // calculate offset
                            if (resp.message == messages.timeNow) {
                                timeOffset = 0
                            } else {
                                val split = resp.message.split(":")

                                var now = LocalDateTime.now
                                var time = LocalDateTime.now
                                time = time.withHour(Integer.valueOf(split.get(0)))
                                time = time.withMinute(Integer.valueOf(split.get(1)))

                                if (time.isBefore(now)) {
                                    // add one day
                                    time = time.plusDays(1)
                                }

                                timeOffset = time.toEpochSecond(DateTimeUtil.currentZoneOffset) - now.toEpochSecond(DateTimeUtil.currentZoneOffset)
                            }

                            fillWithTimeOffset
                            connection.send("submenu.Show", 200)
                        }
                    }
                } else if (r.get(0) == "epgmenu") {
                    switch (r.get(1)) {
                        case "close": {
                            osdPart = "submenu"
                            connection.send("delete epgmenu", 200)
                            connection.send("leavelocal")

                            val showResponse = connection.send("submenu.show")
                            if (showResponse.code == 420) {
                                // menu really closed -> return
                                return
                            }
                        }
                    }
                }
            } else if (response.code == 301 || response.code == 200) {
                // do nothing
            } else if (response.code == 412) {
                // menu closed
                return
            }
        }
    }

    private def fillWithTimeOffset() {
        epg = new ArrayList<Epg>

        for (var i = 0; i < channels.size; i++) {
            val ch = SvdrpClient.getInstance().getChannel(channels.get(i))
            val currentTime = System.currentTimeMillis() / 1000 + timeOffset

            // get current transmission for the selected channel
            var String item
            val epgEntry = SvdrpClient.getInstance().epg.findFirst[s | (s.channelId == ch.id) && (s.startTime <= currentTime) && ((s.startTime + s.duration) > currentTime)]

            if (epgEntry !== null) {
                item = ch.name + //
                    "\t" + DateTimeUtil.toTime(epgEntry.startTime, messages.formatTime.replace("'", "\\'")) + //
                    "\t" + DateTimeUtil.toTime(epgEntry.startTime + epgEntry.duration, messages.formatTime.replace("'", "\\'")) + //
                    "\t" + epgEntry.title
            } else {
                item = ch.name
            }

            epg.add(epgEntry)

            connection.send("subfav" + i + ".settext '" + item + "'", 200)

            val stringTime = DateTimeUtil.toTime(System.currentTimeMillis() / 1000 + timeOffset, messages.formatTime.replace("'", "\\'"))
            val stringDate = DateTimeUtil.toDateName(System.currentTimeMillis() / 1000 + timeOffset, messages.formatDate.replace("'", "\\'"))

            connection.send("time.setText '--- " + messages.whatsOnAt.replace("'", "\\'") + " " + stringTime + " (" + stringDate + ")'", 200)
        }
    }

    private def sleepEvent(String osdPart) {
        var response = connection.send(osdPart + ".SleepEvent")

        if (response.code == 200) {
            response = connection.readResponse
        }

        return response
    }
}

