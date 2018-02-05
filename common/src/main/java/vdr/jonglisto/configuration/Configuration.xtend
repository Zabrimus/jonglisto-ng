package vdr.jonglisto.configuration

import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.Optional
import java.util.regex.Pattern
import javax.xml.bind.JAXBContext
import javax.xml.bind.Marshaller
import javax.xml.bind.Unmarshaller
import org.knowm.sundial.SundialJobScheduler
import vdr.jonglisto.configuration.jaxb.config.Jonglisto
import vdr.jonglisto.configuration.jaxb.config.Jonglisto.Scraper.ImagePath
import vdr.jonglisto.configuration.jaxb.config.ObjectFactory
import vdr.jonglisto.configuration.jaxb.favourite.Favourites
import vdr.jonglisto.configuration.jaxb.jcron.Jcron
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs
import vdr.jonglisto.configuration.jaxb.remote.Remote
import vdr.jonglisto.model.EpgCustomColumn
import vdr.jonglisto.model.EpgProvider
import vdr.jonglisto.model.EpgProvider.Provider
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.ClasspathFileReader
import vdr.jonglisto.util.Utils
import vdr.jonglisto.xtend.annotation.Log

import static extension org.apache.commons.lang3.StringUtils.*

@Log
class Configuration {
    private static String configurationFile = "/etc/jonglisto/jonglisto-ng.xml"
    private static String remoteFile = "/etc/jonglisto/remote.xml"

    private static String EPG_VDR = "#EPG#"
    private static String CHANNEL_VDR = "#CHANNEL#"

    private static Map<String, VDR> vdrs = new HashMap<String, VDR>
    private static List<String> orderedVdr = new ArrayList<String>
    private static List<EpgProvider> epgProvider
    private static List<String> epgTimeSelect

    private static Pattern epgSeriesSeason
    private static int epgSeriesSeasonGroup

    private static Pattern epgSeriesPart
    private static int epgSeriesPartGroup

    private static Pattern epgSeriesParts
    private static int epgSeriesPartsGroup

    private static Pattern epgCategory
    private static int epgCategoryGroup

    private static Pattern epgGenre
    private static int epgGenreGroup

    private static List<String> defaultSvdrp
    private static List<EpgCustomColumn> epgCustom = new ArrayList<EpgCustomColumn>

    private static String dbUsername
    private static String dbPassword
    private static String dbDatabase
    private static String dbHost
    private static int dbPort

    private static Remote remoteConfig
    private static Favourites favouriteConfig
    private static Jcron jcronConfig

    private static String customDirectory

    private static boolean showScraperImage

    private static List<ImagePath> scraperPath

    private static Configuration instance = new Configuration

    private static Unmarshaller unmarshaller
    private static Marshaller marshaller

    private new() {
        var configObjectFactory = new ObjectFactory
        var remoteObjectFactory = new vdr.jonglisto.configuration.jaxb.remote.ObjectFactory
        var favouriteObjectFactory = new vdr.jonglisto.configuration.jaxb.favourite.ObjectFactory
        var jcronObjectFactory = new vdr.jonglisto.configuration.jaxb.jcron.ObjectFactory
        var scraperObjectFactory = new vdr.jonglisto.configuration.jaxb.scraper.ObjectFactory

        val jc = JAXBContext.newInstance(configObjectFactory.class, remoteObjectFactory.class, favouriteObjectFactory.class, jcronObjectFactory.class, scraperObjectFactory.class);

        unmarshaller = jc.createUnmarshaller()
        marshaller = jc.createMarshaller()

        val xmlFile = new File(configurationFile)
        val remoteFile = new File(remoteFile)

        val config = unmarshaller.unmarshal(xmlFile) as Jonglisto
        remoteConfig = unmarshaller.unmarshal(remoteFile) as Remote

        registerVdrs(config)
        registerEpgTimeSelect(config)
        registerEpgInformation(config)
        registerDbInformation(config)

        defaultSvdrp = config.svdrpCommandList?.command
        customDirectory = config.directory?.dir

        try {
            favouriteConfig = unmarshaller.unmarshal(new File(customDirectory + File.separator + "favourites.xml")) as Favourites
        } catch (Exception e) {
            favouriteConfig = new Favourites
        }

        try {
            jcronConfig = unmarshaller.unmarshal(new File(customDirectory + File.separator + "jcron.xml")) as Jcron
        } catch (Exception e) {
            jcronConfig = new Jcron
        }

        showScraperImage = (config.scraper !== null) && config.scraper.images

        if (config.scraper !== null && config.scraper.imagePath !== null) {
            scraperPath = config.scraper.imagePath
        }

        SundialJobScheduler.startScheduler
        registerSchedules

        loadEpgProvider
    }

    public def getCustomDirectory() {
        return customDirectory
    }

    public def getFavourites() {
        return favouriteConfig
    }

    public def void saveFavourites() {
        val out = new File(customDirectory + File.separator + "favourites.xml")
        marshaller.marshal(favouriteConfig, out)
    }

    public def getJcron() {
        return jcronConfig
    }

    public def saveJcron() {
        val out = new File(customDirectory + File.separator + "jcron.xml")
        marshaller.marshal(jcronConfig, out)
    }

    public def isDatabaseConfigured() {
        return dbUsername.isNotEmpty && //
                dbPassword.isNotEmpty && //
                dbDatabase.isNotEmpty && //
                dbHost.isNotEmpty && //
                dbPort > 0
    }

    public def getRemoteConfig() {
        return remoteConfig
    }

    public def getEpgSeriesSeason() {
        return epgSeriesSeason -> epgSeriesSeasonGroup
    }

    public def getEpgSeriesPart() {
        return epgSeriesPart -> epgSeriesPartGroup
    }

    public def getEpgSeriesParts() {
        return epgSeriesParts -> epgSeriesPartsGroup
    }

    public def getEpgCategory() {
        return epgCategory -> epgCategoryGroup
    }

    public def getEpgGenre() {
        return epgGenre -> epgGenreGroup
    }

    public def getDefaultSvdrpCommand() {
        return defaultSvdrp
    }

    public def getEpgCustom() {
        return epgCustom
    }

    public def getVdr(String name) {
        return vdrs.get(name)
    }

    public def getEpgVdr() {
        return vdrs.get(EPG_VDR)
    }

    public def getChannelVdr() {
        return vdrs.get(CHANNEL_VDR)
    }

    public def getVdrNames() {
        return orderedVdr
    }

    public def findVdr(String ip, int port) {
        if (ip.isNotEmpty) {
            return vdrs.values.stream.filter(v | v.ip == ip && v.port == port).findFirst
        } else {
            return Optional.empty
        }
    }

    public def getEpgTimeSelect() {
        return epgTimeSelect
    }

    public def getEpgProvider() {
        return epgProvider
    }

    public def getDbInformation() {
        return #{'username' -> dbUsername ,'password' -> dbPassword, 'host' -> dbHost, 'port' -> dbPort, 'database' -> dbDatabase}
    }

    public def pingHost(VDR vdr) {
        val command = #["ping", "-c", "1", vdr.ip]

        try {
            val processBuilder = new ProcessBuilder(command);
            val process = processBuilder.start();
            val standardOutput = new BufferedReader(new InputStreamReader(process.getInputStream()));

            var String outputLine;

            while ((outputLine = standardOutput.readLine()) !== null) {
                if (outputLine.toLowerCase().contains("destination host unreachable")) {
                    return false;
                }
            }
        } catch (Exception e) {
            return false;
        }

        return true;
    }

    public def void addJob(Jobs job) {
        jcron.jobs.add(job)
        saveJcron

        if (job.active) {
            addJobScheduler(job)
        }
    }

    public def void deleteJob(Jobs job) {
        val old = jcron.jobs.findFirst[j | j.id == job.id]
        jcron.jobs.remove(old)
        saveJcron

        removeJobScheduler(job)
    }

    public def void changeJob(Jobs job) {
        val old = jcron.jobs.findFirst[j | j.id == job.id]
        jcron.jobs.remove(old)
        jcron.jobs.add(job)
        saveJcron

        removeJobScheduler(old)
        addJobScheduler(job)
    }

    public def void toggleJob(Jobs job) {
        job.active = !job.active
        saveJcron

        if (job.active) {
            addJobScheduler(job)
        } else {
            removeJobScheduler(job)
        }
    }

    public def isShowScraperImages() {
        return showScraperImage
    }

    public def getScraperPath() {
        return scraperPath
    }

    public def getMarshaller() {
        return marshaller
    }

    public def getUnmarshaller() {
        return unmarshaller
    }

    public static def getInstance() {
        return instance
    }

    private def loadProviderReplacement() {
        val result = new ArrayList<Pair<String, String>>
        val replace = ClasspathFileReader.readStringList("/providerids_replacements.txt")

        replace.forEach[r |
            val sp = r.split("\\|")
            if (sp.length > 0) {
                val rep = Utils.normalizeChannelName(sp.get(0).trim)
                for (var i = 1; i < sp.length; i++) {
                    val pair = new Pair(sp.get(i).trim, rep)

                    if (!result.contains(pair)) {
                        result.add(pair)
                    }
                }
            }
        ]

        return result
    }

    private def loadEpgProvider() {
        // load replace ids (EPG provider channel to another normalized name. e.g. because of channel renaming)
        val replaceIds = loadProviderReplacement

        // load provider ids
        epgProvider = new ArrayList<EpgProvider>
        val list = ClasspathFileReader.readStringList("/providerids.txt")

        list.filter[p | p !== null && p.length > 0].forEach[p | {
            val sp = p.split("\\|")
            val ep = new EpgProvider(Provider.valueOf(sp.get(0).trim), sp.get(1).trim, sp.get(2).trim, sp.get(3).trim)

            // add original EpgProvider
            epgProvider.add(ep)

            // exists there a replace id?
            replaceIds.filter[rep | rep.key == ep.name].forEach[r |
                // add additional EpgProvider
                epgProvider.add(new EpgProvider(ep.provider, ep.epgid, r.key, r.value, false))
            ]
        }]
    }

    private def registerVdrs(Jonglisto cfg) {
        // read all VDR instances
        cfg.configuredVdr.instance.stream.forEach(v | {
            orderedVdr.add(v.displayName)

            val port = if (v.port == 0) null else Integer.valueOf(v.port)

            vdrs.put(v.displayName, new VDR(v.displayName, v.host, port, v.name))

            if (v.name == cfg.epg.ref) {
                vdrs.put(EPG_VDR, new VDR(EPG_VDR, v.host, port, v.name))
            }

            if (v.name == cfg.channel.ref) {
                vdrs.put(CHANNEL_VDR, new VDR(CHANNEL_VDR, v.host, port, v.name))
            }
        })
    }

    private def registerEpgTimeSelect(Jonglisto cfg) {
        epgTimeSelect = cfg.epgTimeList.value
    }

    private def registerEpgInformation(Jonglisto cfg) {
        epgSeriesSeason = cfg.epgColumns?.series?.season?.pattern.compilePattern

        try {
            epgSeriesSeasonGroup = cfg.epgColumns.series.season.group
        } catch (NullPointerException e) {
            epgSeriesSeasonGroup = 0
        }

        epgSeriesPart = cfg.epgColumns?.series?.part?.pattern.compilePattern

        try {
            epgSeriesPartGroup = cfg.epgColumns.series.part.group
        } catch (NullPointerException e) {
            epgSeriesPartGroup = 0
        }

        epgSeriesParts = cfg.epgColumns?.series?.parts?.pattern.compilePattern

        try {
            epgSeriesPartsGroup = cfg.epgColumns.series.parts.group
        } catch (NullPointerException e) {
            epgSeriesPartsGroup = 0
        }

        epgGenre = cfg.epgColumns?.genre?.pattern.compilePattern

        try {
            epgGenreGroup = cfg.epgColumns.genre.group
        } catch (NullPointerException e) {
            epgGenreGroup = 0
        }

        epgCategory = cfg.epgColumns?.category?.pattern.compilePattern

        try {
            epgCategoryGroup = cfg.epgColumns.category.group
        } catch (NullPointerException e) {
            epgCategoryGroup = 0
        }

        for (custom : cfg.epgColumns?.customPattern?.custom) {
            val p = custom.pattern.compilePattern
            if (p !== null) {
                epgCustom.add(new EpgCustomColumn(custom.header, p, custom.output))
            }
        }
    }

    private def registerDbInformation(Jonglisto cfg) {
        val mc = cfg.epg2Vdr

        if (mc !== null) {
            dbUsername = mc.username
            dbPassword = mc.password
            dbDatabase = mc.database
            dbHost = mc.host
            dbPort = mc.port
        }
    }

    private def registerSchedules() {
        // start all jobs after server restart
        jcron.jobs.forEach[s | addJobScheduler(s)]
    }

    private def compilePattern(String str) {
        if (str === null) {
            return null
        }

        try {
            return Pattern.compile(str)
        } catch (Exception e) {
            log.warning("Regex Pattern '" + str + "' is invalid and will be ignored")
            return null
        }
    }

    private def void addJobScheduler(Jobs job) {
        if (!job.active) {
            // do nothing
            return
        }

        if (job.action.vdrAction !== null) {
            val Map<String, Object> paramMap = new HashMap<String, Object>
            paramMap.put("VDR_NAME", job.action.vdrAction.vdr)

            switch(job.action.vdrAction.type) {
                case "switchChannel": {
                    paramMap.put("COMMAND", "CHAN " + job.action.vdrAction.parameter)
                }

                case "osdMessage": {
                    paramMap.put("COMMAND", "MESG " + job.action.vdrAction.parameter)
                }

                case "svdrp",
                case "osdserverMessage": {
                    paramMap.put("COMMAND", job.action.vdrAction.parameter)
                }
            }

            // add the job only, if the next execution time is in the future
            if (Utils.nextExecutionInMillis(System.currentTimeMillis, job.time) != 0) {
                val jobName = job.user + ":" + job.id

                switch(job.action.vdrAction.type) {
                    case "switchChannel",
                    case "osdMessage",
                    case "svdrp": {
                        SundialJobScheduler.addJob(jobName, "vdr.jonglisto.svdrp.client.jobs.SvdrpCommandJob", paramMap, false);
                    }

                    case "osdserverMessage": {
                        SundialJobScheduler.addJob(jobName, "vdr.jonglisto.osdserver.jobs.OsdServerMessageJob", paramMap, false);
                    }
                }

                SundialJobScheduler.addCronTrigger(jobName + ".trigger", jobName, job.time);
            } else {
                job.active = false
            }
        } else if (job.action.shellAction !== null) {
            // TODO: implement addJobScheduler for ShellAction
        }
    }

    private def void removeJobScheduler(Jobs job) {
        SundialJobScheduler.stopJob(job.user + ":" + job.id);
        SundialJobScheduler.removeJob(job.user + ":" + job.id);
    }
}
