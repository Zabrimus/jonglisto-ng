package vdr.jonglisto.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode

@Accessors
@EqualsHashCode
class VDRDiskStat extends BaseData {
    var long sizeTotal
    var long sizeUsed

    new(long total, long used) {
        sizeTotal = total
        sizeUsed = used
    }

    def toStringTotal() {
        return toHuman(sizeTotal)
    }

    def toStringUsed() {
        return toHuman(sizeUsed)
    }

    def toStringFree() {
        return toHuman(sizeTotal - sizeUsed)
    }

    def toStringUsedPerc() {
        return (sizeTotal - sizeUsed) * 100 / sizeTotal
    }

    private def toHuman(long mb) {
        val exp = (Math.log(mb * 1024 * 1024) / Math.log(1024)) as int
        val pre = "kMGTPE".charAt(exp-1)
        return String.format("%.1f %sB", mb * 1024 * 1024 / Math.pow(1024, exp), pre);
    }
}
