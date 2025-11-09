#!/bin/bash
set -euxo pipefail

# Variables
GO_VERSION="1.25.1"
TASK_VERSION="3.45.4"
GITLEAKS_VERSION="8.29.0"
TRIVY_VERSION="0.67.2"


main() {
    init
    install_go
    install_go_task
    install_gitleaks
    install_trivy
}

init() {
    apt update -y \
        && apt upgrade -y

    apt install -y curl git make
}

install_go() {
    curl -OL "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" \
        && rm -rf /usr/local/go \
        && tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    rm -rf go${GO_VERSION}.linux-amd64.tar.gz
    echo "PATH=\"$PATH:/usr/local/go/bin\"" >> ~/.bashrc
}

install_go_task() {
    sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin "v${TASK_VERSION}"
}

install_gitleaks() {
    git clone  --depth 1 --branch "v${GITLEAKS_VERSION}" https://github.com/gitleaks/gitleaks.git\
        && cd gitleaks \
        && make build \
        && mv ./gitleaks /usr/local/bin \
        && cd ../
    rm -rf gitleaks
}

install_trivy() {
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
        |  sh -s -- -b /usr/local/bin "v${TRIVY_VERSION}"
}

main "$@"