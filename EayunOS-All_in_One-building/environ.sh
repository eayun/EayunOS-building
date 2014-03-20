#!/bin/ash

OVIRT_ALLINONE_BASE=/root/ovirt-all.in.one-building
PRODUCT_NAME=eayunOS
VERSION=4.0
RELEASE=2
ISO_DATA_PATH=eayunOS-iso

PUBLISHER=zhaochao1984@gmail.com
DATESTRING=`date '+%Y%m%d%H%M%S'`
ARCH=`uname -m`

LOCAL_REPO1=file:///root/ovirt-all.in.one-base/rpms/centos65/x86_64/
#LOCAL_REPO2=file:///root/ovirt-all.in.one-base/rpms/centos65/update/
LOCAL_REPO3=file:///root/ovirt-all.in.one-base/rpms/eayunVirt/
LOCAL_REPO4=file:///root/ovirt-all.in.one-base/rpms/epel/6/x86_64/
#LOCAL_REPO5=file:///root/ovirt-all.in.one-base/rpms/rhev-m/3.x/

ANACONDA_BUILDINSTALL=$OVIRT_ALLINONE_BASE/anaconda-runtime/usr/lib/anaconda-runtime/buildinstall
