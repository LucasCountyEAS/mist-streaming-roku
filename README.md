# Mist Streaming — Roku App

An unofficial Roku channel for [Mist Streaming](https://live.mistwx.com/), letting viewers browse and watch live streams directly on their TV.

This project is a rebrand and rework of the original [WeatherRanch `channels`](https://github.com/weatherranch/channels) Roku app (now defunct), rebuilt to work with Mist Streaming's API instead.

<img width="1280" height="720" alt="Screenshot 2026-07-23 08-34-01" src="https://github.com/user-attachments/assets/05b833ea-5659-499a-9005-61b226aa13ba" />


## Features

- Browse all live Mist Streaming channels, sorted alphabetically
- Channel descriptions and live viewer counts

## Status

This app is **not published on the Roku Channel Store**. It's currently distributed directly to testers via manual sideloading. See below for install instructions.

## Installing Mist Streaming on Your Roku

Since this isn't on the Channel Store, you'll need to install it manually. This takes about 5 minutes and only needs to be done once. Updates will also have to be installed manually.

### Step 1: Enable Developer Mode

1. On your Roku remote, make sure you're on the **Home screen**.
2. Press these buttons in order, with a short pause between each:
   - **Home** (press it **3 times**)
   - **Up** (press it **2 times**)
   - **Right**
   - **Left**
   - **Right**
   - **Left**
   - **Right**
3. A screen called **"Developer Application Installer"** should appear.
4. The first time you do this, it'll ask you to set a **username and password** — the username will already be filled in as `rokudev`. Pick a password and remember it (write it down if needed).
5. This screen will also show your Roku's **IP address**, something like `192.168.1.XX`. Write that down too.

> If you ever restart your Roku and this screen doesn't come back automatically, you can always re-enter developer mode by repeating the button sequence above.

### Step 2: Get the app file

Download the latest `Mist Streaming.zip` from the [Releases](../../releases) page (or from whoever shared this repo with you). Save it to your Downloads folder.

### Step 3: Upload it to your Roku

1. On a computer or phone connected to the **same Wi-Fi network** as your Roku, open a web browser.
2. Go to `http://` followed by the IP address from Step 1 (example: `http://192.168.1.42`).
3. Log in with:
   - Username: `rokudev`
   - Password: whatever you set in Step 1
4. You'll see an **"Application Installer"** page. Look for an **Upload** button or file picker.
5. Select `Mist Streaming.zip` and click **Install**.
6. Give it a few seconds — the Roku screen should switch over and launch Mist Streaming automatically.

### If something goes wrong

- **Can't find the IP address / installer page won't load:** Double-check your computer/phone and Roku are on the same Wi-Fi network.
- **Install fails or app crashes:** Open an issue on this repo (or contact us directly) with a description of what happened — a photo of the error helps.

## Development

This app is built with the Roku SceneGraph SDK (BrightScript, XML). To work on it yourself:

1. Clone this repo
2. Open it in VS Code with the [BrightScript Language extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript)
3. Connect to a Roku device in Developer Mode (see install steps above)
4. Press `F5` to deploy and debug directly on the device

## License

This project is a fork of [weatherranch/channels](https://github.com/weatherranch/channels), licensed under **GPL-3.0**. This fork is distributed under the same license. See [LICENSE](./LICENSE) for details.

## Disclaimer

This is an independent, unofficial project. It is not affiliated with or endorsed by Roku, Inc. Streams and channel content are provided by Mist Streaming; this project only provides the Roku client for browsing and viewing them.

## Contact

Questions or issues:
LucasCountyEAS on Discord or
[lucascountyeas+mist@gmail.com](mailto:lucascountyeas+mist@gmail.com)
