FROM java:8u111-alpine
ENV SONAR_SCANNER_VERSION=4.2.0.1873 \
    SONAR_SCANNER_HOME=/opt/sonar-scanner \
    SONAR_SCANNER_OPTS="-Xmx512m"

RUN set -x \
  # Install build depency
  && apk add --no-cache curl sed \
  \
  # Fetch and install sonar scanner
  && curl -fsSLO https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip \
  && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip \
  && mkdir /opt \
  && mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux $SONAR_SCANNER_HOME \
  && rm -rf $SONAR_SCANNER_HOME/jre/ \
  \
  #   ensure Sonar uses the provided Java for musl instead of a borked glibc one \
  && sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONAR_SCANNER_HOME/bin/sonar-scanner \
  \
  # Remove zip files
  && rm sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip \
  \
  # Remove files for windows
  && rm -rf $SONAR_SCANNER_HOME/bin/*.bat \
  \
  # Create symlinks
  && ln -s $SONAR_SCANNER_HOME/bin/sonar-runner /usr/bin/sonar-runner\
  && ln -s $SONAR_SCANNER_HOME/bin/sonar-scanner /usr/bin/sonar-scanner \
  && ln -s $SONAR_SCANNER_HOME/bin/sonar-scanner-debug /usr/bin/sonar-scanner-debug \
  \
  # Remove build dependency
  && apk del curl \
  && apk del sed
