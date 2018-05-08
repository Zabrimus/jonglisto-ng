package vdr.jonglisto.util

import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.regex.Pattern
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.Timer

class TimerOverlap {

    val static trans = Pattern.compile("(.*?)-(.*?-.*?)-(.*?)$")

    val chmap = new HashMap<String, String>
    val timer = new ArrayList<Timer>
    val int dvbDevices

    new(int dvbDevices, List<Channel> channels) {
        this.dvbDevices = dvbDevices

        channels.stream.forEach(s | {
            chmap.put(s.id, getTransponder(s.id))
        })
    }

    def addTimer(List<Timer> addTimer) {
        timer.addAll(addTimer)
    }

    def getCollisions() {
        val result = new HashMap<Integer, Integer>

        timer.stream.forEach(s | {
            timer.stream.forEach(t | {
                if (overlap(s,t) && chmap.get(s.channelId) != chmap.get(t.channelId)) {
                    result.put(s.id, (result.get(s.id) ?: 0)+1)
                    result.put(t.id, (result.get(t.id) ?: 0)+1)
                }
            })
        })

        return result
    }

    def getDvbDevices() {
        return dvbDevices
    }

    static def getTransponder(String chid) {
        val m = trans.matcher(chid)
        if (m.matches) {
            return m.group(2)
        }

        // must not happen
        return chid
    }

    private def overlap(Timer t1, Timer t2) {
        return (t1.startTime < t2.endTime) && (t2.startTime < t1.endTime)
    }
}
