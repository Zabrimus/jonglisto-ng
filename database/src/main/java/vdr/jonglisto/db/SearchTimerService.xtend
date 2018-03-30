package vdr.jonglisto.db


import static vdr.jonglisto.util.Utils.*
import vdr.jonglisto.model.EpgdSearchTimer

class SearchTimerService {

    new() {
    }

    public def getSearchTimerName(String id) {
        using(Database.get.open) [
            return createQuery("select name from searchtimers where id = :id") //
                .addParameter("id", Long.valueOf(id))
                .throwOnMappingFailure(false) //
                .executeScalar(String)
        ]
    }

    public def getSearchTimers() {
        using(Database.get.open) [
            return createQuery("select st.*, v.name as vdrname, v.ip as ip, v.svdrp as svdrp from searchtimers st left join vdrs v on v.uuid = st.vdruuid where st.state <> 'D'") //
                .throwOnMappingFailure(false) //
                .executeAndFetch(EpgdSearchTimer)
        ]
    }

    public def getGenres() {
        using(Database.get.open) [
            return createQuery(
                    "select distinct sub_genre from eventsviewplain where sub_genre is not null order by sub_genre") //
                    .executeAndFetch(String);
        ]
    }

    public def getCategories() {
        using(Database.get.open) [
            return createQuery(
                    "select distinct sub_category from eventsviewplain where sub_category is not null order by sub_category") //
                    .executeAndFetch(String);
        ]
    }

    public def void toogleActive(EpgdSearchTimer timer) {
        using(Database.get.beginTransaction) [
            if (timer.id > 0) {
                val value = if (timer.active == 1) 0 else 1
                val sql = "update searchtimers set active = :active where id = :id"
                val query = createQuery(sql)

                query.addParameter("active", value)
                query.addParameter("id", timer.id)

                query.executeUpdate();
                commit();
            }
        ]
    }

    public def void deleteSearchTimer(EpgdSearchTimer timer) {
        using(Database.get.beginTransaction) [
            if (timer.id > 0) {
                val sql = "update searchtimers set state = 'D' where id = :id"
                val query = createQuery(sql)

                query.addParameter("id", timer.id)

                query.executeUpdate();
                commit();
            }
        ]
    }

    public def save(EpgdSearchTimer timer) {
        using(Database.get.beginTransaction) [
            if (timer.id > 0) {
                val sql = "update searchtimers " + //
                    "set updsp = UNIX_TIMESTAMP(), channelids = :channelids, chexclude = :chexclude, chformat = :chformat, " + //
                    "name = :name, expression = :expression, expression1 = :expression1, searchmode = :searchmode , searchfields = :searchfields, " + //
                    "searchfields1 = :searchfields1, casesensitiv = :casesensitiv, repeatfields = :repeatfields, episodename = :episodename, " + //
                    "season = :season, seasonpart = :seasonpart, category = :category, genre = :genre, year = :year, tipp = :tipp, " + //
                    "noepgmatch = :noepgmatch, type = :type, namingmode = :namingmode, active = :active, source = :source, vdruuid = :vdruuid, " + //
                    "weekdays = :weekdays, nextdays = :nextdays, starttime = :starttime, endtime = :endtime, directory = :directory, " + //
                    "priority = :priority, lifetime = :lifetime, vps = :vps, childlock = :childlock " + //
                    "where id = :id";

                val query = createQuery(sql)

                query.addParameter("channelids", timer.channelIds)
                query.addParameter("chexclude", timer.chexclude)
                query.addParameter("chformat", timer.chformat)
                query.addParameter("name", timer.name)
                query.addParameter("expression", timer.expression)
                query.addParameter("expression1", timer.expression1)
                query.addParameter("searchmode", timer.searchmode)
                query.addParameter("searchfields", timer.searchfields)
                query.addParameter("searchfields1", timer.searchfields1)
                query.addParameter("casesensitiv", timer.casesensitiv ?: 0)
                query.addParameter("repeatfields", timer.repeatfields)
                query.addParameter("episodename", timer.episodename)
                query.addParameter("season", timer.season)
                query.addParameter("seasonpart", timer.seasonpart)
                query.addParameter("category", if (timer.category == "") null else timer.category)
                query.addParameter("genre", if (timer.genre == "") null else timer.genre)
                query.addParameter("year", timer.year)
                query.addParameter("tipp", timer.tipp)
                query.addParameter("noepgmatch", timer.noepgmatch ?: 0)
                query.addParameter("type", timer.type)
                query.addParameter("namingmode", timer.namingmode)
                query.addParameter("active", timer.active)
                query.addParameter("source", "webif")
                query.addParameter("vdruuid", timer.vdruuid)
                query.addParameter("weekdays", timer.weekdays)
                query.addParameter("nextdays", timer.nextdays)
                query.addParameter("starttime", timer.starttime)
                query.addParameter("endtime", timer.endtime)
                query.addParameter("directory", if(timer.directory == "") null else timer.directory)
                query.addParameter("priority", timer.priority)
                query.addParameter("lifetime", timer.lifetime)
                query.addParameter("vps", timer.vps)
                query.addParameter("childlock", timer.childlock)
                query.addParameter("id", timer.id)

                query.executeUpdate();
                commit();
            } else {
                val sql = "INSERT INTO epg2vdr.searchtimers " + //
                        "(inssp, channelids, chexclude, chformat, name, expression, expression1, searchmode, searchfields, searchfields1, casesensitiv, repeatfields, " + // "
                        "episodename, season, seasonpart, category, genre, year, tipp, noepgmatch, type, state, namingmode, active, source, hits, vdruuid, weekdays, " + //
                        "nextdays, starttime, endtime, directory, priority, lifetime, vps, childlock) " + //
                        "VALUES(UNIX_TIMESTAMP(), :channelids, :chexclude, :chformat, :name, :expression, :expression1, :searchmode, :searchfields, :searchfields1, :casesensitiv, :repeatfields, " + //
                        ":episodename, :season, :seasonpart, :category, :genre, :year, :tipp, :noepgmatch, :type, :state, :namingmode, :active, :source, :hits, :vdruuid, :weekdays, " + //
                        ":nextdays, :starttime, :endtime, :directory, :priority, :lifetime, :vps, :childlock)";

                val query = createQuery(sql)

                query.addParameter("channelids", timer.channelIds)
                query.addParameter("chexclude", timer.chexclude)
                query.addParameter("chformat", timer.chformat)
                query.addParameter("name", timer.name)
                query.addParameter("expression", timer.expression)
                query.addParameter("expression1", timer.expression1)
                query.addParameter("searchmode", timer.searchmode)
                query.addParameter("searchfields", timer.searchfields)
                query.addParameter("searchfields1", timer.searchfields1)
                query.addParameter("casesensitiv", timer.casesensitiv ?: 0)
                query.addParameter("repeatfields", timer.repeatfields)
                query.addParameter("episodename", timer.episodename)
                query.addParameter("season", timer.season)
                query.addParameter("seasonpart", timer.seasonpart)
                query.addParameter("category", if (timer.category == "") null else timer.category)
                query.addParameter("genre", if (timer.genre == "") null else timer.genre)
                query.addParameter("year", timer.year)
                query.addParameter("tipp", timer.tipp)
                query.addParameter("noepgmatch", timer.noepgmatch ?: 0)
                query.addParameter("type", timer.type)
                query.addParameter("state", if (timer.state === null) "" else timer.state)
                query.addParameter("namingmode", timer.namingmode)
                query.addParameter("active", timer.active)
                query.addParameter("source", "webif")
                query.addParameter("hits", 0)
                query.addParameter("vdruuid", timer.vdruuid)
                query.addParameter("weekdays", timer.weekdays)
                query.addParameter("nextdays", timer.nextdays)
                query.addParameter("starttime", timer.starttime)
                query.addParameter("endtime", timer.endtime)
                query.addParameter("directory", if(timer.directory == "") null else timer.directory)
                query.addParameter("priority", timer.priority)
                query.addParameter("lifetime", timer.lifetime)
                query.addParameter("vps", timer.vps)
                query.addParameter("childlock", timer.childlock)

                query.executeUpdate();
                commit();
            }
        ]
    }
}
