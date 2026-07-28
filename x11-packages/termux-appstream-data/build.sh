TERMUX_PKG_HOMEPAGE=https://github.com/sabamdarif/termux-appstream-data
TERMUX_PKG_DESCRIPTION="AppStream metadata generated from the Termux apt repositories"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.07.27"
_base_url="https://github.com/sabamdarif/termux-appstream-data/releases/download/v${TERMUX_PKG_VERSION}"
TERMUX_PKG_SRCURL=(
	"$_base_url/appstream-main.tar.gz"
	"$_base_url/appstream-root.tar.gz"
	"$_base_url/appstream-x11.tar.gz"
)
TERMUX_PKG_SHA256=(
	"45fe1b8ccc160c9558fb7b8a4f9a715f8bad16bfb40fa2deb5a76927fb91d3f3"
	"59230e40da77b043c155431868042bae7d2f4cac3341eca7348da51c21ca0a3f"
	"6526256a10a7dd219f262c90f41f12751ea90e5c3d9d28f4c71f36b4bc0f7a13"
)

termux_step_make_install() {
	local _swcatalog="$TERMUX_PREFIX/share/swcatalog"
	local _d _origin _t _size _found=false

	mkdir -p "$_swcatalog/xml"

	while read -r _d; do
		_origin="termux-$(basename "$(dirname "$_d")")-$(basename "$_d")"

		if [ ! -f "$_d/Components-$TERMUX_ARCH.xml.gz" ]; then
			echo "Skipping $_origin: no $TERMUX_ARCH metadata"
			continue
		fi
		_found=true
		install -Dm644 "$_d/Components-$TERMUX_ARCH.xml.gz" "$_swcatalog/xml/$_origin.xml.gz"

		for _t in "$_d"/icons-*.tar.gz; do
			[ -f "$_t" ] || continue
			_size=$(basename "$_t" .tar.gz)
			_size=${_size#icons-}
			mkdir -p "$_swcatalog/icons/$_origin/$_size"
			tar -xzf "$_t" -C "$_swcatalog/icons/$_origin/$_size"
		done
	done < <(find "$TERMUX_PKG_SRCDIR/data" -mindepth 2 -maxdepth 2 -type d | sort)

	if [ "$_found" != true ]; then
		termux_error_exit "No AppStream metadata found for $TERMUX_ARCH."
	fi
}
