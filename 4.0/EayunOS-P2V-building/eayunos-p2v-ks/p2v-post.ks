# Run virt-p2v
if [ ! -e /etc/rc.d/rc.local ]; then
    echo "#!/bin/sh" > /etc/rc.d/rc.local
    chmod 755 /etc/rc.d/rc.local
fi

cat >> /etc/rc.d/rc.local <<'EOF'

# Configure the machine to write compressed core files to /tmp
cat > /tmp/core.sh <<'CORE'
#!/bin/sh
/usr/bin/gzip -c > /tmp/$1.core.gz
CORE

chmod 755 /tmp/core.sh
echo "|/tmp/core.sh %h-%e-%p-%t" > /proc/sys/kernel/core_pattern
ulimit -c unlimited

Xlog=/tmp/X.log
again=$(mktemp)

# Launch a getty on tty2 to allow debugging while the program runs
/usr/bin/setsid mingetty --autologin root /dev/tty2 &

while [ -f "$again" ]; do
    /usr/bin/xinit /usr/bin/virt-p2v-launcher > $Xlog 2>&1

    # virt-p2v-launcher will have touched this file if it ran
    if [ -f /tmp/virt-p2v-launcher ]; then
        rm $again
        break
    fi

    /usr/bin/openvt -sw -- /bin/bash -c "
echo virt-p2v-launcher failed
select c in \
    \"Try again\" \
    \"Debug\" \
    \"Power off\"
do
    if [ \"\$c\" == Debug ]; then
        echo Output was written to $Xlog
        echo Any core files will have been written to /tmp
        echo Exit this shell to run virt-p2v-launcher again
        bash -l
    elif [ \"\$c\" == \"Power off\" ]; then
        rm $again
    fi
    break
done
"

done
/sbin/poweroff
EOF
