package vdr.jonglisto.model

import java.util.HashMap
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString
class EpgsearchSearchTimer {
    enum Field {
        id, pattern, use_time, time_start, time_stop, use_channel, channels, matchcase,
        mode, use_title, use_subtitle, use_descr, use_duration, min_duration, max_duration,
        has_action, use_days, which_days, is_series, directory, prio, lft, bstart, bstop,
        use_vps, action, use_extepg, extepg_infos, avoid_repeats, allowed_repeats, comp_title,
        comp_subtitle, comp_descr, comp_extepg_info,repeats_in_days, delete_after, keep_recordings,
        switch_before, pause, use_blacklists, sel_blacklists, fuzzy_tolerance, use_for_fav,
        results_menu, autodelete, del_after_recs, del_after_days, searchtimer_from, searchtimer_until,
        ignore_missing_epgcats, unmute, min_match, unused
    }

    // epgsearch contains too much different information, therefore a non-optimal datatype is selected
    private Map<Field, String> cfg = new HashMap<Field, String>

    def getField(Field field) {
        return cfg.get(field)
    }

    def setField(Field field, String value) {
        cfg.put(field, value)
    }
}
/*
    my $timer;
        ($timer->{id},               # 1 - unique search timer id
         $timer->{pattern},          # 2 - the search term
         $timer->{use_time},         # 3 - use time? 0/1
         $timer->{time_start},       # 4 - start time in HHMM
         $timer->{time_stop},        # 5 - stop time in HHMM
         $timer->{use_channel},      # 6 - use channel? 0 = no,  1 = Intervall, 2 = Channel group, 3 = FTA only
         $timer->{channels},         # 7 - if 'use channel' = 1 then channel id[|channel id] in vdr format,
                                     #     one entry or min/max entry separated with |, if 'use channel' = 2
                                     #     then the channel group name
         $timer->{matchcase},        # 8 - match case? 0/1
         $timer->{mode},             # 9 - search mode:
                                     #      0 - the whole term must appear as substring
                                     #      1 - all single terms (delimiters are blank,',', ';', '|' or '~')
                                     #          must exist as substrings.
                                     #      2 - at least one term (delimiters are blank, ',', ';', '|' or '~')
                                     #          must exist as substring.
                                     #      3 - matches exactly
                                     #      4 - regular expression
         $timer->{use_title},        #10 - use title? 0/1
         $timer->{use_subtitle},     #11 - use subtitle? 0/1
         $timer->{use_descr},        #12 - use description? 0/1
         $timer->{use_duration},     #13 - use duration? 0/1
         $timer->{min_duration},     #14 - min duration in minutes
         $timer->{max_duration},     #15 - max duration in minutes
         $timer->{has_action},       #16 - use as search timer? 0/1
         $timer->{use_days},         #17 - use day of week? 0/1
         $timer->{which_days},       #18 - day of week (0 = sunday, 1 = monday...)
         $timer->{is_series},        #19 - use series recording? 0/1
         $timer->{directory},        #20 - directory for recording
         $timer->{prio},             #21 - priority of recording
         $timer->{lft},              #22 - lifetime of recording
         $timer->{bstart},           #23 - time margin for start in minutes
         $timer->{bstop},            #24 - time margin for stop in minutes
         $timer->{use_vps},          #25 - use VPS? 0/1
         $timer->{action},           #26 - action:
                                     #      0 = create a timer
                                     #      1 = announce only via OSD (no timer)
                                     #      2 = switch only (no timer)
         $timer->{use_extepg},       #27 - use extended EPG info? 0/1  #TODO
         $timer->{extepg_infos},     #28 - extended EPG info values. This entry has the following format #TODO
                                     #     (delimiter is '|' for each category, '#' separates id and value):
                                     #     1 - the id of the extended EPG info category as specified in
                                     #         epgsearchcats.conf
                                     #     2 - the value of the extended EPG info category
                                     #         (a ':' will be tranlated to "!^colon^!", e.g. in "16:9")
         $timer->{avoid_repeats},    #29 - avoid repeats? 0/1
         $timer->{allowed_repeats},  #30 - allowed repeats
         $timer->{comp_title},       #31 - compare title when testing for a repeat? 0/1
         $timer->{comp_subtitle},    #32 - compare subtitle when testing for a repeat? 0/1
         $timer->{comp_descr},       #33 - compare description when testing for a repeat? 0/1
         $timer->{comp_extepg_info}, #34 - compare extended EPG info when testing for a repeat? #TODO
                                     #     This entry is a bit field of the category ids.
         $timer->{repeats_in_days},  #35 - accepts repeats only within x days
         $timer->{delete_after},     #36 - delete a recording automatically after x days
         $timer->{keep_recordings},  #37 - but keep this number of recordings anyway
         $timer->{switch_before},    #38 - minutes before switch (if action = 2)
         $timer->{pause},            #39 - pause if x recordings already exist
         $timer->{use_blacklists},   #40 - blacklist usage mode (0 none, 1 selection, 2 all)
         $timer->{sel_blacklists},   #41 - selected blacklist IDs separated with '|'
         $timer->{fuzzy_tolerance},  #42 - fuzzy tolerance value for fuzzy searching
         $timer->{use_for_fav},      #43 - use this search in favorites menu (0 no, 1 yes)
         $timer->{results_menu},           #44 - menu to display results
         $timer->{autodelete},             #45 - delMode ( 0 = no autodelete, 1 = after x recordings, 2 = after y days after 1. recording)
         $timer->{del_after_recs},         #46 - delAfterCountRecs (x recordings)
         $timer->{del_after_days},         #47 - delAfterDaysOfFirstRec (y days)
         $timer->{searchtimer_from},       #48 - useAsSearchTimerFrom (if "use as search timer?" = 2)
         $timer->{searchtimer_until},      #49 - useAsSearchTimerTil (if "use as search timer?" = 2)
         $timer->{ignore_missing_epgcats}, #50 - ignoreMissingEPGCats
         $timer->{unmute},                 #51 - unmute sound if off when used as switch timer
         $timer->{min_match},              #52 - the minimum required match in percent when descriptions are compared to avoid repeats (-> 33)
         $timer->{unused}) = split(/:/, $line);

 */
