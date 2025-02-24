# Bourne Shell Scripts for macOS Automation

This repository contains useful Bourne Shell (`sh`) scripts to automate common tasks on macOS, improving workflow efficiency.

## 📜 Scripts Included

### 1. `brew_utility.sh` - Homebrew Management Utility  
A script to manage Homebrew packages easily.

#### ✨ Features:
- ✅ **Update Homebrew**
- ✅ **Install packages** (multiple at once)
- ✅ **Uninstall packages**
- ✅ **Check installed packages**
- ✅ **Search for a package**

#### 🚀 Usage:
1. Open a terminal and navigate to the script's location.
2. Make the script executable:
   ```sh
   chmod +x brew_utility.sh
   ```
3. Run the script:
   ```sh
   ./brew_utility.sh
   ```

### 2. `yt_dlp_downloader.sh` - YouTube Video Downloader
A script for downloading YouTube videos and playlists using yt-dlp.

#### ✨ Features:
- 🎥 **Download videos**
- 🔴 **Download live streams**
- 🎵 **Download audio-only files**
- 📂 **Download entire playlists**

#### Prerequisites:

Ensure you have `yt-dlp` installed. Install it via Homebrew if needed:

```sh
brew install yt-dlp
```

#### 🚀 Usage:
1. Navigate to the script’s location.
2. Make it executable:
   ```sh
   chmod +x yt_dlp_downloader.sh
   ```
3. Run the script:
   ```sh
   ./yt_dlp_downloader.sh
   ```
4. Enter the YouTube video or playlist URL when prompted.

#### 📌 Notes:
- These scripts are designed for macOS.
- Make sure brew and yt-dlp are installed for their respective scripts.
- Modify scripts as needed for custom requirements.

Enjoy effortless automation! 🚀 ￼