#!/bin/bash
# Batch encode raw DVD video files and re-encode to .mkv format
search_directory=$1
search_type="${2:-iso}"
encoding_preset='Super HQ 576p25 Surround'
language_list='eng'

function dvdrip () {
    target_file=$1
    outfile_name=$(basename $target_file ".${search_type}")
    HandBrakeCLI -i "$target_file" --main-feature --audio-lang-list "$language_list" --preset "$encoding_preset" --output "${outfile_name}.${search_type}" < /dev/null &&
    echo "Encoding Finished for $outfile_name"
}

if [[ ! -d $search_directory ]]; then
    echo "Please supply a valid directory to search for .${search_type} files."
    echo "Exiting..."
    exit 1
else
    file_array=($(find $search_directory -type f -regex ".*\.$search_type$"))
    # Prompt for confirmation before proceeding
    echo "The following files will be re-encoded to the current working directory:"
    printf "%s\n" ${file_array[@]}
    while true; do
        read -r -p 'Would you like to continue? [Yy/Nn] ' response
        case $response in
            [Yy])
                for i in ${file_array[@]}; do
                    dvdrip $i
                done
                ;;
            [Nn])
                echo 'Operation cancelled by user. Exiting...'
                exit 0
                ;;
            *)
                ;;
        esac
    done
fi

