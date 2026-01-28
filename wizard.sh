#!/usr/bin/env bash
ARCH=$(uname -m)

declare -A AVAILABLE_ARCHES

AVAILABLE_ARCHES["x86_64"]="amd64"
AVAILABLE_ARCHES["i386"]="386"
AVAILABLE_ARCHES["aarch64"]="arm64"
AVAILABLE_ARCHES["armv6l"]="armv6l"

CMD=$1
version=$2

LIST="list"
USE="use"
INSTALL="install"

if [[ -z "${AVAILABLE_ARCHES[$ARCH]}" ]]; then
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

if [[ -z "$GOPATH" ]]; then
    echo 'GOPATH="$HOME/.wizard/go"' >> "$HOME/.bashrc"
    echo 'GOBIN="$HOME/.wizard/go/bin"' >> "$HOME/.bashrc"
    echo 'PATH="$PATH:$GOBIN"' >> "$HOME/.bashrc"
    echo "Run 'source ~/.bashrc' or restart your shell to apply changes"
fi

if [ ! -d "$HOME/.wizard" ]; then
    echo "go store in $HOME/.wizard"
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
    if [[ -z "$version" ]]; then
        echo "Version is required"
        exit 1
    fi
    wget "https://go.dev/dl/go$version.linux-${AVAILABLE_ARCHES[$ARCH]}.tar.gz"
    tar -xf "go$version.linux-${AVAILABLE_ARCHES[$ARCH]}.tar.gz" && rm -rf "go$version.linux-${ARCHS[$ARCH]}.tar.gz"
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

