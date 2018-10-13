package vdr.jonglisto.delegate

import java.io.Serializable
import java.util.Collections
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
    public final static long serialVersionUID = 1L

    @TraceLog
    def isDatabaseConfigured() {
        return Configuration.getInstance().isDatabaseConfigured()
    }

    @TraceLog
    def getCustomDirectory() {
        return Configuration.getInstance().customDirectory
    }

    @TraceLog
    def getFavourites() {
        return Configuration.getInstance().favourites
    }

    @TraceLog
    def void saveFavourites() {
        Configuration.getInstance().saveFavourites()
    }

    @TraceLog
    def getJcron() {
        return Configuration.getInstance().jcron
    }

    @TraceLog
    def void saveJcron() {
        Configuration.getInstance().saveJcron()
    }

    @TraceLog
    def void loadExtEpgSearch() {
        Configuration.getInstance().loadExtEpgSearch
    }

    @TraceLog
    def getExtEpgSearch() {
        return Configuration.getInstance().extEpgSearch
    }

    @TraceLog
    def void saveExtEpgSearch() {
        Configuration.getInstance().saveExtEpgSearch()
    }

    @TraceLog
    def getRemoteConfig() {
        return Configuration.getInstance().getRemoteConfig()
    }

    @TraceLog
    def getEpgSeriesSeason() {
        return Configuration.getInstance().getEpgSeriesSeason
    }

    @TraceLog
    def getEpgSeriesPart() {
        return Configuration.getInstance().getEpgSeriesPart
    }

    @TraceLog
    def getEpgSeriesParts() {
        return Configuration.getInstance().getEpgSeriesParts
    }

    @TraceLog
    def getEpgCategory() {
        return Configuration.getInstance().getEpgCategory
    }

    @TraceLog
    def getEpgGenre() {
        return Configuration.getInstance().getEpgGenre
    }

    @TraceLog
    def getDefaultSvdrpCommand() {
        return Configuration.getInstance().getDefaultSvdrpCommand
    }

    @TraceLog
    def getEpgCustom() {
        return Configuration.getInstance().getEpgCustom
    }

    @TraceLog
    def getVdr(String name) {
        return Configuration.getInstance().getVdr(name)
    }

    @TraceLog
    def getEpgVdr() {
        return Configuration.getInstance().getEpgVdr
    }

    @TraceLog
    def getChannelVdr() {
        return Configuration.getInstance().getChannelVdr
    }

    @TraceLog
    def getVdrNames(Subject currentUser) {
        if (currentUser === null) {
            return Configuration.getInstance().getVdrNames
        } else {
            val names = Configuration.getInstance().getVdrNames

            if (names === null) {
                return Collections.emptyList()
            }

            return names.stream() //
                .filter[s | {
                    val v = Configuration.getInstance().getVdr(s)

                    if (v === null) {
                        return false
                    } else {
                        return currentUser.isPermitted("vdr:" + v.instance)
                    }
                }]
                .collect(Collectors.toList)
        }
    }

    @TraceLog
    def findVdr(String ip, int port) {
        return Configuration.getInstance().findVdr(ip, port)
    }

    @TraceLog
    def getEpgTimeSelect() {
        return Configuration.getInstance().getEpgTimeSelect
    }

    @TraceLog
    def getEpgProvider() {
        return Configuration.getInstance().getEpgProvider
    }

    @TraceLog
    def getDbInformation() {
        return Configuration.getInstance().getDbInformation
    }

    @TraceLog
    def pingHost(VDR vdr) {
        return Configuration.getInstance().pingHost(vdr)
    }

    @TraceLog
    def void addJob(Jobs job) {
        Configuration.getInstance().addJob(job)
    }

    @TraceLog
    def void deleteJob(Jobs job) {
        Configuration.getInstance().deleteJob(job)
    }

    @TraceLog
    def void changeJob(Jobs job) {
        Configuration.getInstance().changeJob(job)
    }

    @TraceLog
    def toggleJob(Jobs job) {
        Configuration.getInstance().toggleJob(job)
    }

    @TraceLog
    def showScraperImages() {
        Configuration.getInstance().isShowScraperImages()
    }

    @TraceLog
    def getDefaultZoneId() {
        return Configuration.getInstance().getDefaultZoneId()
    }

    // @TraceLog // -- do not work and i don't understand why not
    def getScraperPath() {
        Configuration.getInstance().scraperPath
    }
}
