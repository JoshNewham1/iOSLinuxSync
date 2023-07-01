# iOSLinuxSync
A simple Bash script that allows fast & easy synchronisation of iOS devices on Linux using `rsync`.

I found using Linux much more reliable than Windows for synchronising thousands of photos. I didn't experience
any dropouts and would reach around the theoretical maximum of USB 2.0 (20 MB/s) which allowed ~45GB of photos
and videos to be synced in 45 minutes.

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
