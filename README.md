# jonglisto-ng
A web GUI for VDR (see http://www.tvdr.de/ and https://www.vdr-portal.de/).

### features
* Multiple VDR instances can be used in parallel. e.g. server and/or client instances
* EPG view with configurable columns (using regular expressions)
* edit EPG entries
* manage timers (create, delete, move, ...)
* manage recordings (rename, delete, move via drag and drop, create new folders, ...)
* manage EPGD search timers, if the epgd database is configured (optional)
* manage epgsearch search timers, if epgsearch plugin is installed on the selected VDR instance (optional)
* configurable remote control
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

# Howto Build jonglisto-ng
The build itself creates only a web-archive (war) file, which has to be deployed in a server. Tested servers are
* Apache TomEE (at least version apache-tomee-webprofile-7.0.4). This server is also used to implement jonglisto-ng
* Payara Micro 174
More Information can be found in the deployment chapter.

## channel logos (optional)
If you want to see channel logos, the go to directory tools and start the shell script build-logo-jar.sh. This script clones the picons github repository and creates png files for a massive amount of channel logos.
The channel logo images are then copied to the application directory and are part of the application.

## Build using Gradle
Clone jonglisto-ng

build jonglisto-ng
   > ./gradlew war

The war file can be found in build/libs/jonglisto-ng.'version'.war

## Build using docker
It's easy to delete all images. The local system will not be polluted with maven dependencies. The build is a two step process.
Build the buld image:
> docker build -t "jonglisto-ng:build" https://github.com/Zabrimus/jonglisto-ng.git#:docker/build-image

Build jonglisto using the build image (without channel logos):
> docker run -v `` ` ``pwd`` ` ``:/tmp/jonglisto-ng/build/libs jonglisto-ng:build /bin/bash -c "cd /tmp/jonglisto-ng; git pull; ./gradlew war; ./gradlew copySamples"

Build jonglisto using the build image (with channel logos):
> docker run -v `` ` ``pwd`` ` ``:/tmp/jonglisto-ng/build/libs jonglisto-ng:build /bin/bash -c "cd /tmp/jonglisto-ng; git pull; (cd tools; ./build-logo-jar.sh); ././gradlew war; ./gradlew copySamples"

The war file can be found in the current directory with name jonglistp-ng.'version'.war

# Deployment and running jonglisto-ng
Generally for all described solutions to run jonglisto-ng is the following step
* copy three configuration files to directory /etc/jonglisto: jonglisto-ng.xml, remote.xml and security.ini. The configuration is described below.

## Using TomEE (at least version 7.0.4)
A hint before: TomEE Embedded 7.0.4 will not work. Unfortunately the packaged libraries differ between TomEE 7.0.4 and TomEE Embedded 7.0.4.
* Download the TomEE distribution (http://tomee.apache.org/download-ng.html, web profile) and extract the archive to a directory of your choice
* optional: delete all (or unused) directories in apache-tomee-webprofile-7.0.4/webapps. Please be aware: If you not delete the directories additional applications are deployed. But this can be desired, see below.
* copy jonglisto-ng.'version'.war to apache-tomee-webprofile-7.0.4/webapps
* start TomEE with ``apache-tomee-webprofile-7.0.4/bin/catalina.sh start`` or ``apache-tomee-webprofile-7.0.4/bin/catalina.sh run``
* stop with ``apache-tomee-webprofile-7.0.4/bin/catalina.sh stop``
The application will be accessible with http://<server>:8080/jonglisto-ng-'version' (e.g.http://<server>:8080/jonglisto-ng-0.0.1)

If you want another context, e.g. http://<server>:8080/japp, then rename the war file in directory webapps to the desired name, e.g. japp.war.
To access jonglisto-ng with http://<server>:8080/ then rename the war file to ROOT.war.

A TomEE manager application is available (apache-tomee-webprofile-7.0.4/webapps/manager) which is a minimal management application, which could be useful. But before using this application a change of ``apache-tomee-webprofile-7.0.4/conf/tomcat-users.xml`` is necessary.

## Using Payara Micro (at least version 174)
* Download the Payara Micro distribution from https://www.payara.fish/downloads to a directory of your choice but don't extract the archive.
There exists two possibilities to start jonglisto-ng
* Start jonglisto-ng using the downloaded Payara Micro jar file: ``java -jar payara-micro-4.1.2.174.jar --disablephonehome --nocluster --deploy jonglisto-ng-'version'.war``
* create a self running jar with ``java -jar payara-micro-4.1.2.174.jar --disablephonehome --nocluster --deploy jonglisto-ng-'version'.war --outputuberjar <my_new_name>.jar`` and start the server and application with ``java -jar <my_new_name>.jar``

The server announces the URL to access the application. In my example it is ``http://<server>:8080/jonglisto-ng-0.0.1``
As described in the TomEE part, you could rename the war file to be able to access jonglisto-ng with a different URL.


# Configuration
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

## security (sample can be found in samples/security.ini
The security configuration can be done in /etc/jonglisto/security.ini.
There exists three parts
* [main]
* [users]
* [roles]

Within users authenticated users with password and attached roles can be configured. The format is
``username = password, role1, role2, ... ``

You can use plain text or salted hashed passwords for more security. If you want to use the hashed password configuration, then you need the password hash tool described in https://shiro.apache.org/command-line-hasher.html. Currently http://repo1.maven.org/maven2/org/apache/shiro/tools/shiro-tools-hasher/1.3.2/shiro-tools-hasher-1.3.2-cli.jar is available.
Usage is ``java -jar shiro-tools-hasher-1.3.2-cli.jar -p``. Then use the created password.

Within roles roles can be configured with all permissions a role have. The format is
``role = permission1, permission2, ... ``

Wildcard permissions are also available, e.g. the admin role has permission * (which means everything).
Another permission is e.g. view:searchtimer:* which means all permissions starting with view:searchtimer (view:searchtimer:epgd and view:searchtimer:epgsearch)

The following permissions are currently available:
* view:epg
* view:timer
* view:searchtimer:epgd
* view:searchtimer:epgsearch
* view:recordings
* view:osd
* view:channelconfig
* vdr:<instance name in jonglisto-ng.xml>
* svdrp:execute

view: Menu entries (views) in the main menu
vdr: access granted to the selected VDR
svdrp:execute: Execution of SVDRP commands granted (in combination with permission vdr:XXX)

For more information about this configuration, you can check Apache Shiro (https://shiro.apache.org/configuration.html)

## remote.xml (sample can be found in samples/remote.xml)
The remote.xml contains the configuration and layout of the remote control. The remote control uses a grid as layout component, therefore columns and rows have to be defined for each button together with either an label or icon and the correspondig key(s), which has to be sent to VDR. Multiple keys are supported with one button. A senseless example is
```xml
    <button row="1" column="3">
        <key>Channel+</key>
        <key>Menu</key>
        <key>Power</key>
        <icon>POWER_OFF</icon>
    </button>
```

The attribute ``colorRow="10"`` indicates, that the 4 color buttons shall be shown in row 10.
The possible icons can be found at https://vaadin.com/elements/vaadin-icons/html-examples/icons-basic-demos. The name of the icon has to be modified a little bit: Uppercase and replace '-' with '_', e.g. ``vaadin:power-off`` has to be translated to ``POWER_OFF``.

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

