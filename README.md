# jonglisto-ng
A web GUI for VDR (see http://www.tvdr.de/ and https://www.vdr-portal.de/).

At the end of this page you can find some screenshots of the currently existing version.

### features
* Multiple VDR instances can be used in parallel. e.g. server and/or client instances
* EPG view with configurable columns (using regular expressions), search repeatings, add Timer and more
* possibibilty to define several channel favourites and to use them in the epg view
* edit EPG entries
* manage timers (create, delete, move, ...), also remote timers if VDR is configured accordingly
* manage recordings (rename, delete, move recordings and whole directories via drag and drop, create new folders, ...)
* manage epgd search timers, if the epgd database is configured (optional)
* manage epgsearch search timers, if epgsearch plugin is installed on the selected VDR instance (optional)
* configurable remote control
* OSD view, if svdrposd plugin is installed on the selected VDR instance (optional)
* organize channels.conf via drag and drop
* organize epgd channelmap.conf via drag and drop, if epgd database is configured
* easily execute SVDRP commands on one VDR instance
* create cronjob like jobs (shell command or svdrp commands are possible). jonglisto-ng uses quartz (http://www.quartz-scheduler.org) like triggers. Configuration and samples can be found at http://www.quartz-scheduler.org/documentation/quartz-2.x/tutorials/crontrigger.html.
* implements a SVDRP server used by vdr-plugin-jonglisto
* use URL parameter locale as the locale to use (see chapter i18n)
* show EPG scraper information: images, extended information. (needs plugin jonglisto)
* show deleted recordings (needs plugin jonglisto)
* undelete recording (needs plugin jonglisto)
* send wake-on-lan to configured VDR
* update channel list on running VDR
* under tools exists the possibility to copy epg or channel data between different VDRs, mainly used for development

### minimal requirement
* one VDR instance without any plugin. jonglisto-ng uses mainly only SVDRP commands.

### optional requirements
* VDR plugin svdrposd to use the OSD view in jonglisto-ng (http://www.vdr-wiki.de/wiki/index.php/Svdrposd-plugin, http://vdr.schmirler.de/)
* VDR plugin epgsearch (http://www.vdr-wiki.de/wiki/index.php/Epgsearch-plugin)
* VDR epgd database (https://projects.vdr-developer.org/projects/vdr-epg-daemon/wiki)
* VDR plugin jonglisto (https://github.com/Zabrimus/vdr-plugin-jonglisto, use the latest version)

# Howto Build jonglisto-ng
The build itself creates only a web-archive (war) file, which has to be deployed in a server. Tested servers are
* Apache TomEE (at least version apache-tomee-webprofile-7.0.4). This server is also used to implement jonglisto-ng
* Payara Micro 174
More Information can be found in the deployment chapter.

## channel logos (optional)
If you want to see channel logos, the go to directory tools and start the shell script build-logo-jar.sh. This script clones the picons gitlab repository and creates png files for a massive amount of channel logos.
The channel logo images are then copied to the application directory and are part of the application.

## Build using Gradle
Clone jonglisto-ng

build jonglisto-ng
   > ./gradlew war

The war file can be found in build/libs/jonglisto-ng.'version'.war

## Build using docker
It's easy to delete all images. The local system will not be polluted with maven dependencies. The build is a two step process.
The automatically created build image is available at DockerHub and contains also the channel logos: https://hub.docker.com/r/zabrimus/jonglisto-ng/

Build jonglisto-ng without channel logos:
> docker run -v `` ` ``pwd`` ` ``:/tmp/jonglisto-ng/build/libs zabrimus/jonglisto-ng /bin/bash -c "cd /tmp/jonglisto-ng; git pull; ./gradlew deleteLogos; ./gradlew war; ./gradlew copySamples"

Build jonglisto-ng with channel logos:
> docker run -v `` ` ``pwd`` ` ``:/tmp/jonglisto-ng/build/libs zabrimus/jonglisto-ng /bin/bash -c "cd /tmp/jonglisto-ng; git pull; ./gradlew war; ./gradlew copySamples"

If someone wants to build the build image itself, it's also possible with
> docker build -t "zabrimus/jonglisto-ng" https://github.com/Zabrimus/jonglisto-ng.git#:docker/build-image

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
The application will be accessible with http://server:8080/jonglisto-ng-'version' (e.g.http://server:8080/jonglisto-ng-0.2.5)

If you want another context, e.g. http://server:8080/japp, then rename the war file in directory webapps to the desired name, e.g. japp.war.
To access jonglisto-ng with http://server:8080/ then rename the war file to ROOT.war.

A TomEE manager application is available (apache-tomee-webprofile-7.0.4/webapps/manager) which is a minimal management application, which could be useful. But before using this application a change of ``apache-tomee-webprofile-7.0.4/conf/tomcat-users.xml`` is necessary.

## Using Payara Micro (at least version 174)
* Download the Payara Micro distribution from https://www.payara.fish/downloads to a directory of your choice but don't extract the archive.
There exists two possibilities to start jonglisto-ng
* Start jonglisto-ng using the downloaded Payara Micro jar file: ``java -jar payara-micro-4.1.2.174.jar --disablephonehome --nocluster --deploy jonglisto-ng-'version'.war``
* create a self running jar with ``java -jar payara-micro-4.1.2.174.jar --disablephonehome --nocluster --deploy jonglisto-ng-'version'.war --outputuberjar <my_new_name>.jar`` and start the server and application with ``java -jar <my_new_name>.jar``

The server announces the URL to access the application. In my example it is ``http://<server>:8080/jonglisto-ng-0.2.5``
As described in the TomEE part, you could rename the war file to be able to access jonglisto-ng with a different URL.

## Using a precompiled docker container (Alpine Linux with TomEE)
On DockerHub exists a docker image `zabrimus/jonglisto-ng-runtime` already containing TomEE and the lastest version of jonglisto-ng.
There exists several possibities to use this docker image.

### Don't use local directories
The configuration files only exists in the docker container and shall be edited there.
```
docker run -p 8080:8080 zabrimus/jonglisto-ng-runtime:latest
```

### Use local directories for the configuration files
Create two local directories `var` and `etc` in a directory of your choice and start jonglisto-ng within this directory with
```
docker run -v `pwd`/var:/var/jonglisto-ng -v `pwd`/etc:/etc/jonglisto -p 8080:8080 zabrimus/jonglisto-ng-runtime:latest
```
or use absolute paths
```
docker run -v /your/directory/var:/var/jonglisto-ng -v /your/directory/etc:/etc/jonglisto -p 8080:8080 zabrimus/jonglisto-ng-runtime:latest
```
After the first start, you will find the configuration files inside your directories, which then can be modified.
Jonglisto can be reached e.g. via http://localhost:8080/jonglisto-ng


# Configuration
There exists three configuration files which have to be installed in /etc/jonglisto
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
        <!-- mac:         Network MAC address, needed for WOL               -->
        <instance name="vdr1"       displayName="VDR 1"      host="vdr1"       port="6419" mac="00-80-40-41-42-43"/>
        <instance name="vdr2"       displayName="VDR 2"      host="vdr2"       port="6419" mac="00-80-40-41-42-44"/>
        <instance name="vdr3"       displayName="VDR 3"      host="vdr3"       port="6419" />
        <instance name="epgcollect" displayName="epgcollect" host="epgcollect" port="6419" />
</configuredVdr>
```

Optional configuration, which tells jonglisto-ng which SVDRP in vdr-plugin-jonglisto is allowed to use for
every VDR. This configuration is of course only necessary if the plugin is installed.
```xml
    <!-- optional configuration, which SVDRP command of vdr-plugin-jonglisto jonglisto-ng are    -->
    <!-- allowed to use in the specified VDR. Some commands falls back to the VDR implementation -->
    <!-- other commands will raise a notification in the GUI.                                    -->
    <!-- the pseudo commands 'all' and 'none' allows any command or no command at all.           -->
    <jonglisto-plugin>
        <allow vdr="vdr1">
            <command>all</command>
        </allow>

        <allow vdr="vdr2">
            <command>none</command>
        </allow>

        <allow vdr="vdr3">
            <command>NEWT</command>
            <command>NERT</command>
            <command>DELT</command>
            <command>SWIT</command>
        </allow>

        <!-- configuration for epgcollect do not exists. Use the default: all, if the     -->
        <!-- plugin exists on epgcollect                                                  -->
    </jonglisto-plugin>
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
    <epg2vdr host="epgd" port="3306" username="epg2vdr" password="epg" database="epg2vdr" />
```

Optional the SVDRP server port which shall be created by jonglisto-ng
```xml
    <svdrpPort>6420</svdrpPort>
```

Optional configuration of the time zone: e.g. Europe/Berlin
usually the time zone of the system is used, but this could be not desired
```xml
    <timezone tz="Europe/Berlin" />
```

Optional: disable login and use user in URL parameter. But use this with caution!
```xml
    <!-- Additionally security.ini has to be configured                                    -->
    <!--      [main]                                                                       -->
    <!--      passwordMatcher = vdr.jonglisto.shiro.JonglistoPasswordMatcher               -->
    <!--      iniRealm.credentialsMatcher = $passwordMatcher                               -->
    <disableLogin urlUserParam="USER" />
```

Optional scraper information, extended EPG information and images. Needs vdr-plugin-jonglisto on same VDR as the epg VDR
```xml
    <!-- images: can be true or false to show scraper images in EPG details view                                                     -->
    <!-- If jonglisto-ng and vdr with vdr-plugin-jonglisto are running on the same machine, then the imagePath substitution is       -->
    <!-- is not necessary, but if e.g. the image directory is shared via NFS or Samba, then the path information of                  -->
    <!-- of vdr-plugin-jonglisto and the machine which runs jonglisto-ng will probably differ. A path replacement is then necessary. -->
    <!-- It's possible to specify multiple entries. In this case all entries will be used to find the desired image file             -->
    <!-- e.g. vdr-jonglisto-ng returns this path:                                                                                    -->
    <!--      /home/vdr/vdr-2.3.8/videodir/plugins/scraper2vdr/series/71470/fanart3.jpg                                              -->
    <!-- which shall be mapped to another path for jonglisto-ng                                                                      -->
    <!--      /nfs/vdr/configuration/plugins/scraper2vdr/series/71470/fanart3.jpg                                                    -->
    <!-- then the following configuration is necessary. Otherwise jonglisto-ng will not find any image.                              -->
    <scraper>
        <images>true</images>
        <imagePath>
            <replace><![CDATA[/home/vdr/vdr-2.3.8/videodir/plugins/]]></replace>
            <to><![CDATA[/nfs/vdr/configuration/plugins/]]></to>
        </imagePath>

        <imagePath>
            <replace><![CDATA[/home/vdr2/vdr-2.3.8/videodir/plugins/]]></replace>
            <to><![CDATA[/nfs/vdr2/configuration/plugins/]]></to>
        </imagePath>
    </scraper>
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

Predefined SVDRP commands. Exists only for convinience.
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
The custom column consists of three parts: header, pattern and output. The header is the column header name. The pattern is a regular expression which shall be search within the EPG details. The output contains the data and format which shall be shown in the grid row.

## security (sample can be found in samples/security.ini
The security configuration can be done in /etc/jonglisto/security.ini.
There exists three parts
* [main]
* [users]
* [roles]

Within [users] authenticated users with password and attached roles can be configured. The format is
``username = password, role1, role2, ... ``

You can use plain text or salted hashed passwords for more security. If you want to use the hashed password configuration, then you need the password hash tool described in https://shiro.apache.org/command-line-hasher.html. Currently http://repo1.maven.org/maven2/org/apache/shiro/tools/shiro-tools-hasher/1.3.2/shiro-tools-hasher-1.3.2-cli.jar is available.
Usage is ``java -jar shiro-tools-hasher-1.3.2-cli.jar -p``. Then copy the created password.

Within [roles] roles can be configured with all permissions a role have. The format is
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
* view:config:favourite
* vdr:"instance name in jonglisto-ng.xml"
* svdrp:execute
* view:config:favourite
* view:config:favourite:all
* view:config:favourite:user
* view:config:jobs:all
* view:config:jobs:user
* view:config:jobs:shell
* view:config:jobs:svdrp
* view:config:log

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

# i18N
Currently the german and english localization files exists. Feel free to create new language files or fix existing ones.
They can be found in directories
```
web/src/main/java/vdr/jonglisto/web/i18n
```
See Messages_en.properties and Messages_de.properties in both directories.

With the URL parameter ``locale`` it is possible to preselect the desired locale (normally the browser locale is used).
```
http://<server>:8080/jonglisto-ng?locale=de
http://<server>:8080/jonglisto-ng?locale=en
```

# Extended EPG search functionality
In Configuration/Extended EPG search exists the possibility to define regex patterns, which can be used in epg search view.
To be more readable, the pattern can be splitted. It's possible to define pattern parts (ususal regex) which then can be
referenced in the real pattern configuration.

E.g. predefined are these pattern parts:
```
Name: 'Staffel 1' with pattern '\|Staffel:\s*1(?=\|)'
Name: 'Folge 1' with pattern '\|Staffelfolge:\s*1(?=\|)'
Name: 'whitespace' with pattern '(?[\\s]+[\\|])'
```
These pattern parts can then be used in the real pattern
```
Name: 'Serienstart' with pattern '((#Staffel 1)(.*?)(#Folge 1))|((#Folge 1)(.*?)(#Staffel 1))'
Name: 'Staffelstart' with pattern '(#Folge 1)'
```
The entries (#Staffel 1), (#Folge 1) will be replaced with the pattern parts defined above.
The final search pattern will then be (much lesser readable):
```
Name: 'Serienstart' with pattern '((\|Staffel:\s*1(?=\|))(.*?)(\|Staffelfolge:\s*1(?=\|)))|((\|Staffelfolge:\s*1(?=\|))(.*?)(\|Staffel:\s*1(?=\|)))'
Name: 'Staffelstart' with pattern '(\|Staffelfolge:\s*1(?=\|))'
```

The possible regular expression are the one defined with Perl 5.6 and a short description can be found in
http://jregex.sourceforge.net/syntax.html#combclasses

# Screenhots
## Main Page
![Main](https://github.com/Zabrimus/page/blob/master/jng-main.png)

## EPG list
![EPG1](https://github.com/Zabrimus/page/blob/master/jng-epg1.png)
![EPG2](https://github.com/Zabrimus/page/blob/master/jng-epg2.png)

## EPG search (retransmissions)
![EPG3](https://github.com/Zabrimus/page/blob/master/jng-epg-retransmission.png)

## EPG details
![EPG4](https://github.com/Zabrimus/page/blob/master/jng-epg-details.png)

## Timer list
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-timer.png)

## epgd searchtimer list
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgd-list.png)

## epgd searchtimer edit
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgd-edit1.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgd-edit2.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgd-edit3.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgd-edit4.png)

## epgsearch searchtimer list
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgsearch-list.png)

## epgsearch searchtimer edit
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgsearch-edit1.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgsearch-edit2.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgsearch-edit3.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-epgsearch-edit4.png)

## Recordings list
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-recording-list.png)

## Recordings rename/move/delete
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-recording-rename.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-recording-move1.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-recording-delete.png)

## OSD
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-osd.png)

## channel config
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-channelconfig.png)

## VDR OSD / Jonglisto-ng channel favourites
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-favourites.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-osdserver-fav1.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-osdserver-fav2.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-osdserver-fav3.png)
![TIMER1](https://github.com/Zabrimus/page/blob/master/jng-osdserver-fav4.png)






