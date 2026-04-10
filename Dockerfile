FROM eclipse-temurin:25-jre

LABEL maintainer="thoevers"

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="craumix/jmusicbot"
LABEL org.label-schema.description="Java based Discord music bot"
LABEL org.label-schema.url="https://github.com/arif-banai/MusicBot"
LABEL org.label-schema.vcs-url="https://github.com/Snailpower/jmb-container"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.docker.cmd="docker run -v ./config:/jmb/config -d thoevers/jmusicbot"

RUN apt-get update && apt-get install -y --no-install-recommends \
    tini \
    && rm -rf /var/lib/apt/lists/*

#No downloadable example config since 0.2.10
RUN mkdir -p /jmb/config
ADD --chmod=644 https://github.com/arif-banai/MusicBot/releases/download/v0.6.2/JMusicBot-0.6.2.jar /jmb/JMusicBot.jar
ADD --chmod=644 https://github.com/jagrosh/MusicBot/releases/download/0.2.9/config.txt /jmb/config/config.txt

COPY --chmod=755 ./docker-entrypoint.sh /jmb

VOLUME /jmb/config

RUN groupadd -r appgroup -g 10001 && \
    useradd -r -g appgroup -u 10000 appuser

USER appuser

WORKDIR /jmb/config

ENTRYPOINT ["/usr/bin/tini", "--", "/jmb/docker-entrypoint.sh"]
