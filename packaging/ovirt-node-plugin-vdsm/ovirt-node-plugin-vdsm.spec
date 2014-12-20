%define is_f19 %(test "0%{?fedora}" -eq "019" && echo 1 || echo 0)
%define dist_eayunos .eayunos.4.1

Summary:        A plugin to make oVirt Node installs compatible with oVirt Engine and vdsm
Name:           ovirt-node-plugin-vdsm
Version:        0.2.2
Release:        6%{?dist_eayunos}
Source0:        %{name}-0.2.2_ovirt35.tar.gz
License:        GPLv2+
Group:          Applications/System

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-buildroot
URL:            http://www.ovirt.org/
Requires:       ovirt-node >= 3.0.4
Requires:       python
Requires:       vdsm-reg >= 4.10.3
Requires:       ovirt-host-deploy-offline >= 1.3.0
%if ! 0%{?rhel}
Requires:       vdsm-hook-vhostmd
%endif
Requires:       vdsm-gluster
Requires(post): augeas

BuildArch:      noarch
BuildRequires:  python2-devel

%define app_root %{_datadir}/%{name}
%define recipe_root %{_datadir}/ovirt-node-recipe

%description
Provides UI and associated scripts for integrating oVirt Node and oVirt Engine

%package recipe
Summary:        Kickstarts for building oVirt Node isos including %{name}
Group:          Applications/System
Requires:       ovirt-node-recipe >= 2.6.0

%description recipe
Provides kickstart files for generating an oVirt Node ISO image containing
%{name}.

%prep
%setup -q -n %{name}-0.2.2_ovirt35


%build
%configure

%install
%{__rm} -rf %{buildroot}
make install DESTDIR=%{buildroot}

%post
# reserve vdsm port 54321
augtool << \EOF_sysctl
set /files/etc/sysctl.conf/net.ipv4.ip_local_reserved_ports 54321
save
EOF_sysctl

#SELinux Booleans
/usr/sbin/setsebool -P virt_use_nfs=1 \
                       virt_use_sanlock=1 \
                       sanlock_use_nfs=1

# ensure Network Manager is disabled
%if %{is_f19}
/usr/bin/systemctl mask NetworkManager.service
%endif

%preun

%files recipe
%{recipe_root}

%files
%{python_sitelib}/ovirt/node/setup/vdsm
%{_libexecdir}/ovirt-node/hooks/pre-upgrade/01-vdsm
%{_libexecdir}/ovirt-node/hooks/post-upgrade/01-sanlock-check
%{_libexecdir}/ovirt-node/hooks/on-boot/01-vdsm-configure
%{_libexecdir}/ovirt-node/hooks/on-boot/02-vdsm-sebool-config
%{_libexecdir}/ovirt-node/hooks/on-boot/90-start-vdsm
%{_sysconfdir}/ovirt-plugins.d
%{_sysconfdir}/default/version.ovirt-node-plugin-vdsm

%changelog
* Sat Dec 20 2014 Zhao Chao <chao.zhao@eayun.com> - 0.2.2-6.eayunos.4.1
- change rank to 114.

* Sat Dec 20 2014 Zhao Chao <chao.zhao@eayun.com> - 0.2.2-5.eayunos.4.1
- add eayunosmgmt as a default bridge name.
- fix default values for Entries in UI.
- add the first i18n modification.

* Tue Dec 15 2014 Zhao Chao <chao.zhao@eayun.com> - 0.2.2-4.eayunos.4.1
- replace engine name as 'EayunOS Manager'.

* Tue Nov 25 2014 Zhao Chao <chao.zhao@eayun.com> - 0.2.2-3.eayunos.4.1
- update to e138d9cb7e3a15b1636b469218deeeb6358c47d2.

* Fri Nov 07 2014 Fabian Deutsch <fabiand@redhat.com> - 0.4.3
- Explicitly start vdsmd again rhbz#1156369

* Wed Nov 05 2014 Fabian Deutsch <fabiand@redhat.com> - 0.4.2
- Move sanlock check to post-upgrade hook rhbz#1156369

* Thu Oct 23 2014 Fabian Deutsch <fabiand@redhat.com> - 0.4.1
- Add sebool handler rhbz#1150243 rhbz#1156038

* Thu Jun 12 2014 Douglas Schilling Landgraf <dougsland@redhat.com> 2.0.0
- Increase the version/release

* Fri May 17 2013 Mike Burns <mburns@redhat.com> 0.0.2
- Rename to ovirt-node-plugin-vdsm
- rebase onto ovirt-node 3.0.0 codebase
- add note about changing sshd when setting passwd
- fix password changing
- fix some requirements
- add minimization

* Fri Feb 15 2013 Mike Burns <mburns@redhat.com> 0.0.1
- initial commit
- engine_page from current ovirt-node
