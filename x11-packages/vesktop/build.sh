TERMUX_PKG_HOMEPAGE="https://github.com/Vencord/Vesktop"
TERMUX_PKG_DESCRIPTION="A standalone Electron-based Discord app with Vencord & improved Linux support"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.5"
TERMUX_PKG_SRCURL="https://github.com/Vencord/Vesktop/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="4bb9b5e1acaf17a5f145931008fe4015f9b8c1116b769e1a55a68d5483f238fc"
TERMUX_PKG_DEPENDS="electron-for-vesktop, libnotify"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

_setup_nodejs() {
	termux_setup_nodejs
	# Ensure pnpm is installed
	npm install -g pnpm
}

termux_step_host_build() {
	_setup_nodejs
	npm install node-gyp
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/node_modules/.bin:$PATH"
}

termux_step_configure() {
	_setup_nodejs
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/node_modules/.bin:$PATH"
}

termux_step_make() {
	export npm_config_nodedir="$TERMUX_PREFIX/lib/vesktop/node_headers"
	export npm_config_target="40.4.0"
	export npm_config_arch="${TERMUX_ARCH}"

	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		export npm_config_arch="arm64"
	elif [ "$TERMUX_ARCH" = "arm" ]; then
		export npm_config_arch="arm"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		export npm_config_arch="x64"
	fi

	pnpm i --frozen-lockfile
	pnpm package:dir
}

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/lib/vesktop/resources"

	local folder
	case "${TERMUX_ARCH}" in
	"aarch64") folder="linux-arm64-unpacked" ;;
	"x86_64") folder="linux-unpacked" ;;
	"arm") folder="linux-armv7l-unpacked" ;; # Guessed based on typical electron-builder targets
	*) folder="linux-unpacked" ;;
	esac

	# Copy resources from electron-builder output
	cp -R dist/${folder}/resources/* "$TERMUX_PREFIX/lib/vesktop/resources/"

	# Create wrapper script in bin
	mkdir -p "$TERMUX_PREFIX/bin"
	cat <<EOF >"$TERMUX_PREFIX/bin/vesktop"
#!/bin/sh
exec "$TERMUX_PREFIX/lib/vesktop/vesktop" "\$@"
EOF
	chmod +x "$TERMUX_PREFIX/bin/vesktop"

	# Install desktop file and icon
	mkdir -p "$TERMUX_PREFIX/share/applications"
	mkdir -p "$TERMUX_PREFIX/share/icons/hicolor/scalable/apps"

	install -Dm644 "build/icon.svg" "$TERMUX_PREFIX/share/icons/hicolor/scalable/apps/vesktop.svg"

	# A basic desktop file
	cat <<EOF >"$TERMUX_PREFIX/share/applications/vesktop.desktop"
[Desktop Entry]
Name=Vesktop
Comment=Vesktop Discord Client
Exec=vesktop %U
Icon=vesktop
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
EOF
}
