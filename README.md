# Badgeify

This is the final sample project created by following the guides [Using SwiftUI in Command Line Tools](https://SwiftToolkit.dev/swiftui-meets-command-line) and [Building Swift Executables](https://swifttoolkit.dev/posts/building-swift-executables), from SwiftToolkit.dev.

The example app icon used in this project is from the NetNewsWire app.

# Usage

To use this tool, first clone this project. Then, in the root directory, use SPM to build and run the executable:

```sh
swift run badgeify --input icon.png --output badged.png --text "Some Text"
```

Where instead of `icon.png` you can use any path.


## Building and Running from Source

As long as the Swift compiler is available, one single command is enough, no matter what is the OS or architecture:

```sh
swift run [<build-options>] <executable-name> [<arguments>...]
```


## Building a Binary from Source

Similar to the command above, SPM allows to build a binary and use it without additional compilation:

```sh
swift build -c release [--product <product-name>]
```


## A Script to Build and Store the Binary

With the commands and flags from the previous section, it is possible to write a short script that will build the binary and place it under `/usr/bin`, so it can be accessed from any directory:

```sh
#!/bin/sh

swift build -c release --product <product-name>
BINARY_PATH=$(swift build -c release --show-bin-path)
cp "${BINARY_PATH}/<product-name>" /usr/local/bin
```

As this last operation requires admin privileges, make sure to prepend running the script with `sudo`. You can save this script as `create-binary.sh`, and run it with:

```sh
sudo ./create-binary.sh
```


## Building for Different OSes and Architectures

Allowing building from source makes the process longer and harder for your users. Offering a batteries included tool, already compiled, definitely helps them, while adds complexity for the maintainers.

In many cases, you will want to ship your tool ready to be used, and to do so, you’ll need to compile it for both Intel and Apple Macs, and also support other OSes, such as Linux or Windows.

### Intel and Apple Silicon Support

When building on an Apple Silicon machine, the resulting executable will by default no be able to be ran on Intel Macs. 
To build for it, you can use the `--triple` build option. It allows describing the target architecture, vendor, and operating system - therefore, a triple.

```sh
swift build \
    --product <product-name> \
    --triple x86_64-apple-macosx
```

When the situation is inverse - if you’re on an Intel Mac and want to build for an Apple Silicon Mac - use the `arm64-apple-macosx` triple.

Finally, you can merge both binaries into a universal binary, supporting both architectures. To do so, use the `lipo` tool, which manipulates and creates universal binary files for multiple architectures:

```sh
lipo -create \
    -output <universal-output-path> \
    <path-to-arm-binary> \
    <path-to-x86-binary>
```

Replace `<universal-output-path>` with the path you want the universal binary to be saved at, and the paths for each different binary.


## Linux Support

Building for Linux will require either a Linux machine or Docker.

Considering you have Docker installed in your machine, this can be done with two commands.

First, run the `swift build` command in a Docker container, using the official Swift image for Linux. Here we use `5.10`, but you can use latest instead:

```sh
docker run \
    --name my-container-name \
    -v "$PWD:/src" \
    -w /src \
    swift:5.10 \
    swift build -c release <product-name>
```

Once the build has succeeded, you can use another Docker command, `cp`, to copy the binary from the container to the host machine:

```sh
docker cp \
    my-container-name:/src/.build/aarch64-unknown-linux-gnu/release/<product-name> \
    <linux-product-name>
```

Replace `<linux-product-name>` with the file name you want, making it clear it’s the Linux build.

To confirm that this is indeed the correct binary, you can use the file tool, which determines a file type:

```sh
file <linux-product-name>
```

Which results in `ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, for GNU/Linux 3.7.0, with debug_info, not stripped`.
