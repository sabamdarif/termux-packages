TERMUX_PKG_HOMEPAGE=https://github.com/debasish-patra-1987/linuxthemestore
TERMUX_PKG_DESCRIPTION="A Linux desktop app to install Linux themes"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="sabamdarif"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=git+https://github.com/sabamdarif/linuxthemestore
TERMUX_PKG_GIT_BRANCH=termux
TERMUX_PKG_DEPENDS="libadwaita, gtk4"
TERMUX_PKG_BUILD_DEPENDS="glib, openssl, pkg-config, xorgproto, pango"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=false

termux_step_post_get_source() {
	# Remove meson-specific files if they exist
	rm -f "$TERMUX_PKG_SRCDIR/meson.build"
	rm -rf "$TERMUX_PKG_SRCDIR/build-aux"
}

termux_step_make() {
	termux_setup_rust

	export PKG_CONFIG_PATH="$TERMUX_PREFIX/lib/pkgconfig"
	export OPENSSL_DIR="$TERMUX_PREFIX"
	export OPENSSL_INCLUDE_DIR="$TERMUX_PREFIX/include"
	export OPENSSL_LIB_DIR="$TERMUX_PREFIX/lib"
	export LD_LIBRARY_PATH="$TERMUX_PREFIX/lib:${LD_LIBRARY_PATH:-}"
	export PATH="$HOME/.cargo/bin:$PATH"

	# Move to source directory to ensure Cargo.toml is found
	cd "$TERMUX_PKG_SRCDIR"

	cargo update
	cargo fetch --manifest-path Cargo.toml
	cargo build --release --target "${CARGO_TARGET_NAME}"
}

termux_step_make_install() {
	# Install the binary
	install -Dm755 "$TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/linuxthemestore" \
		"$TERMUX_PREFIX/bin/linuxthemestore"

	# Install metainfo file
	install -Dm644 "$TERMUX_PKG_SRCDIR/assets/io.github.debasish_patra_1987.linuxthemestore.metainfo.xml" \
		"$TERMUX_PREFIX/share/metainfo/io.github.debasish_patra_1987.linuxthemestore.metainfo.xml"

	# Install icon
	install -Dm644 "$TERMUX_PKG_SRCDIR/assets/io.github.debasish_patra_1987.linuxthemestore.svg" \
		"$TERMUX_PREFIX/share/icons/hicolor/scalable/apps/io.github.debasish_patra_1987.linuxthemestore.svg"

	# Generate and install .desktop file
	sed "s|@bindir@|$TERMUX_PREFIX/bin|" "$TERMUX_PKG_SRCDIR/assets/io.github.debasish_patra_1987.linuxthemestore.in" \
		>"$TERMUX_PKG_SRCDIR/assets/io.github.debasish_patra_1987.linuxthemestore.desktop"

	install -Dm644 "$TERMUX_PKG_SRCDIR/assets/io.github.debasish_patra_1987.linuxthemestore.desktop" \
		"$TERMUX_PREFIX/share/applications/io.github.debasish_patra_1987.linuxthemestore.desktop"
}
