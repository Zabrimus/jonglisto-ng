package vdr.jonglisto.delegate

import java.io.Serializable
import java.util.HashMap
import java.util.Optional
import javax.enterprise.context.ApplicationScoped
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.Recording
import vdr.jonglisto.model.Timer
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient

@ApplicationScoped
class Svdrp implements Serializable {

    def pingHost(VDR vdr) {
        SvdrpClient.getInstance.pingHost(vdr)
    }

    def getPlugins(VDR vdr) {
        SvdrpClient.getInstance.getPlugins(vdr)
    }

    def getChannels() {
        SvdrpClient.getInstance.getChannels()
    }

    def getChannel(String channelId) {
        SvdrpClient.getInstance.getChannel(channelId)
    }

    def getEpg() {
        SvdrpClient.getInstance.getEpg()
    }

    def getTimer(VDR vdr) {
        SvdrpClient.getInstance.getTimer(vdr)
    }

    def getRecordings(VDR vdr) {
        SvdrpClient.getInstance.getRecordings(vdr)
    }

    def Recording getRecordingEpg(VDR vdr, Recording rec) {
        SvdrpClient.getInstance.getRecordingEpg(vdr, rec)
    }

    def renameRecording(VDR vdr, long id, String newName) {
        SvdrpClient.getInstance.renameRecording(vdr, id, newName)
    }

    def void batchRenameRecording(VDR vdr, HashMap<Long, String> map) {
        SvdrpClient.getInstance.batchRenameRecording(vdr, map)
    }

    def void deleteRecording(VDR vdr, Recording recording) {
        SvdrpClient.getInstance.deleteRecording(vdr, recording)
    }

    def void switchChannel(VDR vdr, String channelId) {
        SvdrpClient.getInstance.switchChannel(vdr, channelId)
    }

    def void updateTimer(VDR vdr, Timer timer) {
        SvdrpClient.getInstance.updateTimer(vdr, timer)
    }

    def getStat(VDR vdr) {
        SvdrpClient.getInstance.getStat(vdr)
    }

    def getEpgsearchSearchTimerList(VDR vdr) {
        SvdrpClient.getInstance.getEpgsearchSearchTimerList(vdr)
    }

    def getEpgsearchSearchBlacklist(VDR vdr) {
        SvdrpClient.getInstance.getEpgsearchSearchBlacklist(vdr)
    }

    def getEpgsearchCategories(VDR vdr) {
        SvdrpClient.getInstance.getEpgsearchCategories(vdr)
    }

    def getEpgsearchChannelGroups(VDR vdr) {
        SvdrpClient.getInstance.getEpgsearchChannelGroups(vdr)
    }

    def saveEpgsearchTimer(VDR vdr, EpgsearchSearchTimer timer) {
        SvdrpClient.getInstance.saveEpgsearchTimer(vdr, timer)
    }

    def hitk(VDR vdr, String key) {
        SvdrpClient.getInstance.hitk(vdr, key)
    }

    def getOsd(VDR vdr) {
        SvdrpClient.getInstance.getOsd(vdr)
    }

    def processCommand(VDR vdr, Optional<String> command) {
        SvdrpClient.getInstance.processCommand(vdr, command)
    }

    def processCommand(VDR vdr, String command) {
        SvdrpClient.getInstance.processCommand(vdr, command)
    }

    def isPluginAvailable(String vdrName, String pluginName) {
        SvdrpClient.getInstance.isPluginAvailable(vdrName, pluginName)
    }

    def void deleteTimer(VDR vdr, Timer timer) {
        SvdrpClient.getInstance.deleteTimer(vdr, timer)
    }

    def playRecording(VDR vdr, Recording recording) {
        SvdrpClient.getInstance.playRecording(vdr, recording)
    }

    def void saveEpgData(VDR vdr, Epg epg, String text) {
        SvdrpClient.getInstance.saveEpgData(vdr, epg, text)
    }
}
