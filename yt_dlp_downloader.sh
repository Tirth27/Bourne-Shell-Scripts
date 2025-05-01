#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Prompt user for video or playlist link
echo -e "${YELLOW}Enter the YouTube video or playlist URL:${NC}"
read VIDEO_URL

# Ask user for the type of download
echo -e "${YELLOW}Select download type:${NC}"
echo -e "${GREEN}1) Regular video${NC}"
echo -e "${GREEN}2) Live stream${NC}"
echo -e "${GREEN}3) Audio only${NC}"
echo -e "${GREEN}4) Entire playlist${NC}"
echo -e "${GREEN}5) Best possible format${NC}"
echo -e "${GREEN}6) Download subtitles only (English, Gujarati, Hindi)${NC}"
echo -e "${GREEN}7) Extract video chapters to JSON${NC}"
read DOWNLOAD_TYPE

# Create Downloads/YT-DLP folder if it doesn't exist
DOWNLOAD_PATH="$HOME/Downloads/YT-DLP"
mkdir -p "$DOWNLOAD_PATH"

# Live Stream
if [ "$DOWNLOAD_TYPE" == "2" ]; then
    # Download live stream from start
    echo -e "${BLUE}Downloading live stream...${NC}"
    yt-dlp -f bestvideo+bestaudio --merge-output-format mp4 --live-from-start -o "$DOWNLOAD_PATH/%(title)s_LIVE.%(ext)s" "$VIDEO_URL"
# Audio Only
elif [ "$DOWNLOAD_TYPE" == "3" ]; then
    # Display available audio formats
    echo -e "${YELLOW}Fetching available audio formats...${NC}"
    yt-dlp -F "$VIDEO_URL" | grep "audio"
    
    # Prompt user for audio format ID
    echo -e "${YELLOW}Enter the audio format ID you want to download:${NC}"
    read AUDIO_ID
    
    # Download selected audio format with highest bitrate
    echo -e "${BLUE}Downloading selected audio format...${NC}"
    yt-dlp -f "$AUDIO_ID" --extract-audio --audio-format mp3 -o "$DOWNLOAD_PATH/%(title)s.%(ext)s" "$VIDEO_URL"
# Entire Playlist
elif [ "$DOWNLOAD_TYPE" == "4" ]; then
	# Extract first video URL from playlist safely
    FIRST_VIDEO_URL=$(yt-dlp --flat-playlist --playlist-items 1 --print-json "$VIDEO_URL" | jq -r '.url')
    
    if [ -z "$FIRST_VIDEO_URL" ]; then
        echo -e "${RED}Error retrieving the first video URL from the playlist.${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Fetching available formats for the first video in the playlist...${NC}"
    yt-dlp -F "$FIRST_VIDEO_URL"
    
    # Prompt user for video format ID
    echo -e "${YELLOW}Enter the video format ID you want to download for the playlist:${NC}"
    read VIDEO_ID
    
    # Prompt user for audio format ID
    echo -e "${YELLOW}Enter the audio format ID you want to download for the playlist:${NC}"
    read AUDIO_ID
    
    # Download entire playlist in parallel with selected formats
    echo -e "${BLUE}Downloading entire playlist with selected formats in parallel...${NC}"
    yt-dlp -f "$VIDEO_ID+$AUDIO_ID" --merge-output-format mp4 -o "$DOWNLOAD_PATH/%(playlist_title)s/%(title)s.%(ext)s" "$VIDEO_URL" --concurrent-fragments 10
# Best Possible Format
elif [ "$DOWNLOAD_TYPE" == "5" ]; then
    echo -e "${BLUE}Downloading the best available format...${NC}"
    yt-dlp -f "bv*+ba/b" --merge-output-format mp4 -o "$DOWNLOAD_PATH/%(title)s_BEST.%(ext)s" "$VIDEO_URL"
# Download Subtitles Only
# https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#subtitle-options
elif [ "$DOWNLOAD_TYPE" == "6" ]; then
    echo -e "${BLUE}Downloading subtitles in separate language folders...${NC}"
    
    # Create language-specific directories
    LANGUAGES=("en" "gu" "hi")
    VIDEO_TITLE=$(yt-dlp --get-filename -o "%(title)s" "$VIDEO_URL" 2>/dev/null)

    # List all available subtitles
    echo -e "${YELLOW}Available subtitles for the video:${NC}"
    yt-dlp --list-subs "$VIDEO_URL"

    # Download each language subtitle separately
    for LANG in "${LANGUAGES[@]}"; do
        # Create language directory
        LANG_DIR="$DOWNLOAD_PATH/$LANG"
        mkdir -p "$LANG_DIR"
        
        echo -e "${YELLOW}Downloading ${LANG} subtitles...${NC}"
        yt-dlp --write-subs --sub-lang "$LANG" --skip-download -o "$LANG_DIR/%(title)s_subtitles.%(ext)s" "$VIDEO_URL"
        yt-dlp --write-auto-sub --sub-lang "$LANG" --skip-download -o "$LANG_DIR/%(title)s_auto_subtitles.%(ext)s" "$VIDEO_URL"
    done
    echo -e "${GREEN}Subtitle download process completed${NC}"
# Extract Video Chapters
elif [ "$DOWNLOAD_TYPE" == "7" ]; then
    echo -e "${BLUE}Extracting video chapters to JSON...${NC}"
    
    # Get video ID and title
    VIDEO_ID=$(yt-dlp --get-id "$VIDEO_URL")
    ORIGINAL_TITLE=$(yt-dlp --get-filename -o "%(title)s" "$VIDEO_URL")
    
    # Create subdirectories for organized storage
    RAW_DIR="$DOWNLOAD_PATH/Raw"
    CHAPTERS_DIR="$DOWNLOAD_PATH/Chapters"
    mkdir -p "$RAW_DIR" "$CHAPTERS_DIR"
    
    # Use video title for filename which is guaranteed to be filesystem-safe
    JSON_FILE="$RAW_DIR/${ORIGINAL_TITLE}.json"
    CHAPTERS_FILE="$CHAPTERS_DIR/${ORIGINAL_TITLE}.json"
    
    # Check if jq is installed for pretty formatting
    if command -v jq &> /dev/null; then
        # Full JSON dump
        yt-dlp --dump-json --skip-download "$VIDEO_URL" | jq > "$JSON_FILE"
        
        # Extract just the chapters to a separate file
        yt-dlp --dump-json --skip-download "$VIDEO_URL" | jq '.chapters' > "$CHAPTERS_FILE"
    else
        echo -e "${YELLOW}jq is not installed. Cannot extract chapters separately.${NC}"
        echo -e "${YELLOW}Installing full JSON dump only.${NC}"
        yt-dlp --dump-json --skip-download "$VIDEO_URL" > "$JSON_FILE"
    fi
    
    if [ -f "$JSON_FILE" ]; then
        echo -e "${GREEN}Full JSON data extracted successfully to: $JSON_FILE${NC}"
        
        if [ -f "$CHAPTERS_FILE" ]; then
            echo -e "${GREEN}Chapters extracted separately to: $CHAPTERS_FILE${NC}"
        else
            echo -e "${RED}Failed to extract chapters to separate file.${NC}"
        fi
        
        echo -e "${BLUE}Video title: $ORIGINAL_TITLE${NC}"
        echo -e "${BLUE}Video ID: $VIDEO_ID${NC}"
    else
        echo -e "${RED}Failed to extract video data.${NC}"
    fi
# Regular Video (Default)
else
    # Display available formats
    echo -e "${YELLOW}Fetching available formats...${NC}"
    yt-dlp -F "$VIDEO_URL"
    
    # Prompt user for video format ID
    echo -e "${YELLOW}Enter the video format ID you want to download:${NC}"
    read VIDEO_ID
    
    # Prompt user for audio format ID
    echo -e "${YELLOW}Enter the audio format ID you want to download:${NC}"
    read AUDIO_ID
    
    # Download and merge video and audio
    echo -e "${BLUE}Downloading and merging selected formats...${NC}"
    yt-dlp -f "$VIDEO_ID+$AUDIO_ID" --merge-output-format mp4 -o "$DOWNLOAD_PATH/%(title)s.%(ext)s" "$VIDEO_URL" --concurrent-fragments 10
fi

echo -e "${GREEN}Download complete! Files saved to $DOWNLOAD_PATH${NC}"

# Clean up intermediate files
CACHE_PATH="$HOME/Library/Caches/yt-dlp"
if [ -d "$CACHE_PATH" ]; then
    rm -rf "$CACHE_PATH"
    echo -e "${RED}Intermediate files have been cleaned up.${NC}"
fi
