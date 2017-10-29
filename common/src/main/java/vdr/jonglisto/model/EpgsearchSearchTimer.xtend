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
