package vdr.jonglisto.model

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString
class VDROsdMenuItem {
    var boolean isSelected = false
    var List<String> items

    new(String type, String line) {
        isSelected = type == 'S'
        items = line.split("\t").toList
    }
}
