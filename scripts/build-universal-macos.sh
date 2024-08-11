#!/bin/sh

# If any of the commands fails with an error, make the script exit early with an error, by using the set -e command.
set -e

# Build the single executable target, in the release configuration, for both arm64 and x86_64 architectures. 
# Following that, use the --show-bin-path argument to store the path where the resulting binary will be at.
swift build -c release --arch x86_64 --arch arm64
BUILD_PATH=$(swift build -c release --arch x86_64 --arch arm64 --show-bin-path)
echo -e "\n\nBuild at ${BUILD_PATH}"

# Define the destination path, where you’ll place the executable at. Create the builds folder if necessary, and use the cp command to copy it.
DESTINATION="builds/badgeify-macos"
if [ ! -d "builds" ]; then
    mkdir "builds"
fi

cp "$BUILD_PATH/badgeify" "$DESTINATION"
echo "Copied binary to $DESTINATION"