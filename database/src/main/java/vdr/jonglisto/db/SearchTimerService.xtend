package vdr.jonglisto.db

import vdr.jonglisto.model.SearchTimer

import static vdr.jonglisto.util.Utils.*

class SearchTimerService {

    new() {
    }

    public def getSearchTimers() {
        using(Database.get.open) [
            return createQuery("select st.*, v.name as vdrname, v.ip as ip, v.svdrp as svdrp from searchtimers st left join vdrs v on v.uuid = st.vdruuid where st.state <> 'D'") //
                .throwOnMappingFailure(false) //
                .executeAndFetch(SearchTimer)
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

    public def save(SearchTimer timer) {
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
                query.addParameter("casesensitiv", timer.casesensitiv)
                query.addParameter("repeatfields", timer.repeatfields)
                query.addParameter("episodename", timer.episodename)
                query.addParameter("season", timer.season)
                query.addParameter("seasonpart", timer.seasonpart)
                query.addParameter("category", timer.category)
                query.addParameter("genre", timer.genre)
                query.addParameter("year", timer.year)
                query.addParameter("tipp", timer.tipp)
                query.addParameter("noepgmatch", timer.noepgmatch)
                query.addParameter("type", timer.type)
                query.addParameter("namingmode", timer.namingmode)
                query.addParameter("active", timer.active)
                query.addParameter("source", timer.source)
                query.addParameter("vdruuid", timer.vdruuid)
                query.addParameter("weekdays", timer.weekdays)
                query.addParameter("nextdays", timer.nextdays)
                query.addParameter("starttime", timer.starttime)
                query.addParameter("endtime", timer.endtime)
                query.addParameter("directory", timer.directory)
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
                query.addParameter("casesensitiv", timer.casesensitiv)
                query.addParameter("repeatfields", timer.repeatfields)
                query.addParameter("episodename", timer.episodename)
                query.addParameter("season", timer.season)
                query.addParameter("seasonpart", timer.seasonpart)
                query.addParameter("category", timer.category)
                query.addParameter("genre", timer.genre)
                query.addParameter("year", timer.year)
                query.addParameter("tipp", timer.tipp)
                query.addParameter("noepgmatch", timer.noepgmatch)
                query.addParameter("type", timer.type)
                query.addParameter("state", timer.state)
                query.addParameter("namingmode", timer.namingmode)
                query.addParameter("active", timer.active)
                query.addParameter("source", timer.source)
                query.addParameter("hits", 0)
                query.addParameter("vdruuid", timer.vdruuid)
                query.addParameter("weekdays", timer.weekdays)
                query.addParameter("nextdays", timer.nextdays)
                query.addParameter("starttime", timer.starttime)
                query.addParameter("endtime", timer.endtime)
                query.addParameter("directory", timer.directory)
                query.addParameter("priority", timer.priority)
                query.addParameter("lifetime", timer.lifetime)
                query.addParameter("vps", timer.vps)
                query.addParameter("childlock", timer.childlock)

                query.executeUpdate();
                commit();
            }
        ]
    }

/*
    val text = using(new FileReader('build.properties')) [
        val buffer = CharBuffer::allocate(1024)
        read(buffer)
        buffer.rewind
        buffer.toString
    ]
 */


/*
    public List<SearchTimer> getSearchTimers() {
        Sql2o sql2o = configuration.getSql2oEpg2vdr();

        try (Connection con = sql2o.open()) {
            List<SearchTimer> result = new ArrayList<>();

            List<Map<String, Object>> dbResult = con.createQuery("SELECT * FROM searchtimers where state <> 'D'") //
                    .executeAndFetchTable().asList();

            dbResult.stream().forEach(s -> {
                // Make a copy of the map, because sql2o implementation is
                // immutable and throws a NullPointerException, if the key is
                // not found
                Map<String, Object> newResult = new HashMap<>();
                s.keySet().stream().forEach(resultKey -> newResult.put(resultKey, s.get(resultKey)));

                // enrichment
                SearchTimer st = new SearchTimer(newResult);
                String vdrUuid = st.getVdrUuid();
                if ("any".equals(vdrUuid)) {
                    st.setVdrName("auto");
                } else {
                    st.setVdrName(configuration.getVdr(vdrUuid).getDisplayName());
                }

                result.add(st);
            });

            return result;
        }
    }

    public SearchTimer getSearchTimer(Long id) {
        Sql2o sql2o = configuration.getSql2oEpg2vdr();

        try (Connection con = sql2o.open()) {
            Map<String, Object> dbResult = con.createQuery("SELECT * FROM searchtimers where id = :id") //
                    .addParameter("id", id) //
                    .executeAndFetchTable().asList().get(0);

            // Make a copy of the map, because sql2o implementation is immutable
            // and throws a NullPointerException, if the key is not found
            Map<String, Object> newResult = new HashMap<>();
            dbResult.keySet().stream().forEach(resultKey -> newResult.put(resultKey, dbResult.get(resultKey)));

            // enrichment
            SearchTimer st = new SearchTimer(newResult);
            String vdrUuid = st.getVdrUuid();
            if ("any".equals(vdrUuid)) {
                st.setVdrName("auto");
            } else {
                st.setVdrName(configuration.getVdr(vdrUuid).getDisplayName());
            }

            return st;
        }
    }

    public void insertSearchTimer(SearchTimer timer) {
        Sql2o sql2o = configuration.getSql2oEpg2vdr();

        try (Connection con = sql2o.beginTransaction()) {
            String sql = "INSERT INTO epg2vdr.searchtimers " + //
                    "(inssp, channelids, chexclude, chformat, name, expression, expression1, searchmode, searchfields, searchfields1, casesensitiv, repeatfields, "
                    + // "
                    "episodename, season, seasonpart, category, genre, year, tipp, noepgmatch, type, state, namingmode, active, source, hits, vdruuid, weekdays, "
                    + //
                    "nextdays, starttime, endtime, directory, priority, lifetime, vps, childlock) " + //
                    "VALUES(UNIX_TIMESTAMP(), :channelids, :chexclude, :chformat, :name, :expression, :expression1, :searchmode, :searchfields, :searchfields1, :casesensitiv, :repeatfields, "
                    + //
                    ":episodename, :season, :seasonpart, :category, :genre, :year, :tipp, :noepgmatch, :type, :state, :namingmode, :active, :source, :hits, :vdruuid, :weekdays, "
                    + //
                    ":nextdays, :starttime, :endtime, :directory, :priority, :lifetime, :vps, :childlock)";

            Query query = con.createQuery(sql);
            query.getParamNameToIdxMap().keySet().stream()
                    .forEach(key -> query.addParameter(key, timer.getRawDbData().get(key)));
            query.executeUpdate();

            con.commit();
        }
    }

    public void updateSearchTimer(SearchTimer timer) {
        Sql2o sql2o = configuration.getSql2oEpg2vdr();

        try (Connection con = sql2o.beginTransaction()) {
            String sql = "update searchtimers " + //
                    "set updsp = UNIX_TIMESTAMP(), channelids = :channelids, chexclude = :chexclude, chformat = :chformat, "
                    + //
                    "name = :name, expression = :expression, expression1 = :expression1, searchmode = :searchmode , searchfields = :searchfields, "
                    + //
                    "searchfields1 = :searchfields1, casesensitiv = :casesensitiv, repeatfields = :repeatfields, episodename = :episodename, "
                    + //
                    "season = :season, seasonpart = :seasonpart, category = :category, genre = :genre, year = :year, tipp = :tipp, "
                    + //
                    "noepgmatch = :noepgmatch, type = :type, namingmode = :namingmode, active = :active, source = :source, vdruuid = :vdruuid, "
                    + //
                    "weekdays = :weekdays, nextdays = :nextdays, starttime = :starttime, endtime = :endtime, directory = :directory, "
                    + //
                    "priority = :priority, lifetime = :lifetime, vps = :vps, childlock = :childlock " + //
                    "where id = :id";

            Query query = con.createQuery(sql);
            query.getParamNameToIdxMap().keySet().stream()
                    .forEach(key -> query.addParameter(key, timer.getRawDbData().get(key)));
            query.executeUpdate();

            con.commit();
        }
    }

    public void deleteSearchTimer(Long id) {
        Sql2o sql2o = configuration.getSql2oEpg2vdr();

        try (Connection con = sql2o.beginTransaction()) {
            con.createQuery("update searchtimers set state = 'D' where id = :ID").addParameter("ID", id)
                    .executeUpdate();

            con.commit();
        }
    }

    public void toggleActive(Long id) {
        Sql2o sql2o = configuration.getSql2oEpg2vdr();

        try (Connection con = sql2o.beginTransaction()) {
            con.createQuery("update searchtimers set active = not active where id = :ID").addParameter("ID", id)
                    .executeUpdate();

            con.commit();
        }
    }

 */
}
