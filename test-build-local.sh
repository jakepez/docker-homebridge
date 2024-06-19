#! /bin/sh

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

export HOMEBRIDGE_APT_PKG_VERSION=`get_latest_release "homebridge/homebridge-apt-pkg"`
export FFMPEG_VERSION=`get_latest_release "homebridge/ffmpeg-for-homebridge"`

echo HOMEBRIDGE_APT_PKG_VERSION ${HOMEBRIDGE_APT_PKG_VERSION}
echo FFMPEG_VERSION ${FFMPEG_VERSION}

docker build -f ./Dockerfile --build-arg HOMEBRIDGE_APT_PKG_VERSION=${HOMEBRIDGE_APT_PKG_VERSION} --build-arg FFMPEG_VERSION=${FFMPEG_VERSION} -t 'docker-homebridge' .
