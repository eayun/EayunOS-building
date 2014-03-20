#!/bin/bash

. ./environ.sh

mkisofs -q -r -R -J -T -no-emul-boot -boot-load-size 4 \
        -b isolinux/isolinux.bin -boot-info-table \
        -V $PRODUCT_NAME -A "$PRODUCT_NAME $DATESTRING $ARCH DVD" \
        -publisher "$PUBLISHER"  -p "$PUBLISHER" \
        -o $PRODUCT_NAME-$DATESTRING-$ARCH-DVD.iso ./$ISO_DATA_PATH
