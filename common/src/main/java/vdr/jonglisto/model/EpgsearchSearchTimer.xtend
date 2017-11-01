package vdr.jonglisto.model

import java.time.Instant
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.util.Arrays
import java.util.HashMap
import java.util.HashSet
import java.util.Map
import java.util.Set
import java.util.stream.Collectors
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

import static extension org.apache.commons.lang3.StringUtils.*

@Accessors
@EqualsHashCode
@ToString
class EpgsearchSearchTimer {
    enum Field {
        id,                 //  1
        pattern,            //  2
        use_time,           //  3
        time_start,         //  4
        time_stop,          //  5
        use_channel,        //  6
        channels,           //  7
        matchcase,          //  8
        mode,               //  9
        use_title,          // 10
        use_subtitle,       // 11
        use_descr,          // 12
        use_duration,       // 13
        min_duration,       // 14
        max_duration,       // 15
        has_action,         // 16
        use_days,           // 17
        which_days,         // 18
        is_series,          // 19
        directory,          // 20
        prio,               // 21
        lft,                // 22
        bstart,             // 23
        bstop,              // 24
        use_vps,            // 25
        action,             // 26
        use_extepg,         // 27
        extepg_infos,       // 28
        avoid_repeats,      // 29
        allowed_repeats,    // 30
        comp_title,         // 31
        comp_subtitle,      // 32
        comp_descr,         // 33
        comp_extepg_info,   // 34
        repeats_in_days,    // 35
        delete_after,       // 36
        keep_recordings,    // 37
        switch_before,      // 38
        pause,              // 39
        use_blacklists,     // 40
        sel_blacklists,     // 41
        fuzzy_tolerance,    // 42
        use_for_fav,        // 43
        results_menu,       // 44
        autodelete,         // 45
        del_after_recs,     // 46
        del_after_days,     // 47
        searchtimer_from,   // 48
        searchtimer_until,  // 49
        ignore_missing_epgcats, // 50
        unmute,             // 51
        min_match,          // 52
        unused              // 53
    }

    // epgsearch contains too much different information, therefore a non-optimal datatype is selected
    private Map<Field, String> cfg = new HashMap<Field, String>

    private val searchCategories = new HashMap<String, Set<String>>

    def getField(Field field) {
        return cfg.get(field)
    }

    def setField(Field field, String value) {
        cfg.put(field, value)
    }

    def getBooleanField(Field field) {
        return if (getField(field) == "1") true else false
    }

    def setBooleanField(Field field, boolean value) {
        setField(field, if (value) "1" else "0")
    }

    def getLongField(Field field) {
        return Long.parseLong(getField(field))
    }

    def setLongField(Field field, Long value) {
        setField(field, String.valueOf(value))
    }

    def getDateField(Field field) {
        val v = getField(field)

        if (v !== null && v.isNotEmpty) {
            return LocalDateTime.ofInstant(Instant.ofEpochSecond(Long.parseLong(v)), ZoneId.systemDefault()).toLocalDate()
        }

        return null
    }

    def setDateField(Field field, LocalDate value) {
        setField(field, String.valueOf(value.atStartOfDay(ZoneId.systemDefault()).toEpochSecond()))
    }

    def splitCategories() {
        val cats = getField(Field.extepg_infos)

        if (cats.isNotEmpty) {
            val splitted = cats.split("\\|")
            for (x : splitted) {
                val ca = x.split("#");
                if (ca.length == 2) {
                    var entries = searchCategories.get(ca.get(0));
                    if (entries === null) {
                        entries = new HashSet<String>
                    }

                    entries.addAll(Arrays.stream(ca.get(1).replace("!^colon^!", ":").split(",")).collect(Collectors.toList()));

                    searchCategories.put(ca.get(0), entries);
                }
            }
        }
    }

    def getSearchCategories(String key) {
        return searchCategories.get(key)
    }

    def setSearchCategories(String key, String value) {
        val ca = new HashSet<String>
        ca.add(value)
        searchCategories.put(key, ca)
    }

    def setSearchCategoriesSet(String key, Set<?> values) {
        val ca = new HashSet<String>

        for (a : values) {
            ca.add(a as String)
        }

        searchCategories.put(key, ca)
    }
}
