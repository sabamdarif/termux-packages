TERMUX_PKG_HOMEPAGE=https://lmms.io
TERMUX_PKG_DESCRIPTION="Cross-platform music production software (digital audio workstation)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.2"
TERMUX_PKG_SRCURL=git+https://github.com/LMMS/lmms.git
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, fluidsynth, libmp3lame, libogg, libsamplerate, libsndfile, libvorbis, libx11, libxcb, pulseaudio, qt5-qtbase, qt5-qtx11extras, sdl, fltk, freetype"
TERMUX_PKG_BUILD_DEPENDS="qt5-qttools, qt5-qtbase-cross-tools"
TERMUX_PKG_FORCE_CMAKE=true
# TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DWANT_QT5=ON
-DWANT_ALSA=OFF
-DWANT_VST=OFF
-DWANT_CARLA=OFF
-DWANT_SNDIO=OFF
-DWANT_STK=OFF
-DWANT_GIG=OFF
-DWANT_SOUNDIO=OFF
-DWANT_PORTAUDIO=OFF
-DWANT_JACK=OFF
-DWANT_SDL=ON
-DWANT_PULSEAUDIO=ON
-DWANT_MP3LAME=ON
-DWANT_OGGVORBIS=ON
-DWANT_SF2=ON
-DWANT_CALF=ON
-DWANT_CAPS=ON
-DWANT_CMT=ON
-DWANT_SWH=ON
-DWANT_TAP=ON
"

termux_step_post_get_source() {
	git submodule update --init --recursive
}

# termux_step_host_build() {
# 	# Build bin2res natively — LMMS uses it to embed binary resources
# 	# into C source files during the build. It cannot be cross-compiled.
# 	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
# 		return
# 	fi

# 	# Clear cross-compilation variables for host build
# 	AR=; CC=; CFLAGS=; CPPFLAGS=; CXX=; CXXFLAGS=; LD=; LDFLAGS=; PKG_CONFIG=; STRIP=

# 	g++ -o "$TERMUX_PKG_HOSTBUILD_DIR/bin2res" \
# 		"$TERMUX_PKG_SRCDIR/buildtools/bin2res.cpp"
# }

termux_step_pre_configure() {
	# Suppress -Werror flags — Clang/NDK is stricter than GCC
	CFLAGS+=" -Wno-error"
	CXXFLAGS+=" -Wno-error"

	# Point the cross-build at the host-built bin2res
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
	fi
}
