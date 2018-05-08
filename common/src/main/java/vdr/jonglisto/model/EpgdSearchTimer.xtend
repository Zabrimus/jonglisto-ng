package vdr.jonglisto.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString
class EpgdSearchTimer {
    long id
    String channelIds
    String chexclude
    String chformat
    String name
    String expression
    String expression1
    Integer searchmode
    Integer searchfields
    Integer searchfields1
    Integer casesensitiv
    Integer repeatfields
    String episodename
    String season
    String seasonpart
    String category
    String genre
    Integer year
    String tipp
    String noepgmatch
    String type
    String state
    Integer namingmode
    String template
    Integer active
    String source
    Integer hits
    String vdruuid
    Integer weekdays
    String nextdays
    Long starttime
    Long endtime
    String directory
    Integer priority
    Integer lifetime
    Integer vps
    String childlock
    String vdrname
    String ip
    Integer svdrp
}
