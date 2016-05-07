BUILD_DIR_NAME="isobuild"
ISO_DIR_NAME="EayunOS-iso"
WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PRODUCT_NAME="EayunOS"
VERSION="4.2"
RELEASE="0"
PUBLISHER=Eayun
DATESTRING=`date '+%Y%m%d%H%M%S'`
ARCH=`uname -m`
ISO_BUILD_REPOS=("http://192.168.2.65:11080/pulp/repos/centos/7.2.1511/os/x86_64/" \
    "http://192.168.2.65:11080/pulp/repos/centos/7.2.1511/updates/x86_64/" \
    "http://192.168.2.65:11080/pulp/repos/centos/7.2.1511/extras/x86_64/")

if [ "$1" == "build" ]
then
  echo "start building iso structure..."
  cd $WORKING_DIR
  rm -rfv $BUILD_DIR_NAME
  mkdir -p $BUILD_DIR_NAME
  REPO_PARAM=""
  for i in "${ISO_BUILD_REPOS[@]}"
  do
    REPO_PARAM=$REPO_PARAM" -s $i"
  done
  lorax --version $VERSION --product $PRODUCT_NAME --release $RELEASE --isfinal \
      $REPO_PARAM $BUILD_DIR_NAME
fi

if [ "$1" == "prep" ]
then
  echo "start preparing iso resources..."
  cd $WORKING_DIR
  rm -rfv $BUILD_DIR_NAME/Packages
  rm -rfv $BUILD_DIR_NAME/repodata
  mkdir -p $BUILD_DIR_NAME/Packages
  echo "back up rpmdb..."
  rm -rf /var/lib/rpm.bak
  mv -v /var/lib/rpm{,.bak}
  yum clean metadata
  yum makecache
  echo "downloading packages..."
  perl tools/get_packages_list.pl comps.xml | xargs yumdownloader --resolve --destdir=$BUILD_DIR_NAME/Packages
  echo "restore rpmdb..."
  rm -rf /var/lib/rpm
  mv /var/lib/rpm{.bak,}
  echo "creating repodata..."
  cd $BUILD_DIR_NAME
  createrepo -g ../comps.xml .
fi

if [ "$1" == "make" ]
then
  echo "start make iso..."
  cd $WORKING_DIR
  rm -rfv $BUILD_DIR_NAME/ks
  cp -rv iso_files/ks $BUILD_DIR_NAME
  yes|cp -v iso_files/isolinux.cfg $BUILD_DIR_NAME/isolinux/
  # TODO: cp branding stuff
  mkisofs -q -r -R -J -T -no-emul-boot -boot-load-size 4 \
      -b isolinux/isolinux.bin -boot-info-table \
      -V $PRODUCT_NAME -A "$PRODUCT_NAME $DATESTRING $ARCH DVD" \
      -publisher "$PUBLISHER"  -p "$PUBLISHER" \
      -o $PRODUCT_NAME-$VERSION-$RELEASE-$DATESTRING-$ARCH-DVD.iso \
      $BUILD_DIR_NAME
fi
