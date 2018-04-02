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
import vdr.jonglisto.configuration.Configuration

@Accessors
@EqualsHashCode
@ToString
class EpgsearchSearchTimer {
    enum Field {
        id,                 //  1 unique search timer id
        pattern,            //  2 the search term
        use_time,           //  3 use time? 0/1
        time_start,         //  4 start time in HHMM
        time_stop,          //  5 stop time in HHMM
        use_channel,        //  6 use channel? 0 = no,  1 = Interval, 2 = Channel group, 3 = FTA only
        channels,           //  7 if 'use channel' = 1 then channel id[|channel id] in VDR format,
                            //    one entry or min/max entry separated with |, if 'use channel' = 2
                            //    then the channel group name
        matchcase,          //  8 match case? 0/1
        mode,               //  9 search mode:
                            //    0 - the whole term must appear as substring
                            //    1 - all single terms (delimiters are blank,',', ';', '|' or '~')
                            //        must exist as substrings.
                            //    2 - at least one term (delimiters are blank, ',', ';', '|' or '~')
                            //        must exist as substring.
                            //    3 - matches exactly
                            //    4 - regular expression
        use_title,          // 10 use title? 0/1
        use_subtitle,       // 11 use subtitle? 0/1
        use_descr,          // 12 use description? 0/1
        use_duration,       // 13 use duration? 0/1
        min_duration,       // 14 min duration in hhmm
        max_duration,       // 15 max duration in hhmm
        has_action,         // 16 use as search timer? 0/1
        use_days,           // 17 use day of week? 0/1
        which_days,         // 18 day of week (0 = Sunday, 1 = Monday...;
                            //                 -1 Sunday, -2 Monday, -4 Tuesday, ...; -7 Sun, Mon, Tue)
        is_series,          // 19 use series recording? 0/1
        directory,          // 20 directory for recording
        prio,               // 21 priority of recording
        lft,                // 22 lifetime of recording
        bstart,             // 23 time margin for start in minutes
        bstop,              // 24 time margin for stop in minutes
        use_vps,            // 25 use VPS? 0/1
        action,             // 26 action:
                            //      0 = create a timer
                            //      1 = announce only via OSD (no timer)
                            //      2 = switch only (no timer)
                            //      3 = announce via OSD and switch (no timer)
                            //      4 = announce via mail
        use_extepg,         // 27 use extended EPG info? 0/1
        extepg_infos,       // 28 extended EPG info values. This entry has the following format
                            //      (delimiter is '|' for each category, '#' separates id and value):
                            //      1 - the id of the extended EPG info category as specified in epgsearchcats.conf
                            //      2 - the value of the extended EPG info category
                            //      (a ':' will be translated to "!^colon^!", e.g. in "16:9")
        avoid_repeats,      // 29 avoid repeats? 0/1
        allowed_repeats,    // 30 allowed repeats
        comp_title,         // 31 compare title when testing for a repeat? 0/1
        comp_subtitle,      // 32 compare subtitle when testing for a repeat? 0/1/2
                            //      0 - no
                            //      1 - yes
                            //      2 - yes, if present
        comp_descr,         // 33 compare description when testing for a repeat? 0/1
        comp_extepg_info,   // 34 compare extended EPG info when testing for a repeat?
                            //    This entry is a bit field of the category IDs.
        repeats_in_days,    // 35 accepts repeats only within x days
        delete_after,       // 36 delete a recording automatically after x days
        keep_recordings,    // 37 but keep this number of recordings anyway
        switch_before,      // 38 minutes before switch (if action = 2)
        pause,              // 39 pause if x recordings already exist
        use_blacklists,     // 40 blacklist usage mode (0 none, 1 selection, 2 all)
        sel_blacklists,     // 41 selected blacklist IDs separated with '|'
        fuzzy_tolerance,    // 42 fuzzy tolerance value for fuzzy searching
        use_for_fav,        // 43 use this search in favorites menu (0 no, 1 yes)
        results_menu,       // 44 id of a menu search template
        autodelete,         // 45 auto deletion mode (0 don't delete search timer, 1 delete after given
                            //    count of recordings, 2 delete after given days after first recording)
        del_after_recs,     // 46 count of recordings after which to delete the search timer
        del_after_days,     // 47 count of days after the first recording after which to delete the search timer
        searchtimer_from,   // 48 first day where the search timer is active (see parameter 16)
        searchtimer_until,  // 49 last day where the search timer is active (see parameter 16)
        ignore_missing_epgcats, // 50 ignore missing EPG categories? 0/1
        unmute,             // 51 unmute sound if off when used as switch timer
        min_match,          // 52 percentage of match when comparing the summary of two events (with 'avoid repeats')
        content_descriptors,// 53 HEX representation of the content descriptors, each descriptor ID is represented with 2 chars
        comp_date           // 54 (0=no, 1=same day, 2=same week, 3=same month)
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
        val r = getField(field)

        if (r === null) {
            return 0
        }

        return Long.parseLong(getField(field))
    }

    def getNullableLongField(Field field) {
        val r = getField(field)

        if (r === null) {
            return null
        }

        return Long.parseLong(getField(field))
    }

    def setLongField(Field field, Long value) {
        setField(field, String.valueOf(value))
    }

    def getDateField(Field field) {
        val v = getField(field)

        if (v !== null && v.isNotEmpty) {
            val zoneId = Configuration.instance.defaultZoneId
            return LocalDateTime.ofInstant(Instant.ofEpochSecond(Long.parseLong(v)), zoneId).toLocalDate()
        }

        return null
    }

    def setDateField(Field field, LocalDate value) {
        if (value !== null) {
            val zoneId = Configuration.instance.defaultZoneId
            setField(field, String.valueOf(value.atStartOfDay(zoneId).toEpochSecond()))
        }
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
                } else if (ca.length == 1) {
                    searchCategories.put(ca.get(0), #{''});
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

    private def getTransformedField(Field field) {
        var value = cfg.get(field)

        if (value === null) {
            return ""
        }

        if (field == Field.extepg_infos) {
            value = searchCategories.keySet //
                .map(s | Integer.valueOf(s)) //
                .sort //
                .map(s | String.valueOf(s) + "#" + searchCategories.get(String.valueOf(s)).stream.collect(Collectors.joining(",")).replace(":", "!^colon^!")) //
                .stream //
                .collect(Collectors.joining("|"))
        }

        return value
    }

    def createSvdrpLine() {
        return Field.values.stream.map(field | getTransformedField(field)).collect(Collectors.joining(":"))
    }
}
