TERMUX_PKG_HOMEPAGE=https://github.com/ximion/appstream-generator
TERMUX_PKG_DESCRIPTION="A fast AppStream metadata generator"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.2"
TERMUX_PKG_SRCURL=https://github.com/ximion/appstream-generator/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cfafd3de39e124208123591e83f3165e40196edb9aa6acc536dc2cea5662ec81
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="appstream, glib, libarchive, libc++, libcurl, libfyaml, libicu, liblmdb, libtbb, libxml2, optipng"
TERMUX_PKG_BUILD_DEPENDS="inja"
TERMUX_PKG_SUGGESTS="ffmpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--wrap-mode=nodownload
-Dbackward=false
-Ddownload-js=false
-Dmaintainer=false
"
