%include version.ks

PRODUCT='EayunOS P2V'
PRODUCT_SHORT='eayunos-p2v'
PACKAGE='eayunos-p2v'
RELEASE=${RELEASE:-devel.`date +%Y%m%d%H%M%S`}

echo "Customizing boot menu"
sed -i -e '
# Put product information at the top of the file
1 {
    i '"say $PRODUCT $VERSION ($RELEASE)"'
    i '"menu title $PRODUCT_SHORT $VERSION ($RELEASE)"'
}

# Remove any existing menu title
/^menu title .*/d

# Remove quiet bootparam
#s/ quiet//

# Disable selinux entirely. Required, as we dont install an SELinux policy.
/^\s*append\s/ s/\s*$/ selinux=0/

# Remove Verify and Boot option
/label check0/{N;N;N;d;}

# Set the default timeout to 15 seconds
s/^timeout .*/timeout 15/
' $LIVE_ROOT/isolinux/isolinux.cfg

# TODO: Replace the splash screen with something P2V appropriate
#cp $INSTALL_ROOT//syslinux-vesa-splash.jpg $LIVE_ROOT/isolinux/splash.jpg

# store image version info in the ISO
cat > $LIVE_ROOT/isolinux/version <<EOF
PRODUCT='$PRODUCT'
PRODUCT_SHORT='${PRODUCT_SHORT}'
PRODUCT_CODE=$PRODUCT_CODE
RECIPE_SHA256=$RECIPE_SHA256
RECIPE_RPM=$RECIPE_RPM
PACKAGE=$PACKAGE
VERSION=$VERSION
RELEASE=$RELEASE
EOF

# overwrite user visible banners with the image versioning info
cat > $INSTALL_ROOT/etc/$PACKAGE-release <<EOF
$PRODUCT release $VERSION ($RELEASE)
EOF
ln -snf $PACKAGE-release $INSTALL_ROOT/etc/redhat-release
ln -snf $PACKAGE-release $INSTALL_ROOT/etc/system-release
cp $INSTALL_ROOT/etc/$PACKAGE-release $INSTALL_ROOT/etc/issue
echo "Kernel \r on an \m (\l)" >> $INSTALL_ROOT/etc/issue
cp $INSTALL_ROOT/etc/issue $INSTALL_ROOT/etc/issue.net

# replace initramfs if regenerated
if [ -f "$INSTALL_ROOT/initrd0.img" ]; then
  mv -v "$INSTALL_ROOT/initrd0.img" "$LIVE_ROOT/isolinux/initrd0.img"
fi
