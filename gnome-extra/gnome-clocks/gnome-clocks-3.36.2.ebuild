# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome3 vala meson

DESCRIPTION="Clocks application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Clocks"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=app-misc/geoclue-2.3.1:2.0
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/libgweather-3.13.91:2=[vala]
	>=gnome-base/gnome-desktop-3.34.1:3=
	>=media-libs/gsound-0.98[vala]
	>=sci-geosciences/geocode-glib-0.99.4
	>=x11-libs/gtk+-3.24.12:3
	<dev-libs/libhandy-1.0.0
"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome3_src_prepare
}
