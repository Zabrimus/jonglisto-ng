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

Build jonglisto using the build image:
> docker run -v `pwd`:/tmp/jonglisto-ng/build/libs jonglisto-ng:build /bin/bash -c "cd /tmp/jonglisto-ng; git pull; ./gradlew standaloneWar"

