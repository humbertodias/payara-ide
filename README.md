
Online Visual code  IDE configured with payara tools extension, ready for development.

## Micro Template

    echo Y | \
    mvn archetype:generate -DarchetypeGroupId=fish.payara.maven.archetypes -DarchetypeArtifactId=payara-micro-maven-archetype -DarchetypeVersion=1.0.1 -DgroupId=fish.payara.micro -DartifactId=micro-sample -Dversion=1.0-SNAPSHOT -Dpackage=fish.payara.micro.sample -Darchetype.interactive=false \
    -DoutputDirectory=./projects

## Run

	PORT=9000 docker-compose up -d

For MacOS

Adding local directory as a possible volume path
```
cp ~/Library/Group\ Containers/group.com.docker/settings.json tmp.json
EXP=".filesharingDirectories |= . + [\"$(PWD)\"]"
jq $EXP tmp.json > modified.json
cp modified.json ~/Library/Group\ Containers/group.com.docker/settings.json
rm -f tmp.json modified.json
```

Then

http://0.0.0.0:9090/?folder=/opt/projects/micro-sample

Password is password
![](doc/code-server-password.png)

![](doc/micro-build-debug.png)

![](doc/micro-open.png)

![](doc/micro-localhost.png)

![](doc/kill-open-port.png)

## Ref

* https://hub.docker.com/r/linuxserver/code-server
* https://blog.payara.fish/payara-micro-vscode-tooling