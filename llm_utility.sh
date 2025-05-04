#!/bin/bash

# Configuration - Default Hugging Face model directory
# Change this if your models are stored elsewhere
HF_MODEL_DIR="$HOME/.cache/huggingface/hub"
# PyAnnote model directory
PYANNOTE_MODEL_DIR="$HOME/.cache/torch/pyannote"

# Function to list all downloaded models from Hugging Face
list_downloaded_models() {
    echo "📋 Local Models:"
    
    # Check and list Hugging Face models
    if [ -d "$HF_MODEL_DIR" ]; then
        # Find and list model directories
        echo "Found Hugging Face models in: $HF_MODEL_DIR"
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
    
    # Check and list PyAnnote models
    echo ""
    if [ -d "$PYANNOTE_MODEL_DIR" ]; then
        echo "Found PyAnnote models in: $PYANNOTE_MODEL_DIR"
        echo "-------------------------------------------"
        find "$PYANNOTE_MODEL_DIR" -type d -maxdepth 1 -mindepth 1 | while read -r model_dir; do
            model_name=$(basename "$model_dir")
            echo "🔊 $model_name"
        done
    else
        echo "⚠️ PyAnnote models directory not found at $PYANNOTE_MODEL_DIR"
    fi
}

# Function to display disk usage by models
show_model_disk_usage() {
    echo "💾 Disk Usage by Models:"
    
    # Check Hugging Face models
    if [ -d "$HF_MODEL_DIR" ]; then
        total_size=$(du -sh "$HF_MODEL_DIR" | cut -f1)
        echo "Hugging Face total size: $total_size"
        
        echo "-------------------------------------------"
        echo "Size by Hugging Face model:"
        find "$HF_MODEL_DIR" -type d -name "snapshots" | while read -r snapshot_dir; do
            model_path=$(dirname "$snapshot_dir")
            model_name=$(basename "$(dirname "$model_path")")/$(basename "$model_path")
            size=$(du -sh "$model_path" | cut -f1)
            echo "🤗 $model_name: $size"
        done
    else
        echo "⚠️ Hugging Face models directory not found at $HF_MODEL_DIR"
    fi
    
    # Check PyAnnote models
    echo ""
    if [ -d "$PYANNOTE_MODEL_DIR" ]; then
        total_size=$(du -sh "$PYANNOTE_MODEL_DIR" | cut -f1)
        echo "PyAnnote total size: $total_size"
        
        echo "-------------------------------------------"
        echo "Size by PyAnnote model:"
        find "$PYANNOTE_MODEL_DIR" -type d -maxdepth 1 -mindepth 1 | while read -r model_dir; do
            model_name=$(basename "$model_dir")
            size=$(du -sh "$model_dir" | cut -f1)
            echo "🔊 $model_name: $size"
        done
    else
        echo "⚠️ PyAnnote models directory not found at $PYANNOTE_MODEL_DIR"
    fi
}

# Function to delete a model from cache
delete_model() {
    echo "❌ Delete Model from Cache:"
    
    # Store all model information
    model_paths=()
    model_names=()
    model_types=()  # To track whether it's HF or PyAnnote
    
    i=0
    
    # Check Hugging Face models
    if [ -d "$HF_MODEL_DIR" ]; then
        while IFS= read -r snapshot_dir; do
            model_path=$(dirname "$snapshot_dir")
            model_name=$(basename "$(dirname "$model_path")")/$(basename "$model_path")
            
            model_paths[$i]="$model_path"
            model_names[$i]="$model_name"
            model_types[$i]="HF"
            
            ((i++))
        done < <(find "$HF_MODEL_DIR" -type d -name "snapshots" | sort)
    fi
    
    # Check PyAnnote models
    if [ -d "$PYANNOTE_MODEL_DIR" ]; then
        while IFS= read -r model_dir; do
            model_name=$(basename "$model_dir")
            
            model_paths[$i]="$model_dir"
            model_names[$i]="$model_name"
            model_types[$i]="PyAnnote"
            
            ((i++))
        done < <(find "$PYANNOTE_MODEL_DIR" -type d -maxdepth 1 -mindepth 1 | sort)
    fi
    
    if [ ${#model_paths[@]} -eq 0 ]; then
        echo "No models found in cache."
        return
    fi
    
    # Display available models
    echo "Available models:"
    echo "-------------------------------------------"
    for ((j=0; j<${#model_paths[@]}; j++)); do
        if [[ "${model_types[$j]}" == "HF" ]]; then
            echo "[$(($j+1))] 🤗 ${model_names[$j]} (Hugging Face)"
        else
            echo "[$(($j+1))] 🔊 ${model_names[$j]} (PyAnnote)"
        fi
    done
    
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
    selected_path="${model_paths[$selected_idx]}"
    selected_type="${model_types[$selected_idx]}"
    
    # Confirm deletion
    read -p "⚠️ Are you sure you want to delete '$selected_model' ($selected_type)? This cannot be undone. (y/n): " confirm
    
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
    echo "🤗 Local Models Utility"
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
