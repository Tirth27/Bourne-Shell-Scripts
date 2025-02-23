#!/bin/bash

# Function to update Homebrew
update_homebrew() {
    echo "🔄 Updating Homebrew..."
    brew update
    echo "✅ Homebrew updated!"
}

# Function to install one or multiple Homebrew packages
install_brew_packages() {
    read -p "Enter Homebrew packages to install (separate multiple with space): " packages

    for package in $packages; do
        if brew list --formula | grep -q "^$package\$"; then
            echo "✅ Package '$package' is already installed."
        else
            echo "📦 Installing '$package'..."
            brew install "$package"
            echo "✅ '$package' installed successfully!"
        fi
    done
}

# Function to uninstall a Homebrew package
uninstall_brew_package() {
    read -p "❌ Enter the package name to uninstall: " package
    if brew list --formula | grep -q "^$package\$"; then
        brew uninstall "$package"
        echo "✅ '$package' has been removed!"
    else
        echo "⚠️ Package '$package' is not installed."
    fi
}

# Function to list installed Homebrew packages
list_installed_packages() {
    echo "📋 Installed Homebrew packages:"
    brew list --formula
}

# Function to perform cleanup after confirmation
perform_cleanup() {
    read -p "🧹 Do you want to clean up old Homebrew packages? (y/n): " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "🔄 Cleaning up old versions and cache..."
        brew cleanup
        echo "✅ Cleanup completed! Your system is optimized."
    else
        echo "⏭️ Skipping cleanup."
    fi
}

# Function to show system information
show_system_info() {
    echo "🖥️ System Information:"
    echo "📦 Homebrew Version: $(brew --version | head -n 1)"
    echo "💾 Disk Usage by Homebrew: $(brew list --formula | xargs brew info --json | jq -r '.[].installed[0].size' | awk '{s+=$1} END {print s/1024/1024 " MB"}')"
}

# Main Menu
while true; do
    echo ""
    echo "🚀 Homebrew Utility Script"
    echo "1️⃣ Update Homebrew"
    echo "2️⃣ Install Homebrew Packages"
    echo "3️⃣ Uninstall a Homebrew Package"
    echo "4️⃣ List Installed Packages"
    echo "5️⃣ Cleanup Old Packages"
    echo "6️⃣ Show System Information"
    echo "7️⃣ Exit"
    read -p "👉 Choose an option (1-7): " choice

    case $choice in
        1) update_homebrew ;;
        2) install_brew_packages ;;
        3) uninstall_brew_package ;;
        4) list_installed_packages ;;
        5) perform_cleanup ;;
        6) show_system_info ;;
        7) echo "👋 Exiting script. Have a great day!"; exit 0 ;;
        *) echo "⚠️ Invalid option. Please enter a number between 1-7." ;;
    esac
done
