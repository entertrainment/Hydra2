#!/bin/bash
# Creates a RAM disk named HYDRA_TMP and sets up a fake cache directory.
RAM_SECTORS=204800
DISK_NAME="HYDRA_TMP"
DEVICE=$(hdiutil attach -nomount ram://$RAM_SECTORS)
diskutil eraseVolume HFS+ "$DISK_NAME" ${DEVICE}
mkdir -p /Volumes/"$DISK_NAME"/fake_cache
ln -s /Volumes/"$DISK_NAME" /tmp/hydra_fake
echo "RAM disk and fake cache setup complete."
