package vdr.jonglisto.model

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString
class EpgsearchCategory {
    int id
    String internalName
    String publicName
    List<String> values
    Integer searchMode
}
