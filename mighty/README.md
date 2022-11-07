# MgElectron

## Quickstart

- Ensure your env has the expected `goma` settings; see [`self-hosted-runner/.zshrc`](../.github/self-hosted-runner/.zshrc)
- Ensure Node.js, Python3.9, yarn, and jq are installed
- Ensure `which python` (+ any symlinks) resolves to a python3 (e.g. `/usr/local/bin/python3.9`)
- Run the following script to install `@electron/build-tools` and set up our workspace:

  ```bash
  npm i -g @electron/build-tools
  e init -r ~/workspace/electron -i release --fork mightyapp/electron release
  jq '.remotes.electron.origin = .remotes.electron.fork|del(.remotes.electron.fork)|.gen.args[.gen.args|length] |= "symbol_level = 1"|.gen.args[.gen.args|length] |= "blink_symbol_level = 1"' \
    ~/.electron_build_tools/configs/evm.release.json > ~/.electron_build_tools/configs/evm.release.json.tmp
  mv ~/.electron_build_tools/configs/evm.release.json.tmp ~/.electron_build_tools/configs/evm.release.json
  sed -i.bak 's/electron\/electron/mightyapp\/electron/' ~/workspace/electron/.gclient
  rm ~/workspace/electron/.gclient.bak
  mkdir -p ~/workspace/electron/src
  git clone -b aidan/rebase-15-x-y git@github.com:mightyapp/electron.git ~/workspace/electron/src/electron
  ```

  - ⚠️ Keep the `-b` argument above up-to-date with our default branch!!
- If you are using goma (recommended):
  - Ensure...
  - Run `goma_auth login` on the machine you will be building with
    - ⚠️ On self-hosted runners, you will need to set up two SSH port forwarding hops
      using the provided port numbers: one from your client to the bastion; and one
      from the bastion to the self-hosted runner:

      ```bash
      # on your macbook
      ssh -L $PORT:localhost:$PORT [rest of bastion invocation]

      # on bastion
      ssh -L $PORT:localhost:$PORT $SERVER_NAME
      ```

- Run your first `e sync && e build`
  - ⚠️ On self-hosted runners, your first `e build` run may throw an error.
    If it does, (1) remove the `DEVELOPER_DIR` line from `~/.zshrc`; and (2)
    run `unset DEVELOPER_DIR`.
