build:
	docker build . -t payara-ide

UID:=1000
GID:=1000
run:
	docker run \
	-p 9090:9090 \
	-p 8080:8080 \
	-p 5005:5005 \
	-e PUID=${UID} -e PGID=${GID} \
	-u "${UID}:${GID}" \
	-e PASSWORD=password \
	-e SUDO_PASSWORD=password \
	-v ${PWD}/projects:/opt/projects \
	-w /opt/projects \
	--restart unless-stopped \
	payara-ide

template:
	echo Y | \
    mvn archetype:generate -DarchetypeGroupId=fish.payara.maven.archetypes -DarchetypeArtifactId=payara-micro-maven-archetype -DarchetypeVersion=1.0.1 -DgroupId=fish.payara.micro -DartifactId=micro-sample -Dversion=1.0-SNAPSHOT -Dpackage=fish.payara.micro.sample -Darchetype.interactive=false \
    -DoutputDirectory=./projects
