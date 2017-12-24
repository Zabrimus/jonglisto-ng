package vdr.jonglisto.web.ui.component

import com.vaadin.shared.ui.ContentMode
import com.vaadin.ui.AbsoluteLayout
import com.vaadin.ui.Composite
import com.vaadin.ui.Label
import java.time.LocalDate
import java.util.List
import java.util.concurrent.atomic.AtomicInteger
import java.util.stream.Collectors
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Timer

import static extension vdr.jonglisto.util.TimerOverlap.*

class TimeLine extends Composite {

    var int compWidth
    var int cellWidth
    var LocalDate date
    var List<Timer> timer
    var Svdrp svdrp

    var lastTransponder = ""

    def setSvdrp(Svdrp s) {
        this.svdrp = s
        return this
    }

    def setComponentWidth(int w) {
        compWidth = w
        return this
    }

    def setDate(LocalDate date) {
        this.date = date
        return this
    }

    def setTimer(List<Timer> timer) {
        this.timer = timer
        return this
    }

    def createComposite() {
        val layout = createRootComponent()

        val showTimer = timer.stream //
            .filter(s | s.startDate.isEqual(date) || s.endDate.isEqual(date)) //
            .sorted([s1,s2 | s1.startTime.compareTo(s2.startTime)]) //
            .collect(Collectors.groupingBy([m | m.channelId], Collectors.toList()))

        val idx = new AtomicInteger(0)
        showTimer.keySet.stream.sorted(s1,s2 | s1.transponder.compareTo(s2.transponder)).forEach(s | {
            fillTimeline(layout, idx.incrementAndGet, s, showTimer.get(s), date)
        })
    }

    private def createRootComponent() {
        cellWidth = (compWidth - 100) / 24

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
        width = compWidth + "px"
        height = "40px"

        return a
    }

    private def fillTimeline(AbsoluteLayout layout, int idx, String channelId, List<Timer> timer, LocalDate date) {
        val transponder = channelId.transponder

        if (lastTransponder != transponder) {
            // draw line
            val lineLabel = new Label("<center><p style=\"border-top:1px solid;height:0px;background-color:" + "#000000;" + "\">&nbsp;</p><center>", ContentMode.HTML) => [
                width = (compWidth-100) + "px"
            ]

            layout.addComponent(lineLabel, "left: 100px; top: " + (idx * 20 - 1) + "px;")

            lastTransponder = transponder
        }

        val channelName = svdrp.getChannel(channelId).name

        val channelLabel = new Label("<center><p style=\"font-size: 80%;\">" + channelName + "</p><center>", ContentMode.HTML)
        layout.addComponent(channelLabel, "left: 0px; top: " + (idx * 20) + "px;")

        timer.stream.forEach(s | {
            var int hour
            var int minute
            var long tmpDuration

            if (s.startDate.isBefore(date)) {
                val end = s.endDateTime
                hour = 0
                minute = 0
                tmpDuration = (end.hour * 60 + end.minute) * 60
            } else {
                val start = s.startDateTime
                hour = start.hour
                minute = start.minute
                tmpDuration = s.duration
            }

            val duration = tmpDuration
            val timeLineLabel = new Label("<center><p style=\"font-size: 80%;border:1px solid;height:15px;background-color:" + "#90EE90;" + "\">&nbsp;</p><center>", ContentMode.HTML) => [
                width = (((compWidth-100) * duration) / (24 * 60 * 60)) + "px"
            ]

            layout.addComponent(timeLineLabel, "left: " + (100 + ((compWidth-100) * (hour * 60 + minute)) / (24 * 60))  + "px; top: " + (idx * 20 + 4) + "px;")
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
