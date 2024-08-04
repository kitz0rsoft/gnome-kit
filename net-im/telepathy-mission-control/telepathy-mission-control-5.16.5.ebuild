# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME3_LA_PUNT="yes"
# Needed for tests and build #489466
PYTHON_COMPAT=( python3+ )

inherit gnome3 python-any-r1

DESCRIPTION="An account manager and channel dispatcher for the Telepathy framework"
HOMEPAGE="https://cgit.freedesktop.org/telepathy/telepathy-mission-control/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="debug networkmanager" # test

RDEPEND="
	>=dev-libs/dbus-glib-0.82
	>=dev-libs/glib-2.46:2
	>=sys-apps/dbus-0.95
	>=net-libs/telepathy-glib-0.20
	networkmanager? ( >=net-misc/networkmanager-1:= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.17
	virtual/pkgconfig
"
#	test? ( dev-python/twisted-words )"

# Tests are broken, see upstream bug #29334 and #64212
# upstream doesn't want it enabled everywhere (#29334#c12)
RESTRICT="test"

PATCHES=( "${FILESDIR}/5.16.5-account-fix-property-name.patch" )

src_configure() {
	# creds is not available
	gnome3_src_configure \
		--disable-static \
		--disable-upower \
		$(use_enable debug) \
		$(use_with networkmanager connectivity nm)
}
