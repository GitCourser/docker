# syntax=docker/dockerfile:experimental

ARG BASEIMAGE=arm64v8/ubuntu
ARG BASETAG=20.04

ARG ARG_MERGE_STAGE_VNC_BASE=stage_novnc
ARG ARG_MERGE_STAGE_BROWSER_BASE=merge_stage_vnc
ARG ARG_FINAL_STAGE_BASE=merge_stage_browser


###############
### stage_cache
###############

FROM ${BASEIMAGE}:${BASETAG} as stage_cache

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN apt-get update


####################
### stage_essentials
####################

FROM ${BASEIMAGE}:${BASETAG} as stage_essentials

COPY qemu-aarch64-static /user/bin

SHELL ["/bin/bash", "-c"]

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        jq \
        nano \
        psmisc \
        sudo \
        tini \
        wget


#################
### stage_xserver
#################

FROM stage_essentials as stage_xserver
ARG ARG_APT_NO_RECOMMENDS

ENV \
    FEATURES_BUILD_SLIM_XSERVER=${ARG_APT_NO_RECOMMENDS:+1} \
    NO_AT_BRIDGE=1

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${ARG_APT_NO_RECOMMENDS:+--no-install-recommends} \
        dbus-x11 \
        xauth \
        xinit \
        x11-xserver-utils \
        xdg-utils


##############
### stage_xfce
##############

FROM stage_xserver as stage_xfce
ARG ARG_APT_NO_RECOMMENDS

ENV FEATURES_BUILD_SLIM_XFCE=${ARG_APT_NO_RECOMMENDS:+1}

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${ARG_APT_NO_RECOMMENDS:+--no-install-recommends} \
        xfce4 \
        xfce4-terminal


###############
### stage_tools
###############

FROM stage_xfce as stage_tools
ARG ARG_APT_NO_RECOMMENDS

ENV \
    FEATURES_BUILD_SLIM_TOOLS=${ARG_APT_NO_RECOMMENDS:+1} \
    TZ=Asia/Shanghai

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${ARG_APT_NO_RECOMMENDS:+--no-install-recommends} \
        mousepad \
        fonts-wqy-microhei \
        python3 \
        systemctl \
        tzdata \
        && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
        && echo ${TZ} > /etc/timezone \
        && dpkg-reconfigure --frontend noninteractive tzdata

#############
### stage_vnc
#############

FROM stage_tools as stage_vnc
ARG ARG_VNC_COL_DEPTH
ARG ARG_VNC_DISPLAY
ARG ARG_VNC_PORT
ARG ARG_VNC_PW
ARG ARG_VNC_RESOLUTION
ARG ARG_VNC_VIEW_ONLY

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y x11-utils libfontenc1 libgl1-mesa-dri libxfont-dev libxtst6 libglu1-mesa \
    && wget -nd -P /var/cache/apt https://sourceforge.net/projects/tigervnc/files/stable/1.12.0/ubuntu-20.04LTS/arm64/tigervncserver_1.12.0-1ubuntu1_arm64.deb \
    && dpkg -i /var/cache/apt/tigervncserver_1.12.0-1ubuntu1_arm64.deb \
    && ln -s /usr/lib/aarch64-linux-gnu/tigervncserver /usr/bin/vncserver \
    && sed -i 's/exec(@cmd);/print "@cmd";\nexec(@cmd);/g' /usr/lib/aarch64-linux-gnu/tigervncserver

ENV \
    DISPLAY=${ARG_VNC_DISPLAY:-:1} \
    FEATURES_VNC=1 \
    VNC_COL_DEPTH=${ARG_VNC_COL_DEPTH:-24} \
    VNC_PORT=${ARG_VNC_PORT:-5901} \
    VNC_PW=${ARG_VNC_PW:-headless} \
    VNC_RESOLUTION=${ARG_VNC_RESOLUTION:-1360x768} \
    VNC_VIEW_ONLY=${ARG_VNC_VIEW_ONLY:-false}

EXPOSE ${VNC_PORT}


###############
### stage_novnc
###############

FROM stage_vnc as stage_novnc
ARG ARG_APT_NO_RECOMMENDS
ARG ARG_NO_VNC_PORT

ENV \
    FEATURES_BUILD_SLIM_NOVNC=${ARG_APT_NO_RECOMMENDS:+1} \
    FEATURES_NOVNC=1 \
    NO_VNC_HOME=/usr/aarch64-linux-gnu/noVNCdim \
    NO_VNC_PORT=${ARG_NO_VNC_PORT:-6901}

RUN \
    mkdir -p "${NO_VNC_HOME}"/utils/websockify \
    && wget -qO- https://github.com/novnc/noVNC/archive/v1.3.0.tar.gz | tar xz --strip 1 -C "${NO_VNC_HOME}" \
    && wget -qO- https://github.com/novnc/websockify/archive/v0.10.0.tar.gz | tar xz --strip 1 -C "${NO_VNC_HOME}"/utils/websockify \
    && chmod +x -v "${NO_VNC_HOME}"/utils/novnc_proxy

### add 'index.html' for choosing noVNC client
RUN echo -e \
"<!DOCTYPE html>\n" \
"<html>\n" \
"    <head>\n" \
"        <title>noVNC</title>\n" \
"        <meta charset=\"utf-8\"/>\n" \
"    </head>\n" \
"    <body>\n" \
"        <p><a href=\"vnc_lite.html\">noVNC Lite Client</a></p>\n" \
"        <p><a href=\"vnc.html\">noVNC Full Client</a></p>\n" \
"    </body>\n" \
"</html>" \
> "${NO_VNC_HOME}"/index.html

EXPOSE ${NO_VNC_PORT}


###################
### merge_stage_vnc
###################

FROM ${ARG_MERGE_STAGE_VNC_BASE} as merge_stage_vnc
ARG ARG_HEADLESS_USER_NAME
ARG ARG_HOME

ENV HOME=${ARG_HOME:-/home/${ARG_HEADLESS_USER_NAME:-headless}}

WORKDIR ${HOME}


##################
### stage_chromium
##################

# FROM merge_stage_vnc as stage_chromium



#######################
### merge_stage_browser
#######################

FROM ${ARG_MERGE_STAGE_BROWSER_BASE} as merge_stage_browser


###############
### FINAL STAGE
###############

FROM ${ARG_FINAL_STAGE_BASE} as stage_final
# ARG ARG_FEATURES_USER_GROUP_OVERRIDE
ARG ARG_HEADLESS_USER_NAME
ARG ARG_SUDO_PW

ENV \
    # FEATURES_USER_GROUP_OVERRIDE=${ARG_FEATURES_USER_GROUP_OVERRIDE:+1} \
    FEATURES_VERSION_STICKER=1 \
    STARTUPDIR=/dockerstartup

COPY ./src/xfce-startup "${STARTUPDIR}"/

COPY ./xfce/src/home/config "${HOME}"/.config/
COPY ./xfce/src/home/Desktop "${HOME}"/Desktop/
COPY ./xfce/src/home/readme*.md "${HOME}"/

### Create the default application user (non-root, but member of the group zero)
### and allow the group zero to modify '/etc/passwd' and '/etc/group'.
### Providing the build argument ARG_SUPPORT_USER_GROUP_OVERRIDE (set to anything) allows any user
### to modify both files and makes user group overriding possible (like 'run --user x:y').
RUN \
    chmod 664 /etc/passwd /etc/group \
    && echo "${ARG_HEADLESS_USER_NAME:-headless}:x:1001:0:Default:${HOME}:/bin/bash" >> /etc/passwd \
    && adduser "${ARG_HEADLESS_USER_NAME:-headless}" sudo \
    && echo "${ARG_HEADLESS_USER_NAME:-headless}:${ARG_SUDO_PW:-${VNC_PW}}" | chpasswd \
    # && ${ARG_FEATURES_USER_GROUP_OVERRIDE/*/chmod a+w /etc/passwd /etc/group} \
    && ln -s "${HOME}"/readme.md "${HOME}"/Desktop/README \
    && chmod 755 -R "${STARTUPDIR}" \
    && "${STARTUPDIR}"/set_user_permissions.sh "${STARTUPDIR}" "${HOME}" \
    && rm -rf /var/lib/apt/lists/*

USER 1001

ENTRYPOINT [ "/usr/bin/tini", "--", "/dockerstartup/startup.sh" ]
# ENTRYPOINT [ "/usr/bin/tini", "--", "tail", "-f", "/dev/null" ]
