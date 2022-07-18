#!/bin/sh

# Export filepaths
export BUILDDIR=/nvtop/build
export BUILDROOT=~/rpmbuild/
export RPMSRC=~/rpmbuild/SOURCES
export RPMSPEC=~/rpmbuild/SPECS
export RPMBUILD=~/rpmbuild/BUILD

# Check if user's rpmbuild folder is there, if so, temoprairly rename it.
if [ -d ~/rpmbuild ]; then
	echo "Backing up rpmbuild"
	~/rpmbuild ~/rpmbuild.bkp
	export RPMBUILDEXISTS=TRUE
else
	export RPMBUILDEXISTS=FALSE
fi

# Create rpmbuild folder structure
mkdir ~/rpmbuild
mkdir ~/rpmbuild/BUILD
mkdir ~/rpmbuild/BUILDROOT
mkdir ~/rpmbuild/RPMS
mkdir ~/rpmbuild/SOURCES
mkdir ~/rpmbuild/SPECS
mkdir ~/rpmbuild/SRPMS

# Create nvtop .spec file with preinstall and postinstall scripts
cat << 'EOF' > $RPMSPEC/nvtop.spec
Name:           nvtop
Version:        0.0.1
Release:        1%{?dist}
Summary:        An NVIDIA Gamestream-compatible hosting server
BuildArch:      x86_64

License:        GPLv3
URL:            https://github.com/thatsysadmin/nvtop
Source0:        nvtop-0.0.1_bin.tar.gz

Requires:       bash

%description
(h)top like task monitor for AMD and NVIDIA GPUs. It can handle multiple GPUs and print information about them in a htop familiar way.

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{_bindir}
cp nvtop $RPM_BUILD_ROOT/%{_bindir}/nvtop

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/nvtop

%changelog
* Sat Mar 12 2022 h <65380846+thatsysadmin@users.noreply.github.com>
- Initial packaging of nvtop.
EOF

# Copy over nvtop binary and supplemental files into rpmbuild/BUILD/
mkdir genrpm
mkdir genrpm/nvtop-0.0.1
#ls /nvtop/build/src/
cp /nvtop/build/src/nvtop genrpm/nvtop-0.0.1/nvtop
cd genrpm

# tarball everything as if it was a source file for rpmbuild
tar --create --file nvtop-0.0.1_bin.tar.gz nvtop-0.0.1/
mv nvtop-0.0.1_bin.tar.gz ~/rpmbuild/SOURCES

# Use rpmbuild to build the RPM package.
rpmlint ~/rpmbuild/SPECS/nvtop.spec
QA_RPATHS=$(( 0x0001|0x0010 )) rpmbuild -bb $RPMSPEC/nvtop.spec

# Move RPM package into pickup location
mv ~/rpmbuild/RPMS/x86_64/nvtop-0.0.1-1.fc*.x86_64.rpm /nvtop/nvtop.rpm
pwd
ls /nvtop

# Clean up; delete the rpmbuild folder we created and move back the original one
if [ "$RPMBUILDEXISTS" == "TRUE" ]; then
        echo "Removing and replacing original rpmbuild folder."
        rm -rf ~/rpmbuild
        mv ~/rpmbuild.bkp ~/rpmbuild
fi
exit 0