package vdr.jonglisto.delegate

import java.io.Serializable
import java.util.stream.Collectors
import javax.enterprise.context.ApplicationScoped
import org.apache.shiro.subject.Subject
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs
import vdr.jonglisto.model.VDR
import vdr.jonglisto.xtend.annotation.Log
import vdr.jonglisto.xtend.annotation.TraceLog

@ApplicationScoped
@Log("jonglisto.delegate.config")
class Config implements Serializable {

    @TraceLog
    public def isDatabaseConfigured() {
        return Configuration.getInstance().isDatabaseConfigured()
    }

    @TraceLog
    public def getCustomDirectory() {
        return Configuration.getInstance().customDirectory
    }

    @TraceLog
    public def getFavourites() {
        return Configuration.getInstance().favourites
    }

    @TraceLog
    public def void saveFavourites() {
        Configuration.getInstance().saveFavourites()
    }

    @TraceLog
    public def getJcron() {
        return Configuration.getInstance().jcron
    }

    @TraceLog
    public def void saveJcron() {
        Configuration.getInstance().saveJcron()
    }

    @TraceLog
    public def getRemoteConfig() {
        return Configuration.getInstance().getRemoteConfig()
    }

    @TraceLog
    public def getEpgSeriesSeason() {
        return Configuration.getInstance().getEpgSeriesSeason
    }

    @TraceLog
    public def getEpgSeriesPart() {
        return Configuration.getInstance().getEpgSeriesPart
    }

    @TraceLog
    public def getEpgSeriesParts() {
        return Configuration.getInstance().getEpgSeriesParts
    }

    @TraceLog
    public def getEpgCategory() {
        return Configuration.getInstance().getEpgCategory
    }

    @TraceLog
    public def getEpgGenre() {
        return Configuration.getInstance().getEpgGenre
    }

    @TraceLog
    public def getDefaultSvdrpCommand() {
        return Configuration.getInstance().getDefaultSvdrpCommand
    }

    @TraceLog
    public def getEpgCustom() {
        return Configuration.getInstance().getEpgCustom
    }

    @TraceLog
    public def getVdr(String name) {
        return Configuration.getInstance().getVdr(name)
    }

    @TraceLog
    public def getEpgVdr() {
        return Configuration.getInstance().getEpgVdr
    }

    @TraceLog
    public def getChannelVdr() {
        return Configuration.getInstance().getChannelVdr
    }

    @TraceLog
    public def getVdrNames(Subject currentUser) {
        if (currentUser === null) {
            return Configuration.getInstance().getVdrNames
        } else {
            return Configuration.getInstance().getVdrNames.stream() //
                .filter[s | currentUser.isPermitted("vdr:" + Configuration.getInstance().getVdr(s).instance)]
                .collect(Collectors.toList)
        }
    }

    @TraceLog
    public def findVdr(String ip, int port) {
        return Configuration.getInstance().findVdr(ip, port)
    }

    @TraceLog
    public def getEpgTimeSelect() {
        return Configuration.getInstance().getEpgTimeSelect
    }

    @TraceLog
    public def getEpgProvider() {
        return Configuration.getInstance().getEpgProvider
    }

    @TraceLog
    public def getDbInformation() {
        return Configuration.getInstance().getDbInformation
    }

    @TraceLog
    public def pingHost(VDR vdr) {
        return Configuration.getInstance().pingHost(vdr)
    }

    @TraceLog
    public def void addJob(Jobs job) {
        Configuration.getInstance().addJob(job)
    }

    @TraceLog
    public def void deleteJob(Jobs job) {
        Configuration.getInstance().deleteJob(job)
    }

    @TraceLog
    public def void changeJob(Jobs job) {
        Configuration.getInstance().changeJob(job)
    }

    @TraceLog
    def toggleJob(Jobs job) {
        Configuration.getInstance().toggleJob(job)
    }

    @TraceLog
    public def showScraperImages() {
        Configuration.getInstance().isShowScraperImages()
    }

    // @TraceLog // -- do not work and i don't understand why not
    public def getScraperPath() {
        Configuration.getInstance().scraperPath
    }
}
