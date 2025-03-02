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


# How to Run Shell Scripts from Anywhere

This guide explains how to set up and run `.sh` (shell script) files from any location in the terminal.

## 📁 Project Structure

Assuming your shell scripts are stored in the following directory:

```bash
~/Documents/GitHub/Bourne-Shell-Scripts
```
Example files:
- `brew_utility.sh`
- `yt_dlp_downloader.sh`

---

## 🛠️ Step-by-Step Setup

### 1. Make Scripts Executable

Before running your scripts, make them executable using the `chmod` command:

```bash
chmod +x ~/Documents/GitHub/Bourne-Shell-Scripts/*.sh
```

### 2. Add the Directory to Your `PATH`

To execute the scripts from anywhere, add their directory to your system's `PATH`. Open your `.zshrc` file using a text editor:

```bash
nano ~/.zshrc
```

Add the following line to the end of the file:

```bash
export PATH=$PATH:~/Documents/GitHub/Bourne-Shell-Scripts
```

### 3. Reload Your Shell Configuration

To apply the changes, restart your terminal or run:

```bash
source ~/.zshrc
```

### 4. Verify the `PATH`

Check if the directory is correctly added to your `PATH`:

```bash
echo $PATH
```

You should see the directory in the output, like this:

```
...:/Users/dadaniru/Documents/GitHub/Bourne-Shell-Scripts
```

### 5. Test Your Scripts

Verify that your scripts can be executed from any directory:

```bash
which yt_dlp_downloader.sh
```

If everything is set up correctly, this will return the full path to your script:

```
/Users/YOUR_USERNAME/Documents/GitHub/Bourne-Shell-Scripts/yt_dlp_downloader.sh
```

### 6. Run Your Script from Anywhere

Now you can run your script simply by typing its name:

```bash
yt_dlp_downloader.sh
```

If the script requires input, it will prompt you as expected:

```bash
Enter the YouTube video or playlist URL:
```

---

## 🚧 Troubleshooting

### 1. `command not found` Error

If you get a `command not found` error, double-check that:

- The script is executable (`chmod +x your_script.sh`)
- The `PATH` variable is correctly set (`echo $PATH`)

### 2. Suspended Script

If your script gets suspended (e.g., `zsh: suspended`), try running it with:

```bash
bash yt_dlp_downloader.sh
```

or bring it back to the foreground using:

```bash
fg
```

---

## ✅ Additional Tips

- Avoid naming your scripts with names that conflict with existing system commands.
- Check for conflicts using:

```bash
which script_name
```

Happy scripting! 🚀