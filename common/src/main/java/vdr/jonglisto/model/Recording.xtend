package vdr.jonglisto.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
// @EqualsHashCode
@ToString
class Recording extends BaseDataWithName {
    private var long id
    private var long start
    private var int length
    private var boolean seen
    private String path
    private var Epg epg
    private var String folder

    new() {
    }

    new(String folder) {
        this.folder = folder
    }
}

