> 💡 This doc is mostly ported from its equivalent in our main repo.

## The Runners

Name  | IP | RAM | SSD | OS / Arch | Physical Location | Provider
| ------------- | ------------- | ------------| ------------| -----------| --------| ------ |
Electrode | 63.135.170.15 | 8GB | 256GB | MacOS Big Sur 11.0 (M1) | Atlanta, GA | [Macstadium](https://macstadium.com)
Electabuzz | 63.135.170.29 | 32GB | 512GB | MacOS Catalina 10.15 (i7) | Atlanta, GA | [Macstadium](https://macstadium.com)

## How do I run a job on a self-hosted runner?

Set `runs-on: [self-hosted, macos, x64|ARM64]` in your job. That's it!

## Should I use self-hosted for my workflow?

- If it's a non-MacOS job, then no since we only support MacOS right now. If it's MacOS, then you should start by trying to make it work on one of our self-hosted runners since it will be infinitely cheaper (we pay per month vs. per job-time) and it will be **~3x faster than Github's macos runners**.
- Meanwhile, self-hosted runners will benefit from longer-lived build caches && goma access, so they will build much faster!!

## Differences between running a job on self-hosted vs. github-hosted?

There are a few gotchas, and blindly moving an existing job over may not work out-of-the-box. Don't fret, typically it just takes a few very minor tweaks to make the job work. Main differences/gotchas:

1. Node is not be installed by default on self-hosted. If you run into a `node not found` error, then you need to install the repo's node version with a single step post-checkout - `fnm install`.
1. Self-hosted boxes have very few baseline software packages installed for you to use by default. The ones in this repo include: `brew, python@3.9, fnm`. This differs wildly from Github boxes, which are crammed chock-full of default software packages (full list here: https://github.com/actions/runner-images/blob/main/images/macos/macos-12-Readme.md). If you want to use software that isn't installed on our base image then you have two options:
    1. Have the job install and uninstall the software package
    1. Install the software on the base box to make it available for all (and update the readme's setup instructions)

## How do I access the box?

See notes in the other repo; use runner names from above

#### VNC access

See notes in the other repo; use runner names from above

## Troubleshooting steps if the runner is offline / not working

See notes in the other repo; use runner names from above

## How to set up a brand new runner (we can have as many as we'd like)

See notes in the other repo; use runner names from above. Changes are:

- Logged in via SSH, no VNC
- Setup a custom `DEVELOPER_DIR` + some `GOMA_`-related env variables; see [`~/.zshrc`](./.zshrc)
  - You will have to remove and unset `DEVELOPER_DIR` after `e build` installs XCode
- Setup a `brew bundle` file vs. individual brew installs: [`~/Brewfile`](./Brewfile)
  - Used [[xfreebird/kcpassword](https://github.com/xfreebird/kcpassword)] to enable auto-login, since no VNC
- Used a custom order:
  - Setup SSH & VNC hardening
  - Then the action service / runner, using [this repo's `runners` link](https://github.com/mightyapp/electron/settings/actions/runners)
  - Then installed Homebrew & auto-login
  - Then linked Python
  - Then power-cycled & made sure the runner was running
  - Skipped installing the x86 homebrew (axbrew)
- Installed our `goma.crt` to `~/workspace/.goma.crt`
- Installed Node.js@14 (LTS was throwing OpenSSL errors) & `yarn` with Corepack: https://yarnpkg.com/getting-started/install

  ```bash
  fnm install 16
  npm i -g corepack
  corepack prepare yarn@3 --activate
  ```

- [arm64] Installed Rosetta because El/Cr needed it during `e build`

  ```bash
  softwareupdate --install-rosetta --agree-to-license
  ```

  - ⚠️ May not be necessary in later El/Cr versions!
- Followed the quickstart process from `mighty/README.md`
  - Used `actions-runner/_work/electron/electron` as the root directory

[More general info on our self-hosted runners](https://docs.google.com/document/d/1C1apeK2CIamzegGMCc6JCkmR6CmmmaTn41UyShBBFKM/edit?usp=sharing)
