# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome3 meson

DESCRIPTION="Build molecules, from simple inorganic to extremely complex organic ones"
HOMEPAGE="http://ftp.gnome.org/pub/GNOME/sources/atomix/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=x11-libs/gdk-pixbuf-2.39.2:2
	>=x11-libs/gtk+-3.24.12:3
	dev-libs/libgnome-games-support
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-fnocommon.patch"
	)
