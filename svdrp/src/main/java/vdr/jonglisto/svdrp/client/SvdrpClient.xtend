package vdr.jonglisto.svdrp.client

import com.google.common.cache.CacheBuilder
import com.google.common.cache.CacheLoader
import com.google.common.cache.LoadingCache
import com.google.common.cache.RemovalListener
import com.google.common.cache.RemovalNotification
import java.io.StringReader
import java.util.ArrayList
import java.util.Collections
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.Optional
import java.util.Set
import java.util.concurrent.TimeUnit
import java.util.stream.Collectors
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.configuration.jaxb.scraper.Scraper
import vdr.jonglisto.model.BaseData
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.EpgsearchCategory
import vdr.jonglisto.model.EpgsearchChannelGroup
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.EpgsearchSearchTimer.Field
import vdr.jonglisto.model.Recording
import vdr.jonglisto.model.Timer
import vdr.jonglisto.model.VDR
import vdr.jonglisto.model.VdrPlugin
import vdr.jonglisto.xtend.annotation.Log

import static extension org.apache.commons.lang3.StringUtils.*
import java.io.StringWriter
import java.util.concurrent.ExecutionException

@Log("jonglisto.svdrp.client")
class SvdrpClient {
    static var SvdrpClient instance

    LoadingCache<VDR, Connection> connections
    LoadingCache<String, List<? extends BaseData>> longCache

    static val Map<String, Channel> channelMap = new HashMap<String, Channel>()

    private new() {
        log.debug("Init SvdrpClient...")

        // init caches
        connections = CacheBuilder.newBuilder() //
        .maximumSize(10) //
        .expireAfterAccess(30, TimeUnit.SECONDS) //
        .removalListener(new RemovalListener<VDR, Connection>() {
            override onRemoval(RemovalNotification<VDR, Connection> notification) {
                log.info("Close connection to " + notification.key.host + ":" + notification.key.port)
                notification.value.close
            }
        }) //
        .build(new CacheLoader<VDR, Connection>() {
            override Connection load(VDR key) {
                log.info("Create connection to " + key.host + ":" + key.port)
                var Connection con = new Connection(key.host, key.port, key.readTimeout, key.connectTimeout)
                con.connect
                return con;
            }
        })

        longCache = CacheBuilder.newBuilder() //
        .maximumSize(10) //
        .expireAfterWrite(6, TimeUnit.HOURS) //
        .build(new CacheLoader<String, List<? extends BaseData>>() {
            override List<? extends BaseData> load(String key) {
                if (key == "EPG") {
                    return readEpg(Configuration.getInstance().epgVdr)
                } else if (key == "CHANNEL") {
                    val result = readChannels(Configuration.getInstance().channelVdr)

                    channelMap.clear
                    result.stream.forEach[s|channelMap.put(s.id, s)]

                    return result
                }

                return null
            }
        });
    }

    static def getInstance() {
        if (instance === null) {
            synchronized (SvdrpClient) {
                if (instance === null) {
                    instance = new SvdrpClient
                }
            }
        }

        return instance
    }

    def cleanupCache() {
        connections.cleanUp
        longCache.cleanUp
    }

    def doShutdown() {
        log.info("Shutdown SVDRP client...")

        connections.invalidateAll
        longCache.invalidateAll
        cleanupCache
    }

    def void invalidateConnection(Connection con) {
        connections.invalidate(con)
    }

    def doOneMinuteEvent() {
        cleanupCache
    }

    def pingHost(VDR vdr) {
        try {
            vdr.command("DUMMY", 500)
            return true
        } catch (Exception e) {
            return false
        }
    }

    def getVdrVersion(VDR vdr) {
        var Connection connection

        try {
            connection = connections.get(vdr)
        } catch (Exception e) {
            val message = "Connection to " + vdr + " refused."
            log.info(message)
            throw new ConnectionException(message)
        }

        return connection.version
    }

    def getPlugins(VDR vdr) {
        try {
            val result = new ArrayList<VdrPlugin>

            val response = vdr.command("PLUG", 214).lines

            // remove first and last line
            response.remove(0)
            response.remove(response.size - 1)

            for (s : response) {
                val r = Parser.parsePlugin(s)
                if (r !== null) {
                    result.add(Parser.parsePlugin(s))
                }
            }

            return result
        } catch (Exception e) {
            return null
        }
    }

    @SuppressWarnings("unchecked")
    def getChannels() {
        try {
            return longCache.get("CHANNEL") as List<Channel>
        } catch (ExecutionException exc) {
            throw new RuntimeException("error in getChannels", exc)
        }
    }

    def getChannel(String channelId) {
        var result = channelMap.get(channelId)

        if (result === null) {
            // load channels, if not already loaded
            channels
            result = channelMap.get(channelId)
        }

        return result
    }

    @SuppressWarnings("unchecked")
    def getEpg() {
        try {
            return longCache.get("EPG") as List<Epg>
        } catch (ExecutionException exc) {
            throw new RuntimeException("error in getEpg", exc)
        }
    }

    def getTimer(VDR vdr) {
        // do not cache timers, because they are volatile
        return readTimer(vdr)
    }

    def getRecordings(VDR vdr) {
        // do not cache recordings, because they are volatile
        return readRecordings(vdr)
    }

    def getDeletedRecordings(VDR vdr) {
        // do not cache recordings, because they are volatile
        return readDeletedRecordings(vdr)
    }

    def Recording getRecordingEpg(VDR vdr, Recording rec) {
        val response = vdr.command("LSTR " + rec.id, 215)

        response.lines.remove(response.lines.size() - 1)
        response.lines.add("e") // simulate end of EPG

        rec.epg = Parser.parseEpg(response.lines).get(0)

        return rec
    }

    def renameRecording(VDR vdr, long id, String newName) {
        return vdr.command("MOVR " + id + " " + newName, 250)
    }

    def renameRecordings(VDR vdr, Map<Long, String> recordings) {
        if (isJonglistoPluginCommandAllowed(vdr, "MOVR")) {
            val writer = new StringWriter();
            recordings.keySet().stream.sorted.forEach(recId | {
                writer.append("/").append(recId.toString()).append(" ").append(recordings.get(recId));
            })
            vdr.command("PLUG jonglisto MOVR " + writer.toString(), 900)
        } else {
            recordings.keySet.stream.forEach(recId | {
                vdr.command("MOVR " + recId + " " + recordings.get(recId), 250)
            })
        }
    }

    def void deleteRecordings(VDR vdr, Set<Long> recordings) {
        if (isJonglistoPluginCommandAllowed(vdr, "DELR")) {
            val cmd = recordings.stream.map(s|String.valueOf(s)).collect(Collectors.joining(" "));
            vdr.command("PLUG jonglisto DELR " + cmd, 900)
        } else {
            recordings.stream.forEach(s | vdr.command("DELR " + s, 250) )
        }
    }

    def void undeleteRecording(VDR vdr, Recording recording) {
        if (isJonglistoPluginCommandAllowed(vdr, "UNDR")) {
            vdr.command("PLUG jonglisto UNDR " + recording.id, 900)
        }
    }

    def void switchChannel(VDR vdr, String channelId) {
        vdr.command("CHAN " + channelId, 250)
    }

    def void updateTimer(VDR vdr, Timer timer) {
        if (isJonglistoPluginCommandAllowed(vdr, "UPDT")) {
            vdr.command("PLUG jonglisto UPDT " + timer.toVdrString, 250)
        } else {
            vdr.command("UPDT " + timer.toVdrString, 250)
        }
    }

    def getStat(VDR vdr) {
        val response = vdr.command("STAT disk", 250)
        return Parser.parseStat(response.lines.get(0))
    }

    def getEpgsearchSearchTimerList(VDR vdr) {
        try {
            val timer = new ArrayList<EpgsearchSearchTimer>
            val response = vdr.command("PLUG epgsearch LSTS", 900)
            response.lines.stream.forEach(s | timer.add(Parser.parseEpgsearchList(s)))

            return timer
        } catch (Exception e) {
            // no search timers defined or host down
            return Collections.emptyList
        }
    }

    def Pair<VDR, EpgsearchSearchTimer> searchEpgsearchSearchtimer(String id, String timerName) {
        val vdrList = Configuration.instance.vdrNames

        for (var i = 0; i < vdrList.size; i++) {
            val v = Configuration.instance.getVdr(vdrList.get(i))

            try {
                val res = getEpgsearchSearchTimerList(v).findFirst[f | f.getLongField(Field.id) == Long.valueOf(id) && (f.getField(Field.pattern) == timerName)]

                if (res !== null) {
                    return new Pair(v, res)
                }
            } catch (Exception t) {
                // ignore this one
            }
        }

        return null;
    }

    def getEpgsearchSearchBlacklist(VDR vdr) {
        try {
            val timer = new ArrayList<EpgsearchSearchTimer>
            val response = vdr.command("PLUG epgsearch LSTB", 900)
            response.lines.stream.forEach(s | timer.add(Parser.parseEpgsearchList(s)))

            return timer
        } catch (Exception e) {
            // no search timers defined or host down
            return Collections.emptyList
        }
    }

    def getEpgsearchCategories(VDR vdr) {
        try {
            val result = new ArrayList<EpgsearchCategory>
            val response = vdr.command("PLUG epgsearch LSTE", 900)
            response.lines.stream.forEach(s | result.add(Parser.parseEpgsearchCategory(s)))

            return result
        } catch (Exception e) {
            log.debug("Exception", e);

            // no categories defined or host down
            return Collections.emptyList
        }
    }

    def getEpgsearchChannelGroups(VDR vdr) {
        try {
            val result = new ArrayList<EpgsearchChannelGroup>
            val response = vdr.command("PLUG epgsearch LSTC", 900)

            response.lines.stream.forEach(s | result.add(Parser.parseEpgsearchChannelGroup(s)))

            return result
        } catch (Exception e) {
            log.debug("Exception", e);

            // no channel groups defined or host down
            return Collections.emptyList
        }
    }

    def saveEpgsearchTimer(VDR vdr, EpgsearchSearchTimer timer) {
        // insert or update
        if (timer.getField(Field.id).isNotEmpty) {
            vdr.command("PLUG epgsearch EDIS " + timer.createSvdrpLine, 900)
        } else {
            vdr.command("PLUG epgsearch NEWS " + timer.createSvdrpLine, 900)
        }
    }

    def hitk(VDR vdr, String key) {
        if (vdr !== null) {
            vdr.command("HITK " + key, 250)
        }
    }

    def getOsd(VDR vdr) {
        try {
            val response = vdr.command("PLUG svdrposd LSTO 30", 920)
            return Parser.parseRemoteOsd(response.lines)
        } catch (Exception e) {
            // no open OSD or host down
            return null
        }
    }

    def processCommand(VDR vdr, Optional<String> command) {
        if (command.isPresent) {
            processCommand(vdr, command.get)
        }
    }

    def processCommand(VDR vdr, String command) {
        try {
            return vdr.command(command, -1).lines
        } catch (ConnectionException e) {
            return #["VDR cannot be reached. System/VDR halted?"]
        }
    }

    def isPluginAvailable(String vdrName, String pluginName) {
        val vdr = Configuration.getInstance().getVdr(vdrName)
        return isPluginAvailable(vdr, pluginName)
    }

    def isJonglistoPluginCommandAllowed(VDR vdr, String command) {
        if (!isPluginAvailable(vdr, "jonglisto")) {
            return false
        } else {
            return Configuration.instance.isPluginCommandAllowed(vdr.instance, command)
        }
    }

    def isPluginAvailable(VDR vdr, String pluginName) {
        if (vdr === null) {
            return false
        }

        if (!pingHost(vdr) || !Configuration.getInstance().pingHost(vdr)) {
            return false
        }

        val p = getPlugins(vdr).stream.filter(s | s.plugin.toLowerCase == pluginName.toLowerCase).findFirst
        if (p.isPresent) {
            return true
        }

        return false
    }

    def void deleteTimer(VDR vdr, Timer timer) {
        if (isJonglistoPluginCommandAllowed(vdr, "DELT")) {
            vdr.command("PLUG jonglisto DELT " + timer.id, 250)

            // give VDR some time to poll timers
            if (timer.isRemote) {
                try {
                    Thread.sleep(2000)
                } catch (InterruptedException exc) {
                    // ignore
                };
            }
        } else {
            vdr.command("DELT " + timer.id, 250)
        }
    }

    def recordViaOsdserver(VDR vdr, String channelId, Epg epg) {
        if (isJonglistoPluginCommandAllowed(vdr, "NERT")) {
            vdr.command("PLUG jonglisto NERT " + epg.channelId + " " + epg.startTime, 900)
        } else {
            val timer = new Timer();
            timer.channelId = epg.channelId
            timer.lifetime = 50
            timer.priority = 50
            timer.startEpoch = epg.startTime - 10 * 60
            timer.duration = epg.duration + 20 * 60
            timer.enabled = true

            updateTimer(vdr, timer)
        }
    }

    def playRecording(VDR vdr, Recording recording) {
        vdr.command("PLAY " + recording.id, 250)
    }

    def void saveEpgData(VDR vdr, Epg epg, String text) {
        val convertedText = text.replaceAll("\\n", "\\|")
        val commandList = epg.rawData.stream.collect(Collectors.toList)
        commandList.add("D " + convertedText)
        commandList.add("e")
        commandList.add("c")
        commandList.add(".")

        var Connection tmpConnection

        try {
            tmpConnection = connections.get(vdr)
        } catch (Exception e) {
            log.info("Connection to " + vdr + " refused.")
            throw new RuntimeException("saving epg data failed")
        }

        val connection = tmpConnection

        var response = connection.send("PUTE")

        if (response.code != 354) {
            throw new RuntimeException("Code != 354")
        }

        response = connection.sendBatch(commandList)

        if (response.code != 250) {
            throw new RuntimeException("Code != 250")
        }
    }

    def getScraperData(VDR vdr, Epg epg, long recordingId) {
        val epgVdr = Configuration.instance.epgVdr
        val usedVdr = vdr ?: epgVdr

        if (isJonglistoPluginCommandAllowed(usedVdr, "EINF") || isJonglistoPluginCommandAllowed(usedVdr, "RINF")) {
            try {
                var Response response

                if (recordingId === -1) {
                    if (isJonglistoPluginCommandAllowed(usedVdr, "EINF")) {
                        response = usedVdr.command("PLUG jonglisto EINF " + epg.channelId + " " + epg.eventId, 900)
                    } else {
                        return null
                    }
                } else {
                    if (isJonglistoPluginCommandAllowed(usedVdr, "RINF")) {
                        response = usedVdr.command("PLUG jonglisto RINF " + recordingId, 900)
                    } else {
                        return null;
                    }
                }

                val xml = response.lines.get(0)

                return Configuration.instance.unmarshaller.unmarshal(new StringReader(xml)) as Scraper
            } catch (Exception e) {
                log.trace("Get Scraper data failed.", e)

                // no epg data found
                return null;
            }
        }
    }

    def writeChannelsConf(VDR vdr, List<Channel> channels) {
        if (isJonglistoPluginCommandAllowed(vdr, "REPC")) {
            val parameterList = new ArrayList<String>

            // prepare command line
            channels.forEach[s | {
                var raw = s.raw

                if (s.id !== null) {
                    if (s.name.contains(":")) {
                        val oldc = s.name
                        val newc = s.name.replace(":", "|")
                        raw = raw.replace(oldc, newc)
                    }
                } else {
                    raw = ":" + s.name
                }

                parameterList.add(raw)
            }]

            val parameter = parameterList.stream().collect(Collectors.joining("~"))

            vdr.command("PLUG jonglisto repc " + parameter, 900)
        }
    }

    def void copyEpg(String source, String dest) {
        val sourceVdr = Configuration.getInstance().getVdr(source)
        val destVdr = Configuration.getInstance().getVdr(dest)

        log.info("epg copy: start reading source EPG")

        // Read EPG
        var Response sourceResponse
        try {
            sourceResponse = sourceVdr.command("LSTE", 215)
            sourceResponse.lines.remove(sourceResponse.lines.size() - 1);
        } catch(Exception e) {
            throw new RuntimeException("Connection to " + source + " refused.")
        }

        log.info("epg copy: reading source EPG finished: " + sourceResponse.lines.size)

        var Connection connection

        try {
            connection = connections.get(destVdr)
        } catch (Exception e) {
            throw new RuntimeException("Connection to " + dest + " refused.")
        }

        log.info("epg copy: send PUTE");

        // Write Epg
        var destResponse = connection.send("PUTE")

        if (destResponse.code != 354) {
            throw new RuntimeException("VDR " + dest + " do not accept PUTE command: " + destResponse.lines.get(0))
        }

        log.info("epg copy: start sending epg data to dest");

        destResponse = connection.sendBatchRawEpg(sourceResponse.lines)

        log.info("epg copy: finished sending epg data to dest");

        if (destResponse.code != 250) {
            throw new RuntimeException("Saving EPG date failed: " + destResponse.lines.get(0))
        }
    }

    def void copyChannels(String source, String dest) {
        val sourceVdr = Configuration.getInstance().getVdr(source)
        val destVdr = Configuration.getInstance().getVdr(dest)

        if (!isJonglistoPluginCommandAllowed(destVdr, "REPC")) {
            throw new RuntimeException("vdr-plugin-jonglisto is required in destination VDR")
        }

        log.info("channel copy: start reading source channels")
        var Response sourceResponse
        try {
            sourceResponse = sourceVdr.command("LSTC :groups", 250)
        } catch(Exception e) {
            throw new RuntimeException("Connection to " + source + " refused.")
        }

        log.info("channel copy: start sending channel data to dest");

        var Response destResponse
        try {
            val parameter = sourceResponse.lines.stream() //
                .map(s | s.substring(s.indexOf(" ")+1)) //
                .collect(Collectors.joining("~"))

            destResponse = destVdr.command("PLUG jonglisto repc " + parameter, 900)

            log.info("channel copy: finished sending channel data to dest");
        } catch (Exception e) {
            throw new RuntimeException("Saving channel date failed: " + destResponse.lines.get(0))
        }
    }

    private def List<Recording> readRecordings(VDR vdr) {
        return vdr.command("LSTR", 250, [ Parser.parseRecording(it.lines) ], [ Collections.emptyList ])
    }

    private def List<Recording> readDeletedRecordings(VDR vdr) {
        if (isJonglistoPluginCommandAllowed(vdr, "LSDR")) {
            return vdr.command("PLUG jonglisto LSDR", 900, [ Parser.parseRecording(it.lines) ], [ Collections.emptyList ])
        } else {
            return Collections.emptyList
        }
    }

    private def List<Channel> readChannels(VDR vdr) {
        return Parser.parseChannel(vdr.command("LSTC :groups", 250).lines)
    }

    private def List<Epg> readEpg(VDR vdr) {
        val response = vdr.command("LSTE", 215)
        response.lines.remove(response.lines.size() - 1);

        return Parser.parseEpg(response.lines)
    }

    private def List<Timer> readTimer(VDR vdr) {
        var List<Timer> result

        if (isJonglistoPluginCommandAllowed(vdr, "LSTT")) {
            result = vdr.command("PLUG jonglisto LSTT", 250, [ Parser.parseTimer(it.lines) ], [ Collections.emptyList ])

            result.forEach[s | {
                s.updateSearchTimerInfo
            }]

            // extract and delete remote flag
            return result.stream().map(s | {
                if (s.aux.contains("<remote>0</remote>")) {
                    s.remote = false
                    s.aux = s.aux.replace("<remote>0</remote>", "")
                } else if (s.aux.contains("<remote>1</remote>")) {
                    s.remote = true
                    s.aux = s.aux.replace("<remote>1</remote>", "")
                }

                s
            }).collect(Collectors.toList())
        } else {
            result = vdr.command("LSTT id", 250, [ Parser.parseTimer(it.lines) ], [ Collections.emptyList ])

            result.forEach[s | {
                s.updateSearchTimerInfo
            }]

            return result
        }
    }

    private def command(VDR vdr, String command, int desiredCode) {
        var Connection connection

        try {
            connection = connections.get(vdr)
        } catch (Exception e) {
            val message = "Connection to " + vdr + " refused."
            log.info(message)
            throw new ConnectionException(message)
        }

        log.debug("Command: " + command)

        val resp = connection.send(command)
        if (resp.code != desiredCode && desiredCode != -1) {
            val errorMessage = "Code: " + resp.code + ": " + resp.lines.stream.collect(Collectors.joining("\n"))
            log.info("Command failed:" + command + "\n" + errorMessage)

            throw new ExecutionFailedException(errorMessage)
        }

        return resp
    }

    private def <T> command(VDR vdr, String command, int desiredCode, (Response) => T connectHandler, (Exception) => T errorHandler) {
        try {
            return connectHandler.apply(vdr.command(command, desiredCode))
        } catch (Exception e) {
            return errorHandler.apply(e)
        }
    }
}
