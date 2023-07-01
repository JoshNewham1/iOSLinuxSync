#!/bin/bash
copy_files () {
	# Read possible Apple devices into an array
	devices_dir="/run/user/1000/gvfs"
	echo "Scanning for Apple devices in $devices_dir...";
	readarray -t dirs < <(find $devices_dir -mindepth 1 -maxdepth 1 -type d -printf '%P\n');
	echo

	echo "Please type the number of the device you would like to copy from:"
	echo "Note that gphoto = photos and videos, afc = file transfers";

	i=1;
	for dir in "${dirs[@]}"; 
	do
		echo "[$i] $dir";
		i=$(($i+1));
	done

	read choice;

	# Validate choice
	if [ $choice -le 0 ] || [ $choice -ge $i ]
	then
		echo "Please try again and choose a valid choice from 1-$(($i-1))...";
		exit 1;
	fi

	source_path="$devices_dir/${dirs[$(($choice-1))]}";
	if [[ $source_path == *"gphoto"* ]]; then
		source_path="$source_path/DCIM/";
	fi

	echo
	echo "Initiating copy from $source_path to $destination_path...";
	rsync -r --info=progress2 --ignore-existing "$source_path" "$destination_path"

	if [ "$convert" = true ]; then
		convert_files
	fi
}

convert_files () {
	# Check heif-convert util is installed
	if ! command -v heif-convert &> /dev/null
	then
	    echo "heif-convert COMMAND could not be found."
	    echo "Please install 'libheif-examples' first."
	    echo "To install 'libheif-examples', run the following command:"
	    echo "  sudo apt install libheif-examples"
	    exit
	fi
    
	echo "Converting all images from HEIC to JPG...";
	# Get all HEIC files recursively and store in array
	readarray -t heic_files < <(find "$destination_path" -type f -iname "*.heic" -printf "%P\n");
	for file in "${heic_files[@]}";
	do
		# Do a case-insensitive replace of .heic with .jpg for the output name
		output_file_name=`echo $file | sed 's/\.heic/\.jpg/Ig'`;
		# If the jpg file doesn't already exist
		if ! [ -e "$output_file_name" ]; then
			# Convert it
			heif-convert "$file" "$output_file_name" -q 100;

			# Remove the accompanying HDR map if it exists
			auxiliary_image_name=$(sed 's/\.jpg/-urn\:com\:apple\:photo\:2020\:aux\:hdrgainmap\.jpg/Ig' <<< $output_file_name);
			if [ -e "$auxiliary_image_name" ]; then
				rm $auxiliary_image_name;
				echo "Removed auxiliary image $auxiliary_image_name...";
			fi
		fi
	done
}

# Halt script if error occurs
set -e;

# Get args from command line
while getopts ":o:c:" opt; do
  case $opt in
    o) destination_path="$OPTARG"
    ;;
    c) convert="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    echo "-o destination path"
    echo "-c convert all images from HEIC to JPG (optional)"
    exit 1
    ;;
  esac
done

# Check mandatory args
if [ -z "$destination_path" ]; then
        echo "Please provide a destination path with the -o argument...";
        exit 1;
fi

# TODO check deps

copy_files
