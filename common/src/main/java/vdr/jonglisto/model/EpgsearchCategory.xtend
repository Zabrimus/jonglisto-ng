package vdr.jonglisto.model

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString
class EpgsearchCategory {
    private int id
    private String internalName
    private String publicName
    private List<String> values
    private Integer searchMode
}
