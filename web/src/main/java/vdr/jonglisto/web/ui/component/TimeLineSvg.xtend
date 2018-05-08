package vdr.jonglisto.web.ui.component

import com.vaadin.ui.Image
import java.io.StringWriter
import java.time.LocalDate
import java.util.List
import java.util.concurrent.atomic.AtomicInteger
import java.util.stream.Collectors
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Timer
import vdr.jonglisto.web.util.SvgStreamSource

import static extension vdr.jonglisto.util.TimerOverlap.*

class TimeLineSvg {
    val cellWidth = 30

    var LocalDate date
    var List<Timer> timer
    var Svdrp svdrp

    var lastTransponder = ""
    var lastIdx = 0

    var StringWriter header = new StringWriter
    var StringWriter transponderFill = new StringWriter
    var StringWriter timeline = new StringWriter
    var StringWriter footer = new StringWriter

    def setSvdrp(Svdrp s) {
        this.svdrp = s
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

    def Image createImage() {
        val showTimer = timer.stream //
            .filter(s | s.startDate.isEqual(date) || s.endDate.isEqual(date)) //
            .sorted([s1,s2 | s1.startTime.compareTo(s2.startTime)]) //
            .collect(Collectors.groupingBy([m | m.channelId], Collectors.toList()))

        fillHeader(showTimer.size)

        val idx = new AtomicInteger(0)
        showTimer.keySet.stream.sorted(s1,s2 | s1.transponder.compareTo(s2.transponder)).forEach(s | {
            fillTimeline(showTimer.size, idx.incrementAndGet, s, showTimer.get(s), date)
        })

        fillFooter(showTimer.size)

        val result = header.toString + transponderFill.toString + timeline.toString + footer.toString

        return new Image("", new SvgStreamSource(result))
    }

    private def fillHeader(int size) {
        header.append("<svg xmlns=\"http://www.w3.org/2000/svg\" height=\"" + ((size+2)*20) + "\" width=\"" + (24*cellWidth + 120) + "\">\n");

        for (var i = 0; i < 24; i++) {
            val color = if (i % 2 == 0) "rgb(255,255,255)" else "rgb(220,220,220)"

            header.append("   <g transform=\"translate(" + (i*cellWidth + 120) + ",0)\">\n")
            header.append("      <rect x=\"" + 0 + "\"  y=\"0\" width=\"" + cellWidth + "\" height=\"20\" style=\"fill:" + color + ";stroke-width:1;stroke:rgb(0,0,0)\" />\n")
            header.append("      <text x=\"" + (cellWidth/2) + "\" y=\"10\" alignment-baseline=\"middle\" font-size=\"12\" fill=\"black\" text-anchor=\"middle\">" + i + "</text>\n")
            header.append("   </g>\n")
        }
    }

    private def fillFooter(int size) {
        // for (var i = 0; i < 24; i++) {
        //     footer.append("   <line x1=\"" + (i*cellWidth + 120) + "\" y1=\"20\" x2=\"" + (i*cellWidth + 120) + "\" y2=\"" + ((size+1)*20) + "\" style=\"stroke:rgb(242,242,242);stroke-width:1\" />\n")
        // }

        footer.append("</svg>\n")
    }

    private def void fillTimeline(int size, int idx, String channelId, List<Timer> timer, LocalDate date) {
        val transponder = channelId.transponder

        if (lastTransponder != transponder) {
            // transponderFill.append("   <rect x=\"0\"  y=\"20\" width=\"" + (24 * cellWidth + 120) + "\" height=\"" + (((size+1)*20) - (lastIdx+1)*20) + "\" style=\"fill:rgb(255,255,224);stroke-width:1;stroke:rgb(0,0,0)\" />\n")
            transponderFill.append("   <rect x=\"0\"  y=\"20\" width=\"" + (24 * cellWidth + 120) + "\" height=\"" + (((size+1)*20) - (lastIdx+1)*20) + "\" style=\"fill:rgb(255,255,255);stroke-width:1;stroke:rgb(0,0,0)\" />\n")
            lastTransponder = transponder
            lastIdx = idx
        }

        val channelName = svdrp.getChannel(channelId).name

        timeline.append("   <text y=\"" + (idx * 20 + 13) + "\" x=\"0\" font-size=\"12\" fill=\"black\">" + channelName + "</text>\n")

        timer.stream.forEach(s | {
            var int hour
            var int minute
            var long duration

            if (s.startDate.isBefore(date)) {
                val end = s.endDateTime
                hour = 0
                minute = 0
                duration = (end.hour * 60 + end.minute) * 60
            } else {
                val start = s.startDateTime
                hour = start.hour
                minute = start.minute
                duration = s.duration
            }

            timeline.append("   <rect x=\"" + ((hour * 60.0 + minute) * (cellWidth/60.0) + 120) + "\"  y=\"" + (idx * 20) + "\" width=\"" + ((duration/60.0) * (cellWidth/60.0)) + "\" height=\"20\" style=\"fill:" + "rgb(255,255,0)" + ";stroke-width:1;stroke:rgb(0,0,0)\" />\n")
        })
    }
}
