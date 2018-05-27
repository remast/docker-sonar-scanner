FROM java:8u111-alpine

ENV SONAR_SCANNER_VERSION=3.2.0.1227 \
    SONAR_SCANNER_HOME=/opt/sonar-scanner \
    SONAR_SCANNER_OPTS="-Xmx512m"

RUN set -x \
  # Install build depency
  && apk add --no-cache curl \
  \
  # Fetch and install sonar scanner
  && curl -fsSLO https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip \
  && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip \
  && mkdir /opt \
  && mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux $SONAR_SCANNER_HOME \
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
  && apk del curl
