package vdr.jonglisto.model

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString
class VDROsd {
    var String title
    var List<VDROsdMenuItem> menuItems = new ArrayList<VDROsdMenuItem>
    var String textBlock
    var String red
    var String green
    var String yellow
    var String blue
    var String statusMessage

    var List<Integer> layout = new ArrayList<Integer>

    def addMenuItem(String type, String menuItem) {
        menuItems.add(new VDROsdMenuItem(type, menuItem))
    }

    def addLayout(Integer c) {
        layout.add(c)
    }
}
