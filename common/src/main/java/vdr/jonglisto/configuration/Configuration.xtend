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
import vdr.jonglisto.configuration.jaxb.Jonglisto
import vdr.jonglisto.configuration.jaxb.ObjectFactory
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

    private static Configuration instance = new Configuration

    private new() {
        val jc = JAXBContext.newInstance(ObjectFactory);
        val unmarshaller = jc.createUnmarshaller();
        val xmlFile = new File(configurationFile);

        // val config = (unmarshaller.unmarshal(xmlFile) as JAXBElement<JonglistoType>).value
        val config = unmarshaller.unmarshal(xmlFile) as Jonglisto

        registerVdrs(config)
        registerEpgTimeSelect(config)
        registerEpgInformation(config)
        registerDbInformation(config)

        defaultSvdrp = config.svdrpCommandList?.command

        loadEpgProvider
    }

    public def isDatabaseConfigured() {
        return dbUsername.isNotEmpty && //
                dbPassword.isNotEmpty && //
                dbDatabase.isNotEmpty && //
                dbHost.isNotEmpty && //
                dbPort > 0
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

            while ((outputLine = standardOutput.readLine()) != null) {
                if (outputLine.toLowerCase().contains("destination host unreachable")) {
                    return false;
                }
            }
        } catch (Exception e) {
            return false;
        }

        return true;
    }

    public static def get() {
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

            vdrs.put(v.displayName, new VDR(v.displayName, v.host, port))

            if (v.name == cfg.epg.ref) {
                vdrs.put(EPG_VDR, new VDR(EPG_VDR, v.host, port))
            }

            if (v.name == cfg.channel.ref) {
                vdrs.put(CHANNEL_VDR, new VDR(CHANNEL_VDR, v.host, port))
            }
        })
    }

    private def registerEpgTimeSelect(Jonglisto cfg) {
        epgTimeSelect = cfg.epgTimeList.value
    }

    private def registerEpgInformation(Jonglisto cfg) {
        epgSeriesSeason = cfg.epgColumns?.series?.season?.pattern.compilePattern
        epgSeriesSeasonGroup = cfg.epgColumns?.series?.season?.group

        epgSeriesPart = cfg.epgColumns?.series?.part?.pattern.compilePattern
        epgSeriesPartGroup = cfg.epgColumns?.series?.part?.group

        epgSeriesParts = cfg.epgColumns?.series?.parts?.pattern.compilePattern
        epgSeriesPartsGroup = cfg.epgColumns?.series?.parts?.group

        epgGenre = cfg.epgColumns?.genre?.pattern.compilePattern
        epgGenreGroup = cfg.epgColumns?.genre?.group

        epgCategory = cfg.epgColumns?.category?.pattern.compilePattern
        epgCategoryGroup = cfg.epgColumns?.category?.group

        for (custom : cfg.epgColumns?.customPattern?.custom) {
            val p = custom.pattern.compilePattern
            if (p !== null) {
                epgCustom.add(new EpgCustomColumn(custom.header, p, custom.output))
            }
        }
    }

    private def registerDbInformation(Jonglisto cfg) {
        dbUsername = cfg.epg2Vdr?.username
        dbPassword = cfg.epg2Vdr?.password
        dbDatabase = cfg.epg2Vdr?.database
        dbHost = cfg.epg2Vdr?.host
        dbPort = cfg.epg2Vdr?.port
    }

    private def compilePattern(String str) {
        if (str === null) {
            return null
        }

        try {
            return Pattern.compile(str)
        } catch (Exception e) {
            log.error("Regex Pattern '" + str + "' is invalid and will be ignored")
            return null
        }
    }
}
