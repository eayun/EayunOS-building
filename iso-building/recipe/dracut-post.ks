echo
echo "Regenerating initramfs"
echo `rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}" kernel`
dracut -f --kver `rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}" kernel` || :
