package vdr.jonglisto.delegate

import java.io.Serializable
import java.util.stream.Collectors
import javax.enterprise.context.ApplicationScoped
import org.apache.shiro.subject.Subject
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.VDR

@ApplicationScoped
class Config implements Serializable {

    public def isDatabaseConfigured() {
        return Configuration.getInstance().isDatabaseConfigured()
    }

    public def getCustomDirectory() {
        return Configuration.getInstance().customDirectory
    }

    public def getFavourites() {
        return Configuration.getInstance().favourites
    }

    public def void saveFavourites() {
        Configuration.getInstance().saveFavourites()
    }

    public def getJcron() {
        return Configuration.getInstance().jcron
    }

    public def void saveJcron() {
        Configuration.getInstance().saveJcron()
    }

    public def getScheduker() {
        return Configuration.getInstance().getScheduler()
    }

    public def getRemoteConfig() {
        return Configuration.getInstance().getRemoteConfig()
    }

    public def getEpgSeriesSeason() {
        return Configuration.getInstance().getEpgSeriesSeason
    }

    public def getEpgSeriesPart() {
        return Configuration.getInstance().getEpgSeriesPart
    }

    public def getEpgSeriesParts() {
        return Configuration.getInstance().getEpgSeriesParts
    }

    public def getEpgCategory() {
        return Configuration.getInstance().getEpgCategory
    }

    public def getEpgGenre() {
        return Configuration.getInstance().getEpgGenre
    }

    public def getDefaultSvdrpCommand() {
        return Configuration.getInstance().getDefaultSvdrpCommand
    }

    public def getEpgCustom() {
        return Configuration.getInstance().getEpgCustom
    }

    public def getVdr(String name) {
        return Configuration.getInstance().getVdr(name)
    }

    public def getEpgVdr() {
        return Configuration.getInstance().getEpgVdr
    }

    public def getChannelVdr() {
        return Configuration.getInstance().getChannelVdr
    }

    public def getVdrNames(Subject currentUser) {
        if (currentUser === null) {
            return Configuration.getInstance().getVdrNames
        } else {
            return Configuration.getInstance().getVdrNames.stream() //
                .filter[s | currentUser.isPermitted("vdr:" + Configuration.getInstance().getVdr(s).instance)]
                .collect(Collectors.toList)
        }
    }

    public def findVdr(String ip, int port) {
        return Configuration.getInstance().findVdr(ip, port)
    }

    public def getEpgTimeSelect() {
        return Configuration.getInstance().getEpgTimeSelect
    }

    public def getEpgProvider() {
        return Configuration.getInstance().getEpgProvider
    }

    public def getDbInformation() {
        return Configuration.getInstance().getDbInformation
    }

    public def pingHost(VDR vdr) {
        return Configuration.getInstance().pingHost(vdr)
    }
}
