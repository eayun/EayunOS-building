BUILD_DIR_NAME="isobuild"
WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PRODUCT_NAME="EayunOS"
PRODUCT_NAME_BASIC="EayunOS-basic"
PRODUCT_NAME_ENTERPRISE="EayunOS-enterprise"
PRODUCT_NAME_ADVANCED="EayunOS-advanced"
VERSION="4.2.0"
TEST_RELEASE="5"
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
  REPO_PARAM=""
  for i in "${ISO_BUILD_REPOS[@]}"
  do
    REPO_PARAM=$REPO_PARAM" -s $i"
  done
  lorax --version $VERSION --product $PRODUCT_NAME --release $TEST_RELEASE --isfinal \
      $REPO_PARAM $BUILD_DIR_NAME
fi

if [ "$1" == "prep-basic" ]
then
  echo "start preparing basic version iso resources..."
  cd $WORKING_DIR
  rm -rfv $BUILD_DIR_NAME/Packages
  rm -rfv $BUILD_DIR_NAME/repodata
  mkdir -p $BUILD_DIR_NAME/Packages
  if [ ! -d "/var/lib/rpm.bak" ]
  then
    echo "back up rpmdb..."
    mv -v /var/lib/rpm{,.bak}
  fi
  yum clean metadata
  yum makecache
  echo "downloading packages..."
  perl tools/get_packages_list.pl comps-basic.xml | xargs yumdownloader --resolve --destdir=$BUILD_DIR_NAME/Packages
  echo "restore rpmdb..."
  rm -rf /var/lib/rpm
  mv /var/lib/rpm{.bak,}
  echo "creating repodata..."
  cd $BUILD_DIR_NAME
  createrepo -g ../comps-basic.xml .
fi

if [ "$1" == "make-basic" ]
then
  echo "start make basic version iso..."
  cd $WORKING_DIR
  rm -rfv $BUILD_DIR_NAME/ks
  cp -rv iso_files_basic/ks $BUILD_DIR_NAME
  yes|cp -v iso_files_basic/isolinux.cfg $BUILD_DIR_NAME/isolinux/
  cd iso_files_basic/branding
  find . | cpio -c -o | gzip -9cv > ../../isobuild/images/product.img
  cd ../../
  mkisofs -q -r -R -J -T -no-emul-boot -boot-load-size 4 \
      -b isolinux/isolinux.bin -boot-info-table \
      -V $PRODUCT_NAME_BASIC -A "$PRODUCT_NAME_BASIC $DATESTRING $ARCH DVD" \
      -publisher "$PUBLISHER"  -p "$PUBLISHER" \
      -o $PRODUCT_NAME_BASIC-$VERSION-$TEST_RELEASE-$DATESTRING-$ARCH-DVD.iso \
      $BUILD_DIR_NAME
fi

if [ "$1" == "prep-enterprise" ]
then
  echo "start preparing enterprise version iso resources..."
  cd $WORKING_DIR
  rm -rfv $BUILD_DIR_NAME/Packages
  rm -rfv $BUILD_DIR_NAME/repodata
  mkdir -p $BUILD_DIR_NAME/Packages
  if [ ! -d "/var/lib/rpm.bak" ]
  then
    echo "back up rpmdb..."
    mv -v /var/lib/rpm{,.bak}
  fi
  yum clean metadata
  yum makecache
  echo "downloading packages..."
  perl tools/get_packages_list.pl comps-enterprise.xml | xargs yumdownloader --resolve --destdir=$BUILD_DIR_NAME/Packages
  echo "restore rpmdb..."
  rm -rf /var/lib/rpm
  mv /var/lib/rpm{.bak,}
  echo "creating repodata..."
  cd $BUILD_DIR_NAME
  createrepo -g ../comps-enterprise.xml .
fi

if [ "$1" == "make-enterprise" ]
then
  echo "start make enterprise version iso..."
  cd $WORKING_DIR
  rm -rfv $BUILD_DIR_NAME/ks
  cp -rv iso_files_enterprise/ks $BUILD_DIR_NAME
  yes|cp -v iso_files_enterprise/isolinux.cfg $BUILD_DIR_NAME/isolinux/
  cd iso_files_enterprise/branding
  find . | cpio -c -o | gzip -9cv > ../../isobuild/images/product.img
  cd ../../
  mkisofs -q -r -R -J -T -no-emul-boot -boot-load-size 4 \
      -b isolinux/isolinux.bin -boot-info-table \
      -V $PRODUCT_NAME_ENTERPRISE -A "$PRODUCT_NAME_ENTERPRISE $DATESTRING $ARCH DVD" \
      -publisher "$PUBLISHER"  -p "$PUBLISHER" \
      -o $PRODUCT_NAME_ENTERPRISE-$VERSION-$TEST_RELEASE-$DATESTRING-$ARCH-DVD.iso \
      $BUILD_DIR_NAME
fi

if [ "$1" == "prep-advanced" ]
then
  echo "start preparing advanced version iso resources..."
  cd $WORKING_DIR
  rm -rfv $BUILD_DIR_NAME/Packages
  rm -rfv $BUILD_DIR_NAME/repodata
  mkdir -p $BUILD_DIR_NAME/Packages
  if [ ! -d "/var/lib/rpm.bak" ]
  then
    echo "back up rpmdb..."
    mv -v /var/lib/rpm{,.bak}
  fi
  yum clean metadata
  yum makecache
  echo "downloading packages..."
  perl tools/get_packages_list.pl comps-advanced.xml | xargs yumdownloader --resolve --destdir=$BUILD_DIR_NAME/Packages
  echo "restore rpmdb..."
  rm -rf /var/lib/rpm
  mv /var/lib/rpm{.bak,}
  echo "creating repodata..."
  cd $BUILD_DIR_NAME
  createrepo -g ../comps-advanced.xml .
fi

if [ "$1" == "make-advanced" ]
then
  echo "start make advanced version iso..."
  cd $WORKING_DIR
  rm -rfv $BUILD_DIR_NAME/ks
  cp -rv iso_files_advanced/ks $BUILD_DIR_NAME
  yes|cp -v iso_files_advanced/isolinux.cfg $BUILD_DIR_NAME/isolinux/
  cd iso_files_advanced/branding
  find . | cpio -c -o | gzip -9cv > ../../isobuild/images/product.img
  cd ../../
  mkisofs -q -r -R -J -T -no-emul-boot -boot-load-size 4 \
      -b isolinux/isolinux.bin -boot-info-table \
      -V $PRODUCT_NAME_ADVANCED -A "$PRODUCT_NAME_ADVANCED $DATESTRING $ARCH DVD" \
      -publisher "$PUBLISHER"  -p "$PUBLISHER" \
      -o $PRODUCT_NAME_ADVANCED-$VERSION-$TEST_RELEASE-$DATESTRING-$ARCH-DVD.iso \
      $BUILD_DIR_NAME
fi

