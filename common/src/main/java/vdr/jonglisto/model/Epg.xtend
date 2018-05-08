package vdr.jonglisto.model

import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.regex.Pattern
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

import static extension org.apache.commons.lang3.StringUtils.*

@Accessors
@EqualsHashCode
@ToString
class Epg extends BaseData {
    String channelId
    String eventId
    long startTime
    long duration
    String title
    String shortText
    String description
    String parentalRating
    Long vps
    int priority
    int lifetime
    String aux

    String genre
    String category
    Map<String, String> custom = new HashMap<String, String>

    String season
    String part
    String parts

    // saves the raw data without the description, if someone wants to edit the epg data
    List<String> rawData = new ArrayList<String>

    def void addData(String d) {
        rawData.add(d)
    }

    def getCustom(String header) {
        return custom.get(header)
    }

    def findPattern(Pair<Pattern, Integer> pattern) {
        var result = ""

        if (pattern !== null && pattern.key !== null && description !== null) {
            val m = pattern.key.matcher(description)
            if (m.find) {
                result = m.group(pattern.value) ?: ""
            }
        }

        return result.trim
    }

    def findPattern(EpgCustomColumn column) {
        if (!column.output.isNotEmpty) {
            custom.put(column.header, "")
            return
        }

        var result = column.output

        if (column.pattern !== null && description !== null) {
            val m = column.pattern.matcher(description)
            if (m.find) {
                for (var i = 0; i <= m.groupCount; i++) {
                    result = result.replace("${" + i + "}", m.group(i))
                }

                custom.put(column.header, result)
            } else {
                custom.put(column.header, "")
            }
        } else {
            custom.put(column.header, "")
        }
    }
}
