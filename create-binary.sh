
#!/bin/sh

swift build -c release --product badgeify
BINARY_PATH=$(swift build -c release --show-bin-path)
cp "${BINARY_PATH}/badgeify" /usr/local/bin
