# jonglisto-ng
A web GUI for VDR (see http://www.tvdr.de/ and https://www.vdr-portal.de/).

### features
* Multiple VDR instances can be used in parallel. e.g. server and/or client instances
* EPG view with configurable columns (using regular expressions)
* edit EPG entries
* manage timers (create, delete, move, ...)
* manage recordings (rename, move via drag and drop, create new folders, ...)
* manage EPGD search timers, if the epgd database is configured (optional)
* manage epgsearch search timers, if epgsearch plugin is installed on the selected VDR instance (optional)
* higly configurable remote control 
* OSD view, if svdrposd plugin is installed on the selected VDR instance (optional)
* organize channels.conf via drag and drop
* organize epgd channelmap.conf via drag and drop, if epgd database is configured
* easily execute SVDRP commands on one VDR instance

### minimal requirement
* one VDR instance without any plugin. jonglisto-ng uses mainly only SVDRP commands.

### optional requirements
* VDR plugin svdrposd to use the OSD view in jonglisto-ng (http://www.vdr-wiki.de/wiki/index.php/Svdrposd-plugin, http://vdr.schmirler.de/)
* VDR plugin epgsearch (http://www.vdr-wiki.de/wiki/index.php/Epgsearch-plugin)
* VDR epgd database (https://projects.vdr-developer.org/projects/vdr-epg-daemon/wiki)

## Build using docker
It's easy to delete the all images. The local system will not be polluted with maven dependencies.
Build the build image:
> docker build -t "jonglisto-ng:build" https://github.com/Zabrimus/jonglisto-ng.git#:docker/build-image

Optional task: Create channel logos 
> cd tools; ./build-logo-jar.sh

Build jonglisto using the build image:
> docker run -v `` ` ``pwd`` ` ``:/tmp/jonglisto-ng/build/libs jonglisto-ng:build /bin/bash -c "cd /tmp/jonglisto-ng; git pull; ./gradlew standaloneWar"

## traditional build 
Clone jonglisto-ng
optional build the channel logos
   > cd tools; ./build-logo-jar.sh
   
build jonglisto-ng
   > ./gradlew standaloneWar
   
### Start jonglisto-ng
Before starting jonglisto-ng, you have to edit or copy two configuration files into /etc/jonglisto (see below).
You can either deploy the jonglisto-ng.war into an existing servlet container (jetty, tomcat, tomee and others), or you can start the application using the embedded jetty server. The default port is 8080.
> java -jar jonglisto-ng.war

### Configuration
There exists two configuration files which have to be installed in /etc/jonglisto
## jonglisto-ng.xml (sample can be found in samples/jonglisto-ng.xml)
The directory in which jonglisto-ng can write some configuration data.
```xml
<!-- configuration directory in which jonglisto-ng can store some configuration files -->
<directory dir="/var/jonglisto-ng" />
```

Existing VDR instances
```xml
<!-- all available configured VDR instances -->
<configuredVdr>
        <!-- name:        internal name, used to identify the VDR instance  -->
        <!-- displayName: name, which will be shown in the GUI as selection -->
        <!-- host:        hostname or IP address of the VDR instance        -->
        <!-- port:        SVDRP port of the VDR instance                    -->
        <instance name="vdr1"       displayName="VDR 1"      host="vdr1"       port="6419" />
        <instance name="vdr2"       displayName="VDR 2"      host="vdr2"       port="6419" />
        <instance name="vdr3"       displayName="VDR 3"      host="vdr3"       port="6419" />
        <instance name="epgcollect" displayName="epgcollect" host="epgcollect" port="6419" />
</configuredVdr>
```

Which VDR instance shall be used to get epg and channel data
```xml
    <!-- configuration of the VDR instance which are responsible for EPG and channel data -->
    <!-- ref:  reference to a configured VDR instance, see configuredVdr.instance.name    -->
    <!-- updateInterval: jonglisto-ng uses an internal cache for EPG and channel data.    -->
    <!--                 the data will be updated after xxx minutes at the latest         -->
    <epg     ref="epgcollect" updateInterval="720" />
    <channel ref="epgcollect" updateInterval="720" />
```

Optional configuration of the VDR epg daemon database
```xml
    <!-- optional configuration of the epg2vdr database, used for e.g. search timers -->
    <epg2vdr host="epgd" port="3306" username="epg2vdr" password="epg" />
```

Predefined time values used in EPG view. Exists only for convinience.
```xml
    <!-- preconfigured time list used in EPG view to fastly select a time value -->
    <epgTimeList>
        <value>10:00</value>
        <value>12:00</value>
        <value>18:00</value>
        <value>20:15</value>
        <value>23:00</value>
    </epgTimeList>
```

Predefined SVDRP command. Exists only for convinience.
```xml
    <!-- preconfigured common SVDRP commands -->
    <svdrpCommandList>
        <command>HELP</command>
        <command>PLUG</command>
    </svdrpCommandList>
```

Default configuration of the EPG view. The columns can be customized using a regular expression.
```xml
    <!-- configuration of epg columns -->
    <!-- Tested with http://www.regexplanet.com/advanced/java/index.html -->
    <epg-columns>
        <series>
            <season>
                <pattern>(^|\|)Staffel:(.*?)\|</pattern>
                <group>2</group>
            </season>

            <part>
                <pattern>(^|\|)Staffelfolge:(.*?)\|</pattern>
                <group>2</group>
            </part>

            <parts>
                <pattern>(^|\|)Staffelfolgen:(.*?)\|</pattern>
                <group>2</group>
            </parts>
        </series>

        <!-- can be disabled, if wished
        <genre>
            <pattern>(^|\|)Genre:(.*?)\|</pattern>
            <group>2</group>
        </genre>
        <category>
            <pattern>(^|\|)Kategorie:(.*?)\|</pattern>
            <group>2</group>
        </category>
        -->

        <!-- Custom patterns and columns -->
        <custom-pattern>
            <custom>
                <header>Rating</header>
                <pattern>(^|\|)(Empfehlenswert|Eher durchschnittlich|Eher uninteressant|Einer der besten Filme aller Zeiten|Sehr empfehlenswert)\|</pattern>
                <output><![CDATA[<span style="color:red">${2}</span>]]></output>
            </custom>

            <custom>
                <header>Tipp</header>
                <pattern>(^|\|)(TopTipp|GoldTipp|TagesTipp|Tipp)\|</pattern>
                <output><![CDATA[<span style="color:red">${2}</span>]]></output>
            </custom>

            <custom>
                <header>-</header>
                <pattern>(^|\|) (/.*?)\|</pattern>
                <output><![CDATA[<span style="color:red">${2}</span>]]></output>
            </custom>

            <!--
            <custom>
                <header>Quelle</header>
                <pattern>(^|\|)Quelle:(.*?)(\||$)</pattern>
                <output><![CDATA[<span style="color:red;text-decoration: underline;">${2}</span>]]></output>
            </custom>
            -->
        </custom-pattern>
</epg-columns>
```
The custom column consists of three parts: header, pattern and output. The header is the column header name. The pattern is a regular expression which shall be search within the EPG details. The output contains the data and format which shall shown in the grid row.

## remote.xml (sample can be found in samples/remote.xml)
The remote.xml contains the configuration and layout of the remote control. The remote control uses a grid as layout component, therefore columns and rows have to be defined.
```xml
<remote xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
      xsi:noNamespaceSchemaLocation="remote.xsd" colorRow="10">
      
    <!-- Row 1 -->
    <button row="1" column="3">
        <key>Power</key>
        <icon>POWER_OFF</icon>
    </button>
    
    <!-- Row 17 -->
    <button row="17" column="1">
        <key>FastRew</key>
        <icon>BACKWARDS</icon>
    </button>

    <button row="17" column="2">
        <key>Play</key>
        <icon>PLAY</icon>
    </button>

    <button row="17" column="3">
        <key>FastFwd</key>
        <icon>FORWARD</icon>
    </button>
    
    <button row="21" column="3">
        <key>Channel+</key>
        <label>Chan+</label>
    </button>
</remote>    
```

