# Konekin

Konekin is a macOS menu bar application that simplifies reverse tethering for Android devices. It allows you to share your Mac's internet connection with your Android device via USB, powered by [Gnirehtet](https://github.com/Genymobile/gnirehtet).

## Features

- **Menu Bar Interface**: Easy access to connection controls and status.
- **Reverse Tethering**: Share your Mac's internet with connected Android devices.
- **Auto-Connect**: Option to automatically connect to new devices when detected.
- **Multi-Device Support**: Select which device to share internet with if multiple are connected.
- **ADB Management**: Built-in tools to restart or kill the ADB server.
- **Privacy Awareness**: Includes warnings about network monitoring on public networks.

## Prerequisites

- macOS 11.0 or later.
- Android device with **USB Debugging** enabled.
- USB cable.

## Installation & Build

1.  Clone the repository:
    ```bash
    git clone <repository-url>
    cd Konekin
    ```

2.  Build the application using the included script:
    ```bash
    ./build.sh
    ```

3.  The app will be built in the `build/` directory. You can run it directly:
    ```bash
    open build/Konekin.app
    ```

## Usage

1.  Connect your Android device via USB.
2.  Launch **Konekin**.
3.  Click the Konekin icon in the menu bar.
4.  Select **Start on [Device Model]**.
5.  Accept the privacy warning to start sharing.
6.  A VPN request will appear on your Android device; accept it to enable the connection.

## Privacy Warning

When using this tool, network activity from your mobile device is routed through your computer. On public or corporate networks, this traffic may be visible to network administrators. Please be mindful of your data privacy in such environments.

## Credits

- This app uses [Gnirehtet](https://github.com/Genymobile/gnirehtet) by Genymobile for the core reverse tethering functionality.
