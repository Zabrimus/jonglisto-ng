package vdr.jonglisto.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
// @EqualsHashCode
@ToString
class Channel extends BaseDataWithName {
    public final static String ROOT_GROUP = "*"

    private int number
    private String id
    private String group
    private boolean radio
    private boolean encrypted
    private String source

    private String raw
    private Long frequence
    private String bouquet

    private String normalizedName

    new() {
    }

    new(String name) {
        this.name = name
    }
}
