package vdr.jonglisto.model

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@ToString
class TreeRecording {
    private var String name
    private var boolean folder
    private Recording recording

    // only useful if folder == true
    private long length
    private long childCount
    private long newCount

    private var List<TreeRecording> children

    new(String name) {
        this.name = name
        this.folder = true
    }

    new (String name, Recording recording) {
        this.name = name
        this.folder = false
        this.recording = recording
    }

    public def getChildren() {
        if (folder && children === null) {
            children = new ArrayList<TreeRecording>
        }

        return children
    }
}
