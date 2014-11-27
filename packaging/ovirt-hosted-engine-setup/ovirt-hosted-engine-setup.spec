#
# ovirt-hosted-engine-setup -- ovirt hosted engine setup
# Copyright (C) 2013-2014 Red Hat, Inc.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#

%global         engine ovirt-engine
%global         package_version 1.2.2-0.0.master
%global         ovirt_hosted_engine_setup_templates %{_datadir}/%{name}/templates
%global         ovirt_hosted_engine_setup_scripts %{_datadir}/%{name}/scripts
%global         vdsmhooksdir %{_libexecdir}/vdsm/hooks

%define dist_eayunos .eayunos.4.1


Summary:        oVirt Hosted Engine setup tool
Name:           ovirt-hosted-engine-setup
Version:        1.2.2
Release:        3%{?dist_eayunos}
License:        LGPLv2+
URL:            http://www.ovirt.org
Source:         http://resources.ovirt.org/pub/ovirt-3.5-snapshot/src/%{name}/%{name}-%{package_version}.tar.gz
Group:          Applications/System

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch

Requires:       python
Requires:       python-ethtool >= 0.6-3
Requires:       otopi >= 1.3.0
Requires:       vdsm >= 4.16.7
Requires:       vdsm-cli >= 4.16.7
Requires:       vdsm-python >= 4.16.7
Requires:       ovirt-host-deploy >= 1.3.0
Requires:       openssh-server
Requires:       python-paramiko
Requires:       virt-viewer
Requires:       openssl
Requires:       sudo
Requires:       bind-utils
Requires:       ovirt-hosted-engine-ha >= 1.2.4
Requires:       sanlock >= 2.8
Requires:       sanlock-python >= 2.8
Requires:       lsof
Requires:       iptables
BuildRequires:  gettext
BuildRequires:  python2-devel

Requires:       %{engine}-sdk-python >= 3.5.0.7

%if 0%{?fedora}
Requires:       qemu-img
%endif

%if 0%{?rhel}
Requires:       qemu-img-rhev >= 0.12.1.2-2.415
%endif

%description
Hosted Engine setup tool for oVirt project.

%prep
%setup -q -n %{name}-%{package_version}

%build
%configure \
        --docdir="%{_docdir}/%{name}-%{version}" \
        --disable-python-syntax-check \
        %{?conf}
make %{?_smp_mflags}

%install
rm -rf "%{buildroot}"
make %{?_smp_mflags} install DESTDIR="%{buildroot}"

%files
%doc COPYING
%doc README
%dir %{_sysconfdir}/ovirt-hosted-engine-setup.env.d
%dir %{_sysconfdir}/ovirt-hosted-engine
%dir %{_localstatedir}/log/ovirt-hosted-engine-setup
%dir %{_localstatedir}/lib/ovirt-hosted-engine-setup
%dir %{_localstatedir}/lib/ovirt-hosted-engine-setup/answers
%{_sbindir}/hosted-engine
%{_sbindir}/%{name}
%{python_sitelib}/ovirt_hosted_engine_setup/
%{_datadir}/%{name}/
%{_mandir}/man8/*

#move to a separate package?
%{vdsmhooksdir}/before_vm_start/

%changelog
* Tue Nov 27 2014 Zhao Chao <chao.zhao@eayun.com> - 1.2.2-2.eayunos.4.1
- avoid host name collision, reapply commmit
  1f55418e60e667c9da04b8dd21e678fb634a8813. this is a regression bug,
  introduced by commit a294fdfc7a410aadb6fd1c72594989e2f3ef1a26.

* Tue Nov 25 2014 Zhao Chao <chao.zhao@eayun.com> - 1.2.2-2.eayunos.4.1
- core/remote_answerfile: don't check CONFIG_FILE_APPEND.

* Tue Nov 25 2014 Zhao Chao <chao.zhao@eayun.com> - 1.2.2-1.eayunos.4.1
- use origin/ovirt-hosted-engine-setup-1.2 branch, commit id:
  c85743bfb0a51346112c8ee18e0b5e3581988ce5.

* Fri Oct  3 2014 Sandro Bonazzola <sbonazzo@redhat.com> - 1.2.2-0.0.master
- 1.2.2-0.0.master

* Thu Oct  2 2014 Sandro Bonazzola <sbonazzo@redhat.com> - 1.2.1-1
- 1.2.1-1

* Mon Sep 22 2014 Sandro Bonazzola <sbonazzo@redhat.com> - 1.2.0-1
- 1.2.0-1

* Fri Sep 12 2014 Sandro Bonazzola <sbonazzo@redhat.com> - 1.2.0-0.2.master
- 1.2.0-0.2.master

* Fri Jul 11 2014 Sandro Bonazzola <sbonazzo@redhat.com> - 1.2.0-0.1.master
- 1.2.0-0.1.master

* Fri Jan 17 2014 Sandro Bonazzola <sbonazzo@redhat.com> - 1.2.0-0.0.master
- 1.2.0-0.0.master
