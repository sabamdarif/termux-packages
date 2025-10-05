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

termux_step_host_build() {
	echo "Building minimal kpackagetool6 for host"

	# Set up build environment
	termux_setup_cmake
	termux_setup_ninja

	# Create the cross tools directory
	mkdir -p "$TERMUX_PREFIX/opt/kf6/cross/bin"
	mkdir -p "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/KF6Package"

	# Copy the source directory structure
	cp -r "$TERMUX_PKG_SRCDIR"/* "$TERMUX_PKG_HOSTBUILD_DIR/"

	# Create minimal metainfo.yaml
	cat >"$TERMUX_PKG_HOSTBUILD_DIR/metainfo.yaml" <<-EOF
		maintainer: termux
		description: Framework that lets applications manage user installable packages of non-binary assets
		tier: 3
		type: functional
		platforms:
		    - name: Linux
		portingAid: false
		deprecated: false
		release: true
	EOF

	# Modify the original CMakeLists.txt to work for host build instead of creating new one
	# sed -i 's/include(ECMGenerateQDoc)/include(ECMGenerateQDoc OPTIONAL RESULT_VARIABLE ECMGenerateQDoc_FOUND)/' "$TERMUX_PKG_HOSTBUILD_DIR/CMakeLists.txt"
	# sed -i '/if (KF6DocTools_FOUND)/,/endif()/d' "$TERMUX_PKG_HOSTBUILD_DIR/CMakeLists.txt"
	# sed -i '/kde_configure_git_pre_commit_hook/d' "$TERMUX_PKG_HOSTBUILD_DIR/CMakeLists.txt"
	# # Disable tests & examples
	# sed -i '/add_subdirectory(autotests)/d' "$TERMUX_PKG_HOSTBUILD_DIR/CMakeLists.txt"
	# sed -i '/mockhandler/d' "$TERMUX_PKG_HOSTBUILD_DIR/CMakeLists.txt"
	# sed -i 's/ki18n_install(po)//g' "$TERMUX_PKG_HOSTBUILD_DIR/CMakeLists.txt"
	# sed -i 's/kdoctools_install(po)//g' "$TERMUX_PKG_HOSTBUILD_DIR/CMakeLists.txt"

	# Add the platform check override at the top
	# sed -i '/^project(KPackage VERSION/a\\n# Skip platform check for host build\nset(KF_IGNORE_PLATFORM_CHECK TRUE)\n' "$TERMUX_PKG_HOSTBUILD_DIR/CMakeLists.txt"

	# Remove qdoc generation from src subdirectories
	# find "$TERMUX_PKG_HOSTBUILD_DIR" -name "CMakeLists.txt" -exec sed -i '/ecm_generate_qdoc/d' {} \;

	echo "Created kpackagetool6 at $TERMUX_PREFIX/opt/kf6/cross/bin/kpackagetool6"

	# Create a minimal metainfo.yaml to satisfy the platform check
	# cat >"$TERMUX_PKG_HOSTBUILD_DIR/metainfo.yaml" <<-EOF
	# 	maintainer: termux
	# 	description: Framework that lets applications manage user installable packages of non-binary assets
	# 	tier: 2
	# 	type: functional
	# 	platforms:
	# 	    - name: Linux
	# 	portingAid: false
	# 	deprecated: false
	# 	release: true
	# EOF

	sed -i 's/ki18n_install(po)//g' "$TERMUX_PKG_SRCDIR/CMakeLists.txt"

	# Create a modified CMakeLists.txt that can find ECM properly and skip problematic parts
	cat >>"$TERMUX_PKG_SRCDIR/CMakeLists.txt" <<-'EOF'
		cmake_minimum_required(VERSION 3.16)

		set(KF_VERSION "6.18.0") # handled by release scripts
		set(KF_DEP_VERSION "6.18.0") # handled by release scripts
		project(KPackage VERSION ${KF_VERSION})

		# Set up paths to find ECM
		list(APPEND CMAKE_PREFIX_PATH "${TERMUX_PREFIX}")
		list(APPEND CMAKE_PREFIX_PATH "${TERMUX_PREFIX}/share")
		list(APPEND CMAKE_MODULE_PATH "${TERMUX_PREFIX}/share/ECM/cmake")
		list(APPEND CMAKE_MODULE_PATH "${TERMUX_PREFIX}/lib/cmake")
		set(ECM_DIR "${TERMUX_PREFIX}/share/ECM/cmake")

		# Skip platform check for host build
		set(KF_IGNORE_PLATFORM_CHECK TRUE)

		# ECM setup
		include(FeatureSummary)
		find_package(ECM 6.18.0 NO_MODULE)
		if(NOT ECM_FOUND)
		    # Try alternative paths
		    set(CMAKE_MODULE_PATH "${TERMUX_PREFIX}/share/ECM/modules" \${CMAKE_MODULE_PATH})
		    find_package(ECM 6.18.0 NO_MODULE)
		endif()
		if(NOT ECM_FOUND)
		    # Try with exact path
		    find_package(ECM 6.18.0 NO_MODULE HINTS "${TERMUX_PREFIX}/share/ECM/cmake" "${TERMUX_PREFIX}/lib/cmake/ECM")
		endif()

		add_link_options("-Wl,-rpath=${TERMUX_PREFIX}/opt/qt6/cross/lib")
	EOF

	# Configure and build with host compilers
	env -u CC -u CXX -u CFLAGS -u CXXFLAGS -u LDFLAGS \
		cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}/build" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_C_COMPILER=/usr/bin/gcc \
		-DCMAKE_CXX_COMPILER=/usr/bin/g++ \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX" \
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX/opt/kf6/cross" \
		-DCMAKE_MODULE_PATH="$TERMUX_PREFIX/share/ECM/modules" \
		-DKDE_INSTALL_LIBEXECDIR_KF=lib/libexec/kf6 \
		-DKDE_INSTALL_CMAKEPACKAGEDIR=lib/cmake \
		-DTERMUX_PREFIX="$TERMUX_PREFIX" \
		-DBUILD_TESTING=OFF \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DKDE_INSTALL_QMLDIR=lib/qt6/qml \
		-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins

	ninja -C "${TERMUX_PKG_HOSTBUILD_DIR}/build" -j ${TERMUX_PKG_MAKE_PROCESSES}
	ninja -C "${TERMUX_PKG_HOSTBUILD_DIR}/build" install
}
