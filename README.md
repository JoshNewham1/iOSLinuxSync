# iOSLinuxSync
A simple Bash script that allows easy synchronisation of iOS devices on Linux

## Usage
1. Make the script executable if it isn't already
   `chmod +x ios-sync.sh`
2. Plug in your iOS device to a Linux machine. This has only been tested for Ubuntu
   so you may need some extra dependencies to get your iOS device mounting with gvfs
3. Run the script
   `./ios-sync.sh -o YOUR_DESTINATION_PATH`

If you would like to convert all the images from HEIC to JPG, you can use the `-c true`
argument.

Happy syncing!
