package vdr.jonglisto.delegate

import java.io.Serializable
import java.util.List
import java.util.Map
import java.util.Optional
import java.util.Set
import javax.enterprise.context.ApplicationScoped
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.Recording
import vdr.jonglisto.model.Timer
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.xtend.annotation.Log
import vdr.jonglisto.xtend.annotation.TraceLog

@ApplicationScoped
@Log("jonglisto.delegate.svdrp")
class Svdrp implements Serializable {
    public final static long serialVersionUID = 1L;

    @TraceLog
    def refreshChannelCache() {
        SvdrpClient.getInstance.refreshChannelCache
    }

    def refreshEpgCache() {
        SvdrpClient.getInstance.refreshEpgCache
    }

    @TraceLog
    def pingHost(VDR vdr) {
        SvdrpClient.getInstance.pingHost(vdr)
    }

    @TraceLog
    def getChannels() {
        SvdrpClient.getInstance.getChannels()
    }

    @TraceLog
    def getChannel(String channelId) {
        SvdrpClient.getInstance.getChannel(channelId)
    }

    @TraceLog
    def getEpg() {
        SvdrpClient.getInstance.getEpg()
    }

    @TraceLog
    def getTimer(VDR vdr) {
        SvdrpClient.getInstance.getTimer(vdr)
    }

    @TraceLog
    def getRecordings(VDR vdr) {
        SvdrpClient.getInstance.getRecordings(vdr)
    }

    @TraceLog
    def getDeletedRecordings(VDR vdr) {
        SvdrpClient.getInstance.getDeletedRecordings(vdr)
    }

    @TraceLog
    def deleteRecordings(VDR vdr, Set<Long> recordings) {
        SvdrpClient.getInstance.deleteRecordings(vdr, recordings)
    }

    @TraceLog
    def Recording getRecordingEpg(VDR vdr, Recording rec) {
        SvdrpClient.getInstance.getRecordingEpg(vdr, rec)
    }

    @TraceLog
    def renameRecordings(VDR vdr, Map<Long, String> recordings) {
        SvdrpClient.getInstance.renameRecordings(vdr, recordings)
    }

    @TraceLog
    def void undeleteRecording(VDR vdr, Recording recording) {
        SvdrpClient.getInstance.undeleteRecording(vdr, recording)
    }

    @TraceLog
    def void switchChannel(VDR vdr, String channelId) {
        SvdrpClient.getInstance.switchChannel(vdr, channelId)
    }

    @TraceLog
    def void updateTimer(VDR vdr, Timer timer) {
        SvdrpClient.getInstance.updateTimer(vdr, timer)
    }

    @TraceLog
    def getStat(VDR vdr) {
        SvdrpClient.getInstance.getStat(vdr)
    }

    @TraceLog
    def getEpgsearchSearchTimerList(VDR vdr) {
        SvdrpClient.getInstance.getEpgsearchSearchTimerList(vdr)
    }

    @TraceLog
    def Pair<VDR, EpgsearchSearchTimer> searchEpgsearchSearchtimer(String id, String timerName) {
        SvdrpClient.getInstance.searchEpgsearchSearchtimer(id, timerName)
    }

    @TraceLog
    def getEpgsearchSearchBlacklist(VDR vdr) {
        SvdrpClient.getInstance.getEpgsearchSearchBlacklist(vdr)
    }

    @TraceLog
    def getEpgsearchCategories(VDR vdr) {
        SvdrpClient.getInstance.getEpgsearchCategories(vdr)
    }

    @TraceLog
    def getEpgsearchChannelGroups(VDR vdr) {
        SvdrpClient.getInstance.getEpgsearchChannelGroups(vdr)
    }

    @TraceLog
    def saveEpgsearchTimer(VDR vdr, EpgsearchSearchTimer timer) {
        SvdrpClient.getInstance.saveEpgsearchTimer(vdr, timer)
    }

    @TraceLog
    def hitk(VDR vdr, String key) {
        SvdrpClient.getInstance.hitk(vdr, key)
    }

    @TraceLog
    def getOsd(VDR vdr) {
        SvdrpClient.getInstance.getOsd(vdr)
    }

    @TraceLog
    def processCommand(VDR vdr, Optional<String> command) {
        SvdrpClient.getInstance.processCommand(vdr, command)
    }

    @TraceLog
    def processCommand(VDR vdr, String command) {
        SvdrpClient.getInstance.processCommand(vdr, command)
    }

    @TraceLog
    def isPluginAvailable(String vdrName, String pluginName) {
        SvdrpClient.getInstance.isPluginAvailable(vdrName, pluginName)
    }

    @TraceLog
    def isPluginAvailable(VDR vdr, String pluginName) {
        SvdrpClient.getInstance.isPluginAvailable(vdr, pluginName)
    }

    @TraceLog
    def void deleteTimer(VDR vdr, Timer timer) {
        SvdrpClient.getInstance.deleteTimer(vdr, timer)
    }

    @TraceLog
    def playRecording(VDR vdr, Recording recording) {
        SvdrpClient.getInstance.playRecording(vdr, recording)
    }

    @TraceLog
    def void saveEpgData(VDR vdr, Epg epg, String text) {
        SvdrpClient.getInstance.saveEpgData(vdr, epg, text)
    }

    @TraceLog
    def getScraperData(VDR vdr, Epg epg, long recordingId) {
        SvdrpClient.instance.getScraperData(vdr, epg, recordingId);
    }

    @TraceLog
    def writeChannelsConf(VDR vdr, List<Channel> channels) {
        SvdrpClient.instance.writeChannelsConf(vdr, channels)
    }

    @TraceLog
    def void copyEpg(String source, String dest) {
        SvdrpClient.instance.copyEpg(source, dest);
    }

    @TraceLog
    def void copyChannels(String source, String dest) {
        SvdrpClient.instance.copyChannels(source, dest)
    }
}
