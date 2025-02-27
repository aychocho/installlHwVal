#!/bin/bash
set -e

# Check that required commands are available.
for cmd in curl tar; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' is not installed. Install it, then try again." >&2
        exit 1
    fi
done

# Define variables.
URL="https://github.com/aychocho/gpuProvider/archive/refs/tags/eigen.tar.gz"
ARCHIVE="gpuProvider-eigen.tar.gz"
EXPECTED_DIR="gpuProvider-eigen"  # Expected folder name after extraction.
TARGET_DIR="/home/wallaby"              # extract directory
PROVIDER_DIR="${TARGET_DIR}/gpuProvider-eigen/gpuProvider"  #where providerStuff.py lives
VENV_DIR="${TARGET_DIR}/gpuProvider-eigen/gpuProviderVenv/src/bin" #where venv stuff lives

#mkdir
mkdir -p /home/wallaby

# Download the archive.
echo "Downloading archive from $URL..."
curl -L "$URL" -o "$ARCHIVE"
if [ $? -ne 0 ]; then
    echo "Failed to download archive." >&2
    exit 1
fi

echo "Extracting archive into $TARGET_DIR..."
tar -xzvf "$ARCHIVE" -C "$TARGET_DIR" || { echo "Extraction failed. The archive might be corrupt." >&2; exit 1; }

cd $PROVIDER_DIR

# Execute the python.
echo "Evaluating your hardware"
"${VENV_DIR}/python3" "$PROVIDER_DIR/providerStuff.py"
