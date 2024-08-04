# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit autotools gnome2

DESCRIPTION="Lightweight HTML rendering/printing/editing engine"
HOMEPAGE="https://git.gnome.org/browse/gtkhtml"

LICENSE="GPL-2+ LGPL-2+"
SLOT="4.0"
KEYWORDS="*"
IUSE=""

# orbit is referenced in configure, but is not used anywhere else
RDEPEND="
	>=x11-libs/gtk+-3.24.12:3
	>=x11-libs/cairo-1.16.0:=
	x11-libs/pango
	>=app-text/enchant-1.1.7:=
	gnome-base/gsettings-desktop-schemas
	>=app-text/iso-codes-0.49
	>=net-libs/libsoup-2.26.0:2.4
"
DEPEND="${RDEPEND}
	x11-proto/xproto
	sys-devel/gettext
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-enchant2.patch
	eautoreconf
}

src_configure() {
	gnome2_src_configure --disable-static
}

src_install() {
	gnome2_src_install

	# Don't collide with 3.14 slot
	mv "${ED}"/usr/bin/gtkhtml-editor-test{,-${SLOT}} || die
}
