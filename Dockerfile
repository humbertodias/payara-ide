FROM codercom/code-server:latest

# root 
USER root
RUN apt update && apt install -y zip unzip curl jq netcat lsof socat && \
	rm -rf /var/lib/apt/lists/* /tmp/*
RUN chown -R coder:coder /opt \
 && sudo adduser coder sudo \
 && mkdir /opt/repository

# Non root
USER coder

# Payara Server
ENV PAYARA_VERSION 5.2020.5
ENV PAYARA_HOME /opt/payara-server
RUN cd /opt \
    && curl -L https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/${PAYARA_VERSION}/payara-${PAYARA_VERSION}.zip -o payara-server.zip \
    && unzip payara-server.zip \
    && ln -s /opt/payara5 ${PAYARA_HOME} \
    && rm payara-server.zip
ENV PATH ${PATH}:${PAYARA_HOME}/bin

# VSCode extensions
ENV VSCODE_PAYARA_VERSION 0.0.4
RUN cd /opt \
    && curl -L https://github.com/payara/ecosystem-vscode-plugin/releases/download/${VSCODE_PAYARA_VERSION}/payara-vscode-${VSCODE_PAYARA_VERSION}.vsix -o payara-vscode-${VSCODE_PAYARA_VERSION}.vsix \
    && code-server --install-extension payara-vscode-${VSCODE_PAYARA_VERSION}.vsix \
    && rm payara-vscode-${VSCODE_PAYARA_VERSION}.vsix
    
# Putting debug mode in background
RUN sed -i 's/suspend=y/suspend=n/g' ~/.local/share/code-server/extensions/payara.payara-vscode-${VSCODE_PAYARA_VERSION}/out/main/fish/payara/project/Gradle.js \
 && sed -i 's/suspend=y/suspend=n/g' ~/.local/share/code-server/extensions/payara.payara-vscode-${VSCODE_PAYARA_VERSION}/out/main/fish/payara/project/Maven.js

RUN code-server --install-extension vscjava.vscode-java-pack \
&&  code-server --install-extension ms-azuretools.vscode-docker

# Bash
RUN echo "alias ll='ls -lha --color'" >> $HOME/.bash_aliases \
 && echo "alias kill-port='_killByPort(){ lsof -t -i:$1 | xargs kill; }; _killByPort'" >> $HOME/.bash_aliases 

# SDKMAN 
RUN curl -s "https://get.sdkman.io" | bash
ENV GRADLE_VERSION 6.7
ENV MAVEN_VERSION 3.6.3
ENV JAVA_VERSION 8.0.265.hs-adpt
#ENV JAVA_VERSION 14.0.2.hs-adpt
ENV HOME /home/coder

ENV SDKMAN_DIR $HOME/.sdkman
RUN bash -c "source $SDKMAN_DIR/bin/sdkman-init.sh && \
    yes | sdk install gradle $GRADLE_VERSION && \
    yes | sdk install maven $MAVEN_VERSION && \
    yes | sdk install java $JAVA_VERSION && \
    rm -rf $SDKMAN_DIR/archives/* && \
    rm -rf $SDKMAN_DIR/tmp/*"

ENV JAVA_HOME ${SDKMAN_DIR}/candidates/java/current
ENV MAVEN_HOME ${SDKMAN_DIR}/candidates/maven/current
ENV GRADLE_HOME ${SDKMAN_DIR}/candidates/gradle/current
ENV PATH ${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${GRADLE_HOME}/bin:${PATH}

# workaround for the discovery of java path by VSCode
RUN sudo ln -s ${JAVA_HOME}/bin/java /usr/bin/java \
 && sudo ln -s ${JAVA_HOME}/bin/jps /usr/bin/jps \
 && sudo ln -s ${MAVEN_HOME}/bin/java /usr/bin/mvn \
 && sudo ln -s ${GRADLE_HOME}/bin/java /usr/bin/gradle

ADD settings.json $HOME/.local/share/code-server/User/settings.json

EXPOSE 5005 8080 8443 9090
CMD ["--bind-addr", "0.0.0.0:9090"]