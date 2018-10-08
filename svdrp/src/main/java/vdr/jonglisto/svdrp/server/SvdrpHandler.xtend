package vdr.jonglisto.svdrp.server

import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.Socket
import vdr.jonglisto.xtend.annotation.Log
import java.io.IOException
import java.io.StringWriter
import vdr.jonglisto.configuration.Configuration
import java.util.stream.Collectors
import java.util.Collections
import java.util.List
import java.util.regex.Pattern
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action.VdrAction
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action
import vdr.jonglisto.util.Utils
import vdr.jonglisto.model.VDR
import java.util.Optional
import java.util.ArrayList
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.util.NetworkUtils

@Log("jonglisto.svdrp.server")
class SvdrpHandler implements Runnable {

    static val alrmPattern = Pattern.compile("^(\\d+) +(\\d+) +(.*?) +(.*?)$")
    static val cmdPattern = Pattern.compile("^(?i)plug +jonglisto +swit +(.*?) +(.*)$")

    var Socket client

    new(Socket client) {
        this.client = client
    }

    override run() {
        var BufferedReader input
        var BufferedWriter output

        log.info("> New connection: " + client + ", " + client.inetAddress.hostAddress)

        try {
            input = new BufferedReader(new InputStreamReader(client.getInputStream()))
            output = new BufferedWriter(new OutputStreamWriter(client.getOutputStream()))

            // send greeting
            output.write("220 " + Configuration.instance.discoveryServername + " SVDRP VideoDiskRecorder 2.4.0; Mon Jan 01 10:00:00 2018; UTF-8\n");
            output.flush();

            log.info("> Waiting for Response: " + client.remoteSocketAddress)

            // endless loop
            while (true) {
                try {
                    var StringWriter command = new StringWriter
                    var int ch;
                    while ((ch = input.read()) != -1) {
                        if (ch !== 13 && ch !== 0) {
                            command.append(ch as char)
                        } else {
                            val commandLine = command.toString().trim()
                            command = new StringWriter

                            log.debug("> Received command: " + commandLine)

                            if (commandLine.length === 0) {
                                // do nothing
                            } else if (commandLine.length < 4) {
                                // unkown command
                                output.write("221 unknown command\n")
                                output.flush
                            } else {
                                val cmd = commandLine.substring(0, 4).toUpperCase
                                var String option

                                if ((commandLine.length >= 5) && " ".equals(commandLine.charAt(4).toString())) {
                                    option = commandLine.substring(5).trim()
                                }

                                switch (cmd) {
                                    case "PING": {
                                        cmdPING(output)
                                    }
                                    case "FAVL": {
                                        cmdFAVL(output, option)
                                    }
                                    case "FAVC": {
                                        cmdFAVC(output, option)
                                    }
                                    case "EPGT": {
                                        cmdEPGT(output)
                                    }
                                    case "ALRM": {
                                        cmdALRM(output, option)
                                    }
                                    case "ALRL": {
                                        cmdALRL(output, option)
                                    }
                                    case "ALRC": {
                                        cmdARLC(output, option)
                                    }
                                    case "VDRL": {
                                        cmdVDRL(output)
                                    }
                                    case "VDRD": {
                                        cmdVDRD(output, option)
                                    }
                                    case "VDRP": {
                                        cmdVDRP(output, option)
                                    }
                                    case "VDRW": {
                                        cmdVDRW(output, option)
                                    }
                                    case "CONN": {
                                        cmdCONN(output, option)
                                    }
                                    case "QUIT": {
                                        output.write("221 " + Configuration.instance.discoveryServername + " closing connection\n")
                                        output.flush
                                        output.close
                                        input.close
                                        client.close
                                        return;
                                    }
                                    default: {
                                        // unkown command
                                        output.write("221 unknown command\n")
                                        output.flush
                                    }
                                }
                            }
                        }
                    }

                    // socket seems to be closed
                    return
                } catch (IOException e) {
                    println("Socket Error: " + e);
                    e.printStackTrace;
                    return;
                }
            }
        } catch (IOException e) {
            throw new RuntimeException(e)
        } finally {
            if (input !== null) {
                try {
                    input.close
                } catch (IOException exc) {
                    // ignore
                }
            }

            if (output !== null) {
                try {
                    output.close
                } catch (IOException exc) {
                    // ignore
                }
            }

            log.info("> Closing connection to " + client.remoteSocketAddress)
        }
    }

    def writeResponse(BufferedWriter output, List<String> strings, String code) throws IOException {
        if (strings.size > 0) {
            for (var i = 0; i < strings.size; i++) {
                output.write(code + (if(i === strings.size - 1) " " else "-") + strings.get(i) + "\n")
            }
        } else {
            output.write("950 empty result\n");
        }
    }

    private def cmdPING(BufferedWriter output) throws IOException {
        output.write("250 " + Configuration.instance.discoveryServername + " is alive\n");
        output.flush();
    }

    private def cmdFAVL(BufferedWriter output, String option) throws IOException {
        var Optional<VDR> vdr

        try {
            vdr = Configuration.getInstance.findVdr(client.inetAddress.hostAddress, Integer.valueOf(option))
        } catch (Exception e) {
            e.printStackTrace

            output.write("950 FAVL cannot identify VDR " + client.inetAddress.hostAddress + ":" + option + "\n")
            output.flush
            return
        }

        val filterCriteria = vdr.get.name
        var List<String> result

        val fav = Configuration.instance.favourites?.favourite
        if (fav !== null && fav.size > 0) {
            result = Configuration.instance.favourites.favourite //
            .stream() //
            .filter(s|s.systems.contains(filterCriteria)).map(s|s.name) //
            .collect(Collectors.toList())
        } else {
            result = Collections.emptyList
        }

        writeResponse(output, result, "900");
        output.flush
    }

    private def cmdFAVC(BufferedWriter output, String commandLine) throws IOException {
        try {
            val name = commandLine.toUpperCase;
            var List<String> result

            val favourites = Configuration.instance.favourites?.favourite
            if (favourites !== null && favourites.size > 0) {
                val fav = favourites //
                .stream() //
                .filter(s|s.name.toUpperCase == name) //
                .findFirst
                if (fav.isPresent) {
                    result = fav.get().channel
                } else {
                    result = Collections.emptyList
                }
            } else {
                result = Collections.emptyList
            }

            writeResponse(output, result, "900");
        } catch (Exception e) {
            // command parameter is missing
            output.write("950 FAVC parameter '" + commandLine + "' is missing or invalid\n");
        }
        output.flush;
    }

    private def cmdEPGT(BufferedWriter output) throws IOException {
        var List<String> result

        val sel = Configuration.instance.epgTimeSelect
        if (sel !== null && sel.size > 0) {
            result = Configuration.instance.epgTimeSelect
        } else {
            result = Collections.emptyList
        }

        writeResponse(output, result, "900");
        output.flush
    }

    private def cmdALRM(BufferedWriter output, String option) throws IOException {
        try {
            val matcher = alrmPattern.matcher(option)

            if (matcher.matches) {
                val svdrpPort = matcher.group(1)
                val time = matcher.group(2)
                val channelId = matcher.group(3)
                val title = matcher.group(4)

                val vdr = Configuration.getInstance.findVdr(client.inetAddress.hostAddress, Integer.valueOf(svdrpPort))

                if (!vdr.isPresent) {
                    output.write("950 VDR " + client.inetAddress.hostAddress + ":" + svdrpPort +
                        " is not configured\n");
                } else {
                    val job = new Jobs

                    val dateTime = DateTimeUtil.toDateTime(Long.valueOf(time))
                    val timeFormat = String.format("0 %d %d %d %d ? %d", dateTime.minute, dateTime.hour,
                        dateTime.dayOfMonth, dateTime.monthValue, dateTime.year)

                    job.id = Utils.nextRand.toString
                    job.active = true
                    job.user = vdr.get().name
                    job.time = timeFormat

                    val vdrAction = new VdrAction
                    vdrAction.vdr = vdr.get().name
                    vdrAction.type = "pluginMessage"
                    vdrAction.parameter = "plug jonglisto SWIT " + channelId + " " + title

                    val action = new Action
                    action.vdrAction = vdrAction

                    job.action = action

                    Configuration.getInstance.addJob(job)

                    output.write("900 Alarm created\n");
                }
            } else {
                output.write("950 ALRM option are invalid '" + option + "'\n");
            }
        } catch (Exception e) {
            output.write("950 ALRM option are invalid '" + option + "'\n");
        }

        output.flush();
    }

    private def cmdALRL(BufferedWriter output, String commandLine) throws IOException {
        try {
            var Optional<VDR> vdr

            try {
                vdr = Configuration.getInstance.findVdr(client.inetAddress.hostAddress, Integer.valueOf(commandLine))
            } catch (Exception e) {
                e.printStackTrace

                output.write("950 ALRL cannot identify VDR " + client.inetAddress.hostAddress + ":" + commandLine +
                    "\n")
                output.flush
                return
            }

            if (vdr.isPresent) {
                val response = new ArrayList<String>

                val ivdr = vdr.get

                val list = Configuration.instance.jcron.jobs.stream() //
                .filter(s|s.action !== null && s.action.vdrAction !== null && s.action.vdrAction.vdr == ivdr.name) //
                .collect(Collectors.toList)

                if (list.size > 0) {
                    list.forEach( s |
                        {
                        if (s.action.vdrAction !== null && s.action.vdrAction.type == "pluginMessage") {
                            val matcher = cmdPattern.matcher(s.action.vdrAction.parameter)
                            if (matcher.matches) {
                                val sb = new StringBuilder
                                sb.append(s.id).append(" ")
                                sb.append(if(s.active) "1" else "0").append(" ")
                                sb.append(Utils.getNextScheduleTime(s.time)).append(" ")
                                sb.append(matcher.group(1)).append(" ")
                                sb.append(matcher.group(2))

                                response.add(sb.toString)
                            }
                        }
                        })

                    if (response.size === 0) {
                        output.write("901 no alarms found\n")
                    } else {
                        for (var i = 0; i < response.size(); i++) {
                            if (i === response.size() - 1) {
                                output.write("900 " + response.get(i) + "\n")
                            } else {
                                output.write("900-" + response.get(i) + "\n")
                            }
                        }
                    }
                } else {
                    output.write("901 no alarms found\n")
                }
            } else {
                output.write("950 ALRL cannot identify VDR " + client.inetAddress.hostAddress + ":" + commandLine +
                    "\n")
            }
        } catch (Exception e) {
            e.printStackTrace
            output.write("950 ALRL option are invalid '" + commandLine + "'\n");
        }

        output.flush
    }

    private def cmdARLC(BufferedWriter output, String option) throws IOException {
        if (option !== null && option.length > 0) {
            val splitted = option.split(" ");

            if (splitted.length == 2) {
                val job = Configuration.instance.jcron.jobs.stream() //
                .filter(s|s.id.equals(splitted.get(1))) //
                .findFirst

                if (job.isPresent) {
                    if ("toggle".equals(splitted.get(0))) {
                        Configuration.instance.toggleJob(job.get())
                        output.write("900 job with id " + splitted.get(1) + " toggled.\n");
                    } else if ("delete".equals(splitted.get(0))) {
                        Configuration.instance.deleteJob(job.get())
                        output.write("900 job with id " + splitted.get(1) + " deleted.\n");
                    }
                } else {
                    output.write("950 job with id " + splitted.get(1) + " not found\n");
                }
            } else {
                output.write("950 parameters are invalid: " + option + "\n");
            }
        } else {
            output.write("950 parameters are invalid: " + option + "\n");
        }

        output.flush();
    }

    private def cmdVDRL(BufferedWriter output) throws IOException {
        val result = new ArrayList<String>

        Configuration.instance.vdrNames.forEach [ s |
            {
                val vdr = Configuration.instance.getVdr(s)

                result.add(String.format("%s %s %s", vdr.name.replace(" ", "|"), vdr.host, vdr.port))
            }
        ]

        for (var i = 0; i < result.size(); i++) {
            if (i === result.size() - 1) {
                output.write("900 " + result.get(i) + "\n")
            } else {
                output.write("900-" + result.get(i) + "\n")
            }
        }

        output.flush();
    }

    private def cmdVDRD(BufferedWriter output, String option) throws IOException {
        val result = new ArrayList<String>

        val vdr = Configuration.instance.getVdr(option.trim())

        if (vdr !== null) {
            val stat = SvdrpClient.instance.getStat(vdr)
            val free = stat.toStringFree.replace(" ", "|")
            val total = stat.toStringTotal.replace(" ", "|")
            val usedPerc = stat.toStringUsedPerc

            result.add(
                String.format("%s %s %s %s", SvdrpClient.instance.getVdrVersion(vdr), free, total, usedPerc.toString))

            SvdrpClient.instance.getPlugins(vdr).forEach [ s |
                {
                    result.add(String.format("%s %s %s", s.plugin, s.version, s.description))
                }
            ]

            if (result.size > 0) {
                for (var i = 0; i < result.size(); i++) {
                    if (i === result.size() - 1) {
                        output.write("900 " + result.get(i) + "\n")
                    } else {
                        output.write("900-" + result.get(i) + "\n")
                    }
                }
            } else {
                output.write("950 VDR cannot be reached");
            }
        } else {
            output.write("950 VDR with name " + option.trim() + " is not configured\n")
        }

        output.flush();
    }

    private def cmdVDRP(BufferedWriter output, String option) throws IOException {
        val vdr = Configuration.instance.getVdr(option.trim())

        if (vdr !== null) {
            val pingVdr = Configuration.instance.pingHost(vdr)
            val svdrpVdr = if(pingVdr) SvdrpClient.instance.pingHost(vdr) else false

            if (pingVdr && svdrpVdr) {
                output.write("900 vdr is alive\n")
            } else if (pingVdr && !svdrpVdr) {
                output.write("901 system is alive, vdr is down\n")
            } else {
                output.write("902 system is down\n")
            }
        } else {
            output.write("950 VDR with name " + option.trim() + " is not configured\n")
        }

        output.flush();
    }

    private def cmdVDRW(BufferedWriter output, String option) throws IOException {
        val vdr = Configuration.instance.getVdr(option.trim())

        if (vdr !== null) {
            if (vdr.mac === null) {
                output.write("950 MAC is not configured for VDR " + vdr.name + "\n")
            } else {
                NetworkUtils.sendWol(vdr)
                output.write("900 WOL packet sent\n")
            }
        } else {
            output.write("950 VDR with name " + option.trim() + " is not configured\n")
        }

        output.flush();
    }

    private def cmdCONN(BufferedWriter output, String option) throws IOException {
        val port = Configuration.getInstance.svdrpServerPort;
        output.write("250 OK");
        output.flush();
    }

}
