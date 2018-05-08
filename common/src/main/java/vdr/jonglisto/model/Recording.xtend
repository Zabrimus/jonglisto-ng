package vdr.jonglisto.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
// @EqualsHashCode
@ToString
class Recording extends BaseDataWithName {
    var long id
    var long start
    var int length
    var boolean seen
    String path
    var Epg epg
    var String folder

    new() {
    }

    new(String folder) {
        this.folder = folder
    }
}

