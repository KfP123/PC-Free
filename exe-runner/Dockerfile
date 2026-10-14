# EXE Runner: a web desktop (Selkies) that runs Windows .exe files with Wine.
# On ARM64 servers (Oracle Ampere) Wine comes from Hangover, which translates
# x86 code with FEX/Box64. On x86_64 hosts it uses Ubuntu's regular Wine.
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

ARG TARGETARCH
ARG HANGOVER_VERSION=11.16

ENV TITLE="EXE Runner" \
    WINEDEBUG=-all

RUN set -eux; \
    apt-get update; \
    if [ "$TARGETARCH" = "arm64" ]; then \
      mkdir -p /tmp/hangover; \
      curl -fsSL -o /tmp/hangover.tar \
        "https://github.com/AndreRH/hangover/releases/download/hangover-${HANGOVER_VERSION}/hangover_${HANGOVER_VERSION}_ubuntu2404_noble_arm64.tar"; \
      tar -xf /tmp/hangover.tar -C /tmp/hangover; \
      apt-get install -y --no-install-recommends /tmp/hangover/*.deb; \
    else \
      dpkg --add-architecture i386; \
      apt-get update; \
      apt-get install -y --no-install-recommends wine wine64 wine32:i386; \
    fi; \
    apt-get install -y --no-install-recommends cabextract unzip xz-utils; \
    # Pre-install the Wine Mono version this Wine expects, so .NET programs work
    # and first-time setup doesn't stop at a download prompt.
    appwiz="$(find /usr/lib -name appwiz.cpl -path '*wine*' | head -n1)"; \
    mono_ver="$(tr -d '\000' < "$appwiz" | grep -aoE 'wine-mono-[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | sed 's/wine-mono-//')"; \
    mono_arch="x86"; [ "$TARGETARCH" = "arm64" ] && mono_arch="arm64"; \
    mkdir -p /usr/share/wine/mono; \
    curl -fsSL "https://dl.winehq.org/wine/wine-mono/${mono_ver}/wine-mono-${mono_ver}-${mono_arch}.tar.xz" \
      | tar -xJ -C /usr/share/wine/mono; \
    curl -fsSL -o /usr/local/bin/winetricks \
      https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks; \
    chmod +x /usr/local/bin/winetricks; \
    apt-get clean; \
    rm -rf /tmp/* /var/lib/apt/lists/*

COPY root/ /
