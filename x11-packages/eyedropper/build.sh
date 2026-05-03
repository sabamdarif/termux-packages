TERMUX_PKG_HOMEPAGE="https://github.com/FineFindus/eyedropper"
TERMUX_PKG_DESCRIPTION="Pick and format colors"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.1"
TERMUX_PKG_SRCURL="https://github.com/FineFindus/eyedropper/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="770dddf6e362ed0bd546de8c4a37022ceae16ca4add256a56fe1e371ea38baba"
TERMUX_PKG_DEPENDS="glib, gtk4, libadwaita, libiconv"
TERMUX_PKG_BUILD_DEPENDS="rust, glib-cross"

termux_step_pre_configure() {
    termux_setup_rust
    termux_setup_bpc
    termux_setup_glib_cross_pkg_config_wrapper
    export CARGO_BUILD_TARGET="${CARGO_TARGET_NAME}"
    
    local _RUSTFLAGS_VAR="CARGO_TARGET_${CARGO_TARGET_NAME^^}_RUSTFLAGS"
    _RUSTFLAGS_VAR=${_RUSTFLAGS_VAR//-/_}
    export ${_RUSTFLAGS_VAR}+=" -C link-arg=-liconv"
    
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-Dcross_target=${CARGO_TARGET_NAME} "
}
