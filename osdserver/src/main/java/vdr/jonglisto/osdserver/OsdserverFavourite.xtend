package vdr.jonglisto.osdserver

import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.util.DateTimeUtil

class OsdserverFavourite {

    val OsdserverConnection connection
    val VDR vdr

    new(VDR vdr, OsdserverConnection connection) {
        this.vdr = vdr
        this.connection = connection
    }

    def show() {
        var timeOffset = 0L

        val favList = Configuration.instance.favourites.favourite

        if (favList === null || favList.size == 0) {
            // no list defined
            return
        }

        connection.send("menu=New Menu 'Favoriten'", 200)
        connection.send("menu.setColumns 15", 200)
        connection.send("menu.EnableEvent close", 200)

        for (var i = 0; i < favList.size; i++) {
            connection.send("fav" + i + "=menu.AddNew OsdItem " + favList.get(i).name, 200)
            connection.send("fav" + i + ".EnableEvent keyOk", 200)
        }

        connection.send("fav0.SetCurrent", 200)
        connection.send("menu.Show", 200)

        while (true) {
            val response = sleepEvent

            if (response.code == 300) {
                val r = response.message.split(" ")
                var int menuId
                var int submenuId

                var channels = favList.get(menuId).channel

                if (r.get(0).startsWith("fav")) {
                    if (r.get(1) == "keyOk") {
                        connection.send("enterlocal", 200)

                        menuId = Integer.valueOf(r.get(0).substring(3))

                        connection.send("menu=New Menu 'Favoriten: " + favList.get(menuId).name + "'", 200)
                        connection.send("menu.SetColumns 12 6 6 20", 200)
                        connection.send("menu.EnableEvent keyOk close", 200)

                        channels = favList.get(menuId).channel
                        for (var i = 0; i < channels.size; i++) {
                            val ch = SvdrpClient.getInstance().getChannel(channels.get(i))

                            val currentTime = System.currentTimeMillis() / 1000 + timeOffset

                            // get current transmission for the selected channel
                            var String item
                            val epg = SvdrpClient.getInstance().epg.findFirst[s | (s.channelId == ch.id) && (s.startTime <= currentTime) && ((s.startTime + s.duration) > currentTime)]

                            if (epg !== null) {
                                item = ch.name + //
                                    "\t" + DateTimeUtil.toTime(epg.startTime, "HH:mm") + //
                                    "\t" + DateTimeUtil.toTime(epg.startTime + epg.duration, "HH:mm") + //
                                    "\t" + epg.title + //
                                    "\t" + epg.shortText
                            } else {
                                item = ch.name
                            }

                            connection.send("subfav" + i + "=menu.AddNew OsdItem '" + item + "'", 200)
                            connection.send("subfav" + i + ".EnableEvent keyOk", 200)
                        }

                        connection.send("_focus.addsubmenu menu", 200)
                        connection.send("menu.Show", 200)
                    }
                } else if (r.get(0).startsWith("subfav")) {
                    submenuId = Integer.valueOf(r.get(0).substring(6))
                    if (r.get(1) == "keyOk") {
                        // Switch to channel
                        val ch = SvdrpClient.getInstance().getChannel(channels.get(submenuId))
                        SvdrpClient.getInstance().switchChannel(vdr, ch.id)
                        return
                    }
                } else if (r.get(0) == "menu") {
                    if (r.get(1) == "close") {
                        connection.send("delete menu", 200)
                        connection.send("leavelocal")

                        val showResponse = connection.send("menu.show")
                        if (showResponse.code == 420) {
                            // menu really closed -> return
                            return
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


        /*
        if (favList.length == 1) {

        } else {

        }
        */
    }

    private def sleepEvent() {
        var response = connection.send("menu.SleepEvent")

        if (response.code == 200) {
            response = connection.readResponse
        }

        return response
    }
}

