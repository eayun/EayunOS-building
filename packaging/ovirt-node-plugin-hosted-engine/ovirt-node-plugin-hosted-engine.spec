%global product_family oVirt Node
%define recipe_root %{_datadir}/ovirt-node-recipe
%define dist_eayunos .eayunos.4.1

%global         package_version 0.2.0_ovirt35
%global         package_name ovirt-node-plugin-hosted-engine


Name:           ovirt-node-plugin-hosted-engine
Version:        0.2.0
Release:        1%{?dist_eayunos}
Source0:        http://plain.resources.ovirt.org/pub/ovirt-master-snapshot/src/%{name}/%{name}-%{package_version}.tar.gz
License:        GPLv2+
Group:          Applications/System
Summary:        Hosted Engine plugin for %{product_family} image
BuildRequires:  python2-devel
Requires:       ovirt-hosted-engine-setup
Requires:       screen
Requires:       python-requests

BuildArch:      noarch

%package recipe
Summary:        Kickstarts for building oVirt Node isos including %{name}
Group:          Applications/System
Requires:       ovirt-node-recipe >= 2.6.0


%post
chkconfig ovirt-ha-agent on
chkconfig ovirt-ha-broker on

%description
This package provides a hosted engine plugin for use with%{product_family} image.

%description recipe
Provides kickstart files for generating an oVirt Node ISO image containing
%{name}.


%files
%{python_sitelib}/ovirt/node/setup/hostedengine/__init__.py*
%{python_sitelib}/ovirt/node/setup/hostedengine/hosted_engine_page.py*

%prep
%setup -q -n "%{name}-%{package_version}"


%build
%configure

%install
%{__rm} -rf %{buildroot}
make install DESTDIR=%{buildroot}


%files
%{python_sitelib}/ovirt/node/setup/hostedengine
#%{_sysconfdir}/ovirt-plugins.d

%files recipe
%{recipe_root}

%changelog
* Tue Nov 25 2014 Zhao Chao <chao.zhao@eayun.com> 0.2.0-1.eayunos.4.1
- update to commit 038bb9cf4c35d8e268018734ee79ec91ecd8fc37.

* Tue May 27 2014 Joey Boggs <jboggs@redhat.com> 0.0.1
- initial commit
