package vdr.jonglisto.db

import vdr.jonglisto.model.VDR

import static vdr.jonglisto.util.Utils.*

class VdrService {

    new() {
    }

    public def getConfiguredVdr() {
        using(Database.get.open) [
            return createQuery("select name, uuid, ip as host, svdrp as port from vdrs where svdrp is not null") //
                .throwOnMappingFailure(false) //
                .executeAndFetch(VDR)
        ]
    }

}
