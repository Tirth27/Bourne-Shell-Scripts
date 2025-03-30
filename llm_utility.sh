#!/bin/bash

# Configuration - Default Hugging Face model directory
# Change this if your models are stored elsewhere
HF_MODEL_DIR="$HOME/.cache/huggingface/hub"

# Function to list all downloaded models from Hugging Face
list_downloaded_models() {
    echo "📋 Local Hugging Face Models:"
    
    if [ -d "$HF_MODEL_DIR" ]; then
        # Find and list model directories
        echo "Found models in: $HF_MODEL_DIR"
        echo "-------------------------------------------"
        find "$HF_MODEL_DIR" -type d -name "snapshots" | while read -r snapshot_dir; do
            # Extract the model name from the path
            model_path=$(dirname "$snapshot_dir")
            model_name=$(basename "$(dirname "$model_path")")/$(basename "$model_path")
            echo "🤗 $model_name"
        done
    else
        echo "⚠️ Hugging Face models directory not found at $HF_MODEL_DIR"
        echo "If your models are stored elsewhere, please update the HF_MODEL_DIR variable in this script."
    fi
}

# Function to display disk usage by models
show_model_disk_usage() {
    echo "💾 Disk Usage by Hugging Face Models:"
    
    if [ -d "$HF_MODEL_DIR" ]; then
        total_size=$(du -sh "$HF_MODEL_DIR" | cut -f1)
        echo "Total size: $total_size"
        
        echo "-------------------------------------------"
        echo "Size by model:"
        find "$HF_MODEL_DIR" -type d -name "snapshots" | while read -r snapshot_dir; do
            model_path=$(dirname "$snapshot_dir")
            model_name=$(basename "$(dirname "$model_path")")/$(basename "$model_path")
            size=$(du -sh "$model_path" | cut -f1)
            echo "🤗 $model_name: $size"
        done
    else
        echo "⚠️ Hugging Face models directory not found at $HF_MODEL_DIR"
    fi
}

# Function to delete a model from cache
delete_model() {
    echo "❌ Delete Model from Cache:"
    
    if [ ! -d "$HF_MODEL_DIR" ]; then
        echo "⚠️ Hugging Face models directory not found at $HF_MODEL_DIR"
        return
    fi
    
    # Get list of models with indices
    echo "Available models:"
    echo "-------------------------------------------"
    
    # Find all snapshot directories and store them in arrays
    model_paths=()
    model_names=()
    
    i=0
    while IFS= read -r snapshot_dir; do
        model_path=$(dirname "$snapshot_dir")
        model_name=$(basename "$(dirname "$model_path")")/$(basename "$model_path")
        
        model_paths[$i]="$snapshot_dir"
        model_names[$i]="$model_name"
        
        echo "[$((i+1))] 🤗 $model_name"
        ((i++))
    done < <(find "$HF_MODEL_DIR" -type d -name "snapshots" | sort)
    
    if [ ${#model_paths[@]} -eq 0 ]; then
        echo "No models found in cache."
        return
    fi
    
    # Ask user to select a model
    read -p "Enter the number of the model to delete (or 0 to cancel): " selection
    
    # Check if input is valid
    if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
        echo "⚠️ Invalid input. Please enter a number."
        return
    fi
    
    # Handle cancel option
    if [ "$selection" -eq 0 ]; then
        echo "⏭️ Operation cancelled."
        return
    fi
    
    # Check if selection is in range
    if [ "$selection" -lt 1 ] || [ "$selection" -gt ${#model_paths[@]} ]; then
        echo "⚠️ Invalid selection. Please enter a number between 1 and ${#model_paths[@]}."
        return
    fi
    
    # Get the selected model path
    selected_idx=$((selection-1))
    selected_model="${model_names[$selected_idx]}"
    selected_path=$(dirname "${model_paths[$selected_idx]}")
    
    # Confirm deletion
    read -p "⚠️ Are you sure you want to delete '$selected_model'? This cannot be undone. (y/n): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "🗑️ Deleting model: $selected_model"
        rm -rf "$selected_path"
        echo "✅ Model deleted successfully!"
    else
        echo "⏭️ Deletion cancelled."
    fi
}

# Main Menu
while true; do
    echo ""
    echo "🤗 Hugging Face Local Models Utility"
    echo "1️⃣ List Downloaded Models"
    echo "2️⃣ Check Models Disk Usage"
    echo "3️⃣ Delete a Model"
    echo "4️⃣ Exit"
    read -p "👉 Choose an option (1-4): " choice

    case $choice in
        1) list_downloaded_models ;;
        2) show_model_disk_usage ;;
        3) delete_model ;;
        4) echo "👋 Exiting script. Have a great day!"; exit 0 ;;
        *) echo "⚠️ Invalid option. Please enter a number between 1-4." ;;
    esac
done
