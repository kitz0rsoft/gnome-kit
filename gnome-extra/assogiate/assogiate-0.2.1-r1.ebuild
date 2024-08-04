# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="yes"

inherit autotools eutils flag-o-matic gnome2

DESCRIPTION="assoGiate is an editor of the file types database for GNOME"
HOMEPAGE="http://www.kdau.com/projects/assogiate"
SRC_URI="http://www.kdau.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-cpp/glibmm-2.62.0
	>=dev-cpp/gtkmm-2.24.4-r3:2.4
	>=dev-cpp/libxmlpp-2.40:2.6
	>=dev-cpp/gnome-vfsmm-2.26.0-r1
"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	virtual/pkgconfig
"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	# Fix desktop file
	epatch "${FILESDIR}"/${P}-desktop.patch

	# Fix compilation, bug #374911
	epatch "${FILESDIR}"/${P}-typedialog.patch

	# Fix building with glib-2.32, bug #417765
	epatch "${FILESDIR}"/${P}-glib-2.32.patch

	# Fix building with gcc-4.7
	epatch "${FILESDIR}"/${P}-gcc-4.7.patch

	eautoreconf
	gnome2_src_prepare

	append-cxxflags -std=c++11
}
