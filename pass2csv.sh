#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Title: pass2csv.sh
# Descrição: Script for exporting passwords from 'pass' into a CSV format
# compatible with KeePass import functionality
# Author: substationworm
# License: MIT
# Version: 2.0
# Contact 01: https://www.linkedin.com/in/lffreitas-gutierres/
# Contact 02: https://github.com/substationworm
# Dependencies: pass
# Usage Instructions:
#   i. Grant execution permission using the command
#       chmod +x pass2csv.sh
#   ii. Run the script in the terminal with
#       ./pass2csv.sh
# -----------------------------------------------------------------------------

# Function to display the banner
show_banner() {
    echo -e "\e[1;34m"
    echo "               __          "
    echo " _   _   _  _   _)  _  _   "
    echo "|_) (_| _) _)  /__ (_ _) \/"
    echo "|                          "                                
    echo -e "\e[1;37mVersion:   2.0\e[0m"
    echo -e "\e[1;37mAuthor:    substationworm\e[0m"
    echo -e "\e[1;37mContact:   in/lffreitas-gutierres\e[0m"
    echo -e "\e[0m"
}

# Function to display script usage
show_help() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -h               Displays this help message."
    echo "  -o <file>        Specifies the output file (default: passwordsCSV.csv)."
    echo "  -f <fields>      Excludes specific fields from the CSV. Available fields:"
    echo "                   title, user, password, url, notes"
    echo "  -d <directory>   Specifies the .password-store directory (default: ~/.password-store)."
    echo
}

# Initialize default variables
output_file="passwordsCSV.csv"
exclude_fields=""
password_store_path="${HOME}/.password-store"
start_time=$(date +%s)

# Process arguments with getopts
while getopts ":ho:f:d:" opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        o)
            output_file="$OPTARG"
            ;;
        f)
            exclude_fields="$OPTARG"
            ;;
        d)
            password_store_path="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            show_help
            exit 1
            ;;
    esac
done

# Display banner
show_banner

# Verify if the password store directory exists
if [[ ! -d "$password_store_path" ]]; then
    echo "Error: Directory '$password_store_path' does not exist." >&2
    exit 1
fi

# Initialize the CSV file with the header
header=("\"Title\"" "\"User Name\"" "\"Password\"" "\"URL\"" "\"Notes\"")
fields=("title" "user" "password" "url" "notes")

# Excluding removed fields
for exclude in $(echo "$exclude_fields" | tr ',' ' '); do
    for i in "${!fields[@]}"; do
        if [[ "${fields[$i]}" == "$exclude" ]]; then
            unset "header[$i]"
            unset "fields[$i]"
        fi
    done
done

# Create a header in the CSV
echo "$(IFS=,; echo "${header[*]}")" > "$output_file"

# Function to process each password entry
process_entry() {
    local entry_path="$1"

    # Basic data
    local title password user url notes

    title=$(basename "$entry_path")
    pass_data=$(pass show "$entry_path")

    # Extract the password (first line)
    password=$(echo "$pass_data" | head -n 1)

    # Extract username and URL
    user=$(echo "$pass_data" | grep -i "^username:" | sed 's/.*username:[ ]*//i')
    url=$(echo "$pass_data" | grep -i "^url:" | sed 's/.*url:[ ]*//i')

    # Filter comments (excluding password line and known fields [username and URL])
    notes=$(echo "$pass_data" | tail -n +2 | grep -viE "^(username|url):" | tr '\n' ' ' | sed 's/^[ ]*//;s/[ ]*$//')

    # Populate the row considering excluded fields
    line=()
    for field in "${fields[@]}"; do
        case $field in
            title) line+=("\"$title\"") ;;
            user) line+=("\"$user\"") ;;
            password) line+=("\"$password\"") ;;
            url) line+=("\"$url\"") ;;
            notes) line+=("\"$notes\"") ;;
        esac
    done

    # Write row to the CSV
    echo "$(IFS=,; echo "${line[*]}")" >> "$output_file"
}

# Process all entries (keeping relative paths in the password store)
entries=( $(find "$password_store_path" -name "*.gpg" | sed "s|$password_store_path/||; s|\\.gpg$||") )
total_entries=${#entries[@]}

echo "Please wait (...)"

for i in "${!entries[@]}"; do
    process_entry "${entries[$i]}"
    elapsed_time=$(( $(date +%s) - start_time ))
    current=$((i + 1))
    echo -ne "\rProcessing $current of $total_entries entries. Elapsed time: ${elapsed_time}s." >&2
done

echo -e "\nExport completed. File saved to '$output_file'."