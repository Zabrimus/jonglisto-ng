package vdr.jonglisto.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
// @EqualsHashCode
@ToString
class EpgProvider extends BaseDataWithName {
    enum Provider { TVSP, TVM, EPGDATA }
    
    val Provider provider
    val String epgid
    var String normalizedName
    var boolean visible = true
    
    new(Provider provider, String epgid, String name, String normalizedName, boolean visible) {
        this(provider, epgid, name, normalizedName)
        this.visible = visible   
    }
    
    new(Provider provider, String epgid, String name, String normalizedName) {
        this.provider = provider
        this.epgid = epgid
        this.name = name
        this.normalizedName = normalizedName
    }
}
