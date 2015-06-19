#!/bin/bash

echo `dirname $(realpath $0)`/environ.sh

. `dirname $(realpath $0)`/environ.sh

echo OVIRT_ALLINONE_BASE

lorax --version $VERSION --product $PRODUCT_NAME --release $RELEASE --isfinal -s file://$OVIRT_ALLINONE_BASE $OVIRT_ALLINONE_BASE/$ISO_DATA_PATH
