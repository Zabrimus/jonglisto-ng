package vdr.jonglisto.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
// @EqualsHashCode
@ToString
class Channel extends BaseDataWithName {
    public final static String ROOT_GROUP = "*"

    int number
    String id
    String group
    boolean radio
    boolean encrypted
    String source

    String raw
    Long frequence
    String bouquet

    String normalizedName

    new() {
    }

    new(String name) {
        this.name = name
    }
}
