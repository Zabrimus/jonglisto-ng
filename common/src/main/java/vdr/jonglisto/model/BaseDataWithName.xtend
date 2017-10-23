package vdr.jonglisto.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
// @EqualsHashCode
@ToString
class BaseDataWithName extends BaseData {
    var String name
}
