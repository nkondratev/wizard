#!/usr/bin/env bash
ARCH=$(uname -m)

declare -A ARCHS

ARCHS["x86_64"]="amd64"
ARCHS["i386"]="386"
ARCHS["aarch64"]="arm64"
ARCHS["armv6l"]="armv6l"

CMD=$1
version=$2

LIST="list"
USE="use"
INSTALL="install"

if [[ -z "${ARCHS[$ARCH]}" ]]; then
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

if [[ -z "$GOPATH" ]]; then
    echo 'GOPATH="$HOME/.wizard/go"' >> "$HOME/.bashrc"
    echo 'GOBIN="$HOME/.wizard/go/bin"' >> "$HOME/.bashrc"
    echo 'PATH="$PATH:$GOBIN"' >> "$HOME/.bashrc"
fi

if [ ! -d "$HOME/.wizard" ]; then
    mkdir -p $HOME/.wizard/bin
    mkdir -p $HOME/.wizard/versions

fi

printInfo() {
    cat << EOF
This tool for manage golang versions
use next commands:
install <version> - use to install certain version golang.
Example: wizard install 1.25.5
use <version> - use to choose golang version:
list - show all commands:
EOF
}

case $CMD in
    $INSTALL)
    wget "https://go.dev/dl/go$version.linux-${ARCHS[$ARCH]}.tar.gz"
    tar -xf "go$version.linux-${ARCHS[$ARCH]}.tar.gz" && rm -rf "go$version.linux-${ARCHS[$ARCH]}.tar.gz"
    mv --force go $HOME/.wizard/versions/go$version
    ;;
    $USE)
    ln -sf $HOME/.wizard/versions/go$2/bin/go $HOME/.wizard/bin/go
    ;;
    $LIST)
    printInfo
    *)
    printInfo
    ;;

esac




