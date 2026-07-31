TERMUX_PKG_HOMEPAGE=https://symas.com/lmdb/
TERMUX_PKG_DESCRIPTION="LMDB implements a simplified variant of the BerkeleyDB (BDB) API"
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_LICENSE_FILE="libraries/liblmdb/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL="https://git.openldap.org/openldap/openldap/-/archive/LMDB_${TERMUX_PKG_VERSION}/openldap-LMDB_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a61ded12bd9c670038b77483dda13b50684a93a111e53421dfb979624ae9f72e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="LMDB_\d+.\d+.\d+"
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/LMDB_//"
TERMUX_PKG_EXTRA_MAKE_ARGS="-C libraries/liblmdb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DMDB_USE_ROBUST=0"
}

termux_step_post_make_install() {
	# Upstream generates lmdb.pc, but its install target does not install it.
	install -Dm600 -t $TERMUX_PREFIX/lib/pkgconfig \
		$TERMUX_PKG_SRCDIR/libraries/liblmdb/lmdb.pc
}
