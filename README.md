# jonglisto-ng
successor of vdr-jonglisto (complete new implementation, easier to read, to manage, more understandable, ...)

docker build -t "jonglisto-ng:build" https://github.com/Zabrimus/jonglisto-ng.git#:docker/build-image

docker run -v `pwd`:/tmp/jonglisto-ng/build/libs jonglisto-ng:build /bin/bash -c "cd /tmp/jonglisto-ng; git pull; ./gradlew standaloneWar"



