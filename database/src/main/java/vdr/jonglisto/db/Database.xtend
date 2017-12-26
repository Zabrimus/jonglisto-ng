package vdr.jonglisto.db

import org.apache.tomcat.jdbc.pool.DataSource
import org.apache.tomcat.jdbc.pool.PoolProperties
import org.sql2o.Sql2o
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.xtend.annotation.Log

@Log
class Database {
    private static var Sql2o sql2o
    private static var boolean isConfigured = true

    private new() {
    }

    static def get() {
        if (!isConfigured) {
            return null
        }

        if (sql2o === null) {
            synchronized (Database) {
                if (sql2o === null) {
                    sql2o = createInstance();
                }
            }
        }

        return sql2o
    }

    static def isConfigured() {
        return isConfigured
    }

    private static def createInstance() {
        val infos = Configuration.getInstance().dbInformation

        val username = infos.get("username") as String
        val password = infos.get("password") as String
        val host = infos.get("host") as String
        val port = infos.get("port") as Integer
        val database = infos.get("database") as String

        if ((username === null) || (password === null) || (host === null) || (port == 0) || (database === null)) {
            log.info("epg2vdr database is not fully configured. Ignoring database requests.")
            isConfigured = false
            return null
        }

        val datasource = new DataSource();
        datasource.setPoolProperties(createPoolProperties(host, port, username, password, database));
        return new Sql2o(datasource)
    }

    private static def createPoolProperties(String host, int port, String username, String password, String database) {
        val p = new PoolProperties();
        p.setUrl("jdbc:mysql://" + host + ":"  + port + "/" + database);
        p.setDriverClassName("com.mysql.jdbc.Driver");
        p.setUsername(username);
        p.setPassword(password);
        p.setJmxEnabled(false);
        p.setTestWhileIdle(false);
        p.setTestOnBorrow(true);
        p.setValidationQuery("SELECT 1");
        p.setTestOnReturn(false);
        p.setValidationInterval(30000);
        p.setTimeBetweenEvictionRunsMillis(30000);
        p.setMaxActive(10);
        p.setInitialSize(1);
        p.setMaxWait(10000);
        p.setRemoveAbandonedTimeout(60);
        p.setMinEvictableIdleTimeMillis(30000);
        p.setMinIdle(1);
        p.maxIdle = 10
        p.setLogAbandoned(true);
        p.setRemoveAbandoned(true);

        return p
    }
}
