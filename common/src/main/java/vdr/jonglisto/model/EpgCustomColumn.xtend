package vdr.jonglisto.model

import java.util.regex.Pattern
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString
class EpgCustomColumn {
    val String header
    val Pattern pattern
    val String output
}
