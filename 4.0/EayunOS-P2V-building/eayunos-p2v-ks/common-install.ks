lang C
keyboard us
timezone --utc UTC
auth --useshadow --enablemd5
selinux --disabled
firewall --disabled
# TODO: the sizing of the image needs to be more dynamic
part / --size 1024 --fstype ext2
services --enabled=NetworkManager --disabled=auditd
bootloader --timeout=30
rootpw --iscrypted $1$tQiZwocX$ghhurQEm56p/HqgN.XEtk1

# add missing scsi modules to initramfs
device 3w-9xxx
device 3w-sas
device 3w-xxxx
device a100u2w
device aacraid
device aic79xx
device aic94xx
device arcmsr
device atp870u
device be2iscsi
device bfa
device BusLogic
device cxgb3i
device dc395x
device fnic
device gdth
device hpsa
device hptiop
device imm
device initio
device ips
device libosd
device libsas
device libsrp
device lpfc
device megaraid
device megaraid_mbox
device megaraid_mm
device megaraid_sas
device mpt2sas
device mvsas
device osd
device osst
device pm8001
device pmcraid
device qla1280
device qla2xxx
device qla4xxx
device qlogicfas408
device stex
device tmscsim
