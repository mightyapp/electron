export PATH=/opt/homebrew/bin:/usr/local/bin:${HOME}/.electron_build_tools/third_party/depot_tools/:$PATH
# n.b. remove this after `e build` installs XCode for you
export DEVELOPER_DIR=/Library/Developer/CommandLineTools

export GOMA_SERVER_HOST=ametrine.goma.engflow.com
export GOMA_SSL_EXTRA_CERT=${HOME}/workspace/.goma.crt
export GOMACTL_USE_PROXY=false

eval "$(fnm env)"
