package vdr.jonglisto.svdrp.client

import com.google.common.cache.CacheBuilder
import com.google.common.cache.CacheLoader
import com.google.common.cache.LoadingCache
import com.google.common.cache.RemovalListener
import com.google.common.cache.RemovalNotification
import java.util.ArrayList
import java.util.Collections
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.Optional
import java.util.concurrent.TimeUnit
import java.util.logging.Level
import java.util.stream.Collectors
import vdr.jonglisto.configuration.Configuration
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

@Log
class SvdrpClient {
    private static var SvdrpClient instance

    private LoadingCache<VDR, Connection> connections
    private LoadingCache<String, List<? extends BaseData>> longCache

    static val Map<String, Channel> channelMap = new HashMap<String, Channel>()

    private new() {
        log.fine("Init SvdrpClient...")

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
            override def Connection load(VDR key) {
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
            override def List<? extends BaseData> load(String key) {
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

    def doOneMinuteEvent() {
        cleanupCache
    }

    def pingHost(VDR vdr) {
        try {
            vdr.command("PING", 250)
            return true
        } catch (Exception e) {
            return false
        }
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

    def getChannels() {
        return longCache.get("CHANNEL") as List<Channel>
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

    def getEpg() {
        return longCache.get("EPG") as List<Epg>
    }

    def getTimer(VDR vdr) {
        // do not cache timers, because they are volatile
        return readTimer(vdr)
    }

    def getRecordings(VDR vdr) {
        // do not cache recordings, because they are volatile
        return readRecordings(vdr)
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

    def void batchRenameRecording(VDR vdr, HashMap<Long, String> map) {
        map.keySet.stream.forEach(recId | {
            vdr.command("MOVR " + recId + " " + map.get(recId), 250)
        })
    }

    def void deleteRecording(VDR vdr, Recording recording) {
        vdr.command("DELR " + recording.id, 250)
    }

    def void switchChannel(VDR vdr, String channelId) {
        vdr.command("CHAN " + channelId, 250)
    }

    def void updateTimer(VDR vdr, Timer timer) {
        vdr.command("UPDT " + timer.toVdrString, 250)
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
            log.log(Level.FINE, "Exception", e);

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
            log.log(Level.FINE, "Exception", e);

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
        vdr.command("DELT " + timer.id, 250)
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

    private def List<Recording> readRecordings(VDR vdr) {
        return vdr.command("LSTR", 250, [ Parser.parseRecording(it.lines) ], [ Collections.emptyList ])
    }

    private def List<Channel> readChannels(VDR vdr) {
        return Parser.parseChannel(vdr.command("LSTC :ids :groups", 250).lines)
    }

    private def List<Epg> readEpg(VDR vdr) {
        val response = vdr.command("LSTE", 215)
        response.lines.remove(response.lines.size() - 1);

        return Parser.parseEpg(response.lines)
    }

    private def List<Timer> readTimer(VDR vdr) {
        return vdr.command("LSTT id", 250, [ Parser.parseTimer(it.lines) ], [ Collections.emptyList ])
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

        val resp = connection.send(command)
        if (resp.code != desiredCode && desiredCode != -1) {
            throw new ExecutionFailedException("Code: " + resp.code)
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
