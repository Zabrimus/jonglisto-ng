package vdr.jonglisto.web.ui.component

import com.vaadin.shared.ui.ContentMode
import com.vaadin.ui.AbsoluteLayout
import com.vaadin.ui.Composite
import com.vaadin.ui.Label
import java.time.LocalDate
import java.util.List
import java.util.concurrent.atomic.AtomicInteger
import java.util.stream.Collectors
import vdr.jonglisto.model.Timer
import vdr.jonglisto.svdrp.client.SvdrpClient

class TimeLine extends Composite {
    var int compWidth
    var int cellWidth

    new(int w, LocalDate date, List<Timer> timer) {
        val layout = createRootComponent(w)
        // height = "80px"

        val showTimer = timer.stream //
            .filter(s | s.startDate == date) //
            .sorted([s1,s2 | s1.startTime.compareTo(s2.startTime)]) //
            .collect(Collectors.groupingBy([m | m.channelId], Collectors.toList()))

        val idx = new AtomicInteger(0)
        showTimer.keySet.stream.forEach(s | {
            fillTimeline(layout, idx.incrementAndGet, s, showTimer.get(s))
        })
    }

    private def createRootComponent(int w) {
        compWidth = w
        cellWidth = (w - 100) / 24

        val a = new AbsoluteLayout => [
            width = compWidth + "px"
            height = "40px"
        ]

        val spacer = new Label("") => [width = "100px"]
        a.addComponent(spacer, "left: 0px; top: 0px;");

        for (var i = 0; i < 24; i++) {
            val l = new Label("<center><p style=\"font-size: 80%;background-color:" + hbc(i) + "\">" + i + "</p><center>", ContentMode.HTML);
            l.width = cellWidth + "px"
            a.addComponent(l, "left: " + (100 + i*cellWidth)  + "px; top: 0px;");
        }

        compositionRoot = a
        width = w + "px"
        height = "40px"

        return a
    }

    private def fillTimeline(AbsoluteLayout layout, int idx, String channelId, List<Timer> timer) {
        val channelName = SvdrpClient.get.getChannel(channelId).name

        val channelLabel = new Label("<center><p style=\"font-size: 80%;\">" + channelName + "</p><center>", ContentMode.HTML)
        layout.addComponent(channelLabel, "left: 0px; top: " + (idx * 20) + "px;")

        timer.stream.forEach(s | {
            val start = s.startDateTime
            val hour = start.hour
            val minute = start.minute

            val timeLineLabel = new Label("<center><p style=\"font-size: 80%;border:1px solid;height:15px;background-color:" + "#90EE90;" + "\">&nbsp;</p><center>", ContentMode.HTML) => [
                width = (((compWidth-100) * s.duration) / (24 * 60 * 60)) + "px"
            ]

            layout.addComponent(timeLineLabel, "left: " + (100 + ((compWidth-100) * (hour * 60 + minute)) / (24 * 60))  + "px; top: " + (idx * 20) + "px;")
        })

        layout.height = ((idx + 1) * 30) + "px"
    }

    private def hbc(int i) {
        if (i % 2 == 0) {
            return "#D3D3D3;"
        } else {
            return "#FFFFFF;"
        }
    }
}
