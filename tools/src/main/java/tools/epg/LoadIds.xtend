package tools.epg

import com.google.gson.JsonArray
import com.google.gson.JsonElement
import com.google.gson.JsonParser
import java.io.BufferedReader
import java.io.FileWriter
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.util.ArrayList
import java.util.zip.GZIPInputStream
import org.apache.commons.cli.CommandLine
import org.apache.commons.cli.DefaultParser
import org.apache.commons.cli.HelpFormatter
import org.apache.commons.cli.Options
import org.apache.commons.cli.ParseException
import org.apache.commons.lang3.StringUtils

class LoadIds {
    enum PROVIDER {
        TVM,
        TVSP,
        EPGDATA
    }

    private static val tvmUrl = 'http://wwwa.tvmovie.de/static/tvghost/html/onlinedata/cftv520/datainfo.txt'
    private static val tvspUrl = 'https://live.tvspielfilm.de/static/content/channel-list/livetv'
    private static val epgdataUrl = 'http://www.epgdata.com/index.php?action=sendInclude&iOEM=vdr&pin=##PIN##&dataType=xml'

    def static void main(String[] args) {
        val parser = new DefaultParser()
        var CommandLine cmd = null

        val options = new Options
        options.addOption("h", "help", false, "show help.");
        options.addOption("o", "output", true, "output filename");
        options.addOption("t", "type", true, "can be 'all', 'tvsp', 'tvm' or 'epgdata'");
        options.addOption("p", "pin", true, "epgdata pin");

        try {
            cmd = parser.parse(options, args)

            if (cmd.hasOption("h"))
                options.help

            if (!cmd.hasOption("o")) {
                println("parameter 'o' is missing")
                options.help
            }

            if (!cmd.hasOption("t")) {
                println("parameter 't' is missing")
                options.help
            }
        } catch (ParseException e) {
            options.help
        }

        val result = new ArrayList<String>

        val load = new LoadIds
        
        if ("all" == cmd.getOptionValue("t") || "tvm" == cmd.getOptionValue("t")) {        
            result.addAll(load.getEpgIds(PROVIDER.TVM, null))            
        }

        if ("all" == cmd.getOptionValue("t") || "tvsp" == cmd.getOptionValue("t")) {        
            result.addAll(load.getEpgIds(PROVIDER.TVSP, null))            
        }

        if ("all" == cmd.getOptionValue("t") || "epgdata" == cmd.getOptionValue("t")) {        
            result.addAll(load.getEpgIds(PROVIDER.EPGDATA, cmd.getOptionValue("p")))            
        }
     
        val fw = new FileWriter(cmd.getOptionValue("o"))
        result.forEach(s | fw.append(s).append("\n"))
        fw.close
            
        println("Result\n" + result)
    }

    def getEpgIds(PROVIDER provider, String epgDataPin) {
        val result = new ArrayList<String>();

        switch (provider) {
            case TVM: {
                val remote = loadIds(tvmUrl, false, "ISO-8859-1");

                for (var i = 3; i < remote.size; i += 2) {
                    result.add(String.format("%s|%s|%s|%s", PROVIDER.TVM, remote.get(i + 1), remote.get(i), remote.get(i).normalizeChannelName))
                }
            }
            case TVSP: {
                val remote = loadIds(tvspUrl, true, "UTF-8");
                val json = new JsonParser().parse(remote.get(0))

                array(json).forEach(ch | {
                    val id = str(ch <= 'id')
                    val name = str(ch <= 'name')
        
                    result.add(String.format("%s|%s|%s|%s", PROVIDER.TVSP, id, name, name.normalizeChannelName))
                })
            }
            case EPGDATA: {
                // this provider is currently not implemented
                if (epgDataPin !== null) {
                    epgdataUrl.replaceAll("##PIN##", epgDataPin);
                }
                System.err.println("epgdata is currently not implemented")
            }
        }

        return result
    }

    private def loadIds(String from, boolean isZipped, String encoding) {
        var URL url
        var BufferedReader reader

        try {
            url = new URL(from);
            val connection = url.openConnection() as HttpURLConnection
            connection.requestMethod = "GET"
            connection.readTimeout = 15 * 1000
            connection.connect

            if (!isZipped) {
                reader = new BufferedReader(new InputStreamReader(connection.inputStream, encoding))
            } else {
                reader = new BufferedReader(new InputStreamReader(new GZIPInputStream(connection.inputStream), encoding))
            }

            val result = new ArrayList<String>
            var String line

            while ((line = reader.readLine()) !== null) {
                result.add(line);
            }

            return result;
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            if (reader !== null) {
                reader.close;
            }
        }
    }

    def normalizeChannelName(String input) {
        return StringUtils.stripAccents(input) //
                .replaceAll("\\&", "and") //
                .replaceAll("\\+", "plus") //
                .replaceAll("\\*", "star") //
                .replaceAll("HD 1", "1") //
                .replaceAll("HD 2", "2") //
                .replaceAll("HD 3", "3") //
                .replaceAll("HD 4", "4") //
                .replaceAll("HD 5", "5") //
                .replaceAll("HD 6", "6") //
                .replaceAll("HD 7", "7") //
                .replaceAll("HD 8", "8") //
                .replaceAll("HD 9", "9") //
                .replaceAll("II", "2") //
                .replaceAll("III", "3") //
                .replaceAll("7", "sieben") //
                .replaceAll("\\s+\\(*HD\\)*$", "") //
                .replaceAll("\\s+\\(S\\)$", "") //
                .replaceAll("\\s+\\(*HD\\)*$", "") //
                .replaceAll("[^A-Za-z0-9]", "") //
                .trim() //
                .toLowerCase();
    }


    private def JsonElement <=(JsonElement element, String key) {
        element.asJsonObject.get(key)
    }

    private def String str(JsonElement element) {
        element.asString
    }

    private def JsonArray array(JsonElement element) {
        element.asJsonArray
    }

    static private def help(Options options) {
        val formatter = new HelpFormatter();
        formatter.printHelp("Main", options);
        System.exit(0);
    }
}
