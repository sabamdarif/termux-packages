TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Framework that lets applications manage user installable packages of non-binary assets'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.18.0"
TERMUX_PKG_REVISION=1
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kpackage-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1bc2e43bf2239dc20e836b70877631e103057fb14a9467290c76fa45ff02870e
TERMUX_PKG_DEPENDS="kf6-karchive (>= ${_KF6_MINOR_VERSION}), kf6-kcoreaddons (>= ${_KF6_MINOR_VERSION}), kf6-ki18n (>= ${_KF6_MINOR_VERSION}), libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${_KF6_MINOR_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

# NOTE: THIS PART IS NOT WORKING, unfinished.
termux_step_host_build() {
	# CMakeLists.txt
	cp "$TERMUX_PKG_SRCDIR/CMakeLists.txt" "$TERMUX_PKG_SRCDIR/CMakeLists.txt.bak"
	sed -i '/project(/q' "$TERMUX_PKG_SRCDIR/CMakeLists.txt" # keep project(KPackage VERSION ...) to denote the version
	cat >> "$TERMUX_PKG_SRCDIR/CMakeLists.txt" <<-'EOF'

	include(ECMSetupVersion)

	set(kpackage_version_header "${CMAKE_CURRENT_BINARY_DIR}/src/core/kpackage_version.h")
	ecm_setup_version(PROJECT VARIABLE_PREFIX KPACKAGE
							VERSION_HEADER "${kpackage_version_header}")

	find_package(Qt6 REQUIRED COMPONENTS Core Widgets Xml)

	function(ecm_mark_nongui_executable)
	endfunction()

	add_link_options("-Wl,-rpath=${TERMUX_PREFIX}/opt/qt6/cross/lib")
	add_subdirectory(src/kpackage_tools)
	EOF
	sed -e 's|#include "../core/kpackage_version.h"|#include "'"$TERMUX_PKG_HOSTBUILD_DIR"'/src/core/kpackage_version.h"|' -i "$TERMUX_PKG_SRCDIR/src/kpackage_tools/kpackage_tools.cpp"
	# build
	termux_setup_cmake
	termux_setup_ninja
	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX/opt/qt6/cross/lib/cmake" \
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX/opt/kf6/cross" \
		-DCMAKE_MODULE_PATH="$TERMUX_PREFIX/share/ECM/modules" \
		-DKDE_INSTALL_LIBEXECDIR_KF=lib/libexec/kf6 \
		-DKDE_INSTALL_CMAKEPACKAGEDIR=lib/cmake \
		-DTERMUX_PREFIX="$TERMUX_PREFIX"
	ninja \
		-j ${TERMUX_PKG_MAKE_PROCESSES} \
		install
	# recover the CMakeLists.txt
	mv "$TERMUX_PKG_SRCDIR/CMakeLists.txt.bak" "$TERMUX_PKG_SRCDIR/CMakeLists.txt"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	cp -r "$TERMUX_PREFIX/lib/cmake/KF6Package" "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	sed -e 's|_IMPORT_PREFIX "'"$TERMUX_PREFIX"'"|_IMPORT_PREFIX "'"$TERMUX_PREFIX"'/opt/kf6/cross"|' -i "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/KF6Package/KF6PackageToolsTargets.cmake"
	sed -e 's|'"$TERMUX_PREFIX"'/lib/libexec/kf6/kpackage_tools_kf6|'"$TERMUX_PREFIX"'/opt/kf6/cross/lib/libexec/kf6/kpackage_tools_kf6|' -i "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/KF6Package/KF6PackageToolsTargets-release.cmake"
}
