%define _version 1.0
%define _release 0

Name:		jboss-jackson-bugfix
Version:	%{_version}
Release:	%{_release}%{?dist}
Summary:	update for jackson package in jboss modules

Group:		ovirt-engine
License:	GPL
URL:		http://www.eayun.com
Source0:	jboss-jackson-bugfix-%{_version}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

BuildRequires:	/bin/bash
BuildRequires:	wget
Requires:	ovirt-engine >= 3.5.0

%description

%prep
%setup -q


%build
mkdir downloads
cd downloads
wget http://central.maven.org/maven2/org/codehaus/jackson/jackson-core-asl/1.9.11/jackson-core-asl-1.9.11.jar
wget http://central.maven.org/maven2/org/codehaus/jackson/jackson-jaxrs/1.9.11/jackson-jaxrs-1.9.11.jar
wget http://central.maven.org/maven2/org/codehaus/jackson/jackson-mapper-asl/1.9.11/jackson-mapper-asl-1.9.11.jar


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-core-asl/main
mkdir -p %{buildroot}/usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-jaxrs/main
mkdir -p %{buildroot}/usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-mapper-asl/main
cp downloads/jackson-core-asl-1.9.11.jar %{buildroot}/usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-core-asl/main/
cp downloads/jackson-jaxrs-1.9.11.jar %{buildroot}/usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-jaxrs/main/
cp downloads/jackson-mapper-asl-1.9.11.jar %{buildroot}/usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-mapper-asl/main/

%clean
rm -rf %{buildroot}

%post
sed -i 's/1.9.2/1.9.11/' /usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-core-asl/main/module.xml
sed -i 's/1.9.2/1.9.11/' /usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-jaxrs/main/module.xml
sed -i 's/1.9.2/1.9.11/' /usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-mapper-asl/main/module.xml

%files
%attr(0644,root,root) /usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-core-asl/main/jackson-core-asl-1.9.11.jar
%attr(0644,root,root) /usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-jaxrs/main/jackson-jaxrs-1.9.11.jar
%attr(0644,root,root) /usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-mapper-asl/main/jackson-mapper-asl-1.9.11.jar

%postun
sed -i 's/1.9.11/1.9.2/' /usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-core-asl/main/module.xml
sed -i 's/1.9.11/1.9.2/' /usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-jaxrs/main/module.xml
sed -i 's/1.9.11/1.9.2/' /usr/share/ovirt-engine-jboss-as/modules/org/codehaus/jackson/jackson-mapper-asl/main/module.xml

%changelog

