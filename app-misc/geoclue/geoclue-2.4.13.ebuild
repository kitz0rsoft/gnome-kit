# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2 systemd user

DESCRIPTION="A geoinformation D-Bus service"
HOMEPAGE="https://freedesktop.org/wiki/Software/GeoClue"
SRC_URI="https://gitlab.freedesktop.org/geoclue/${PN}/-/archive/${PV}/${P}.tar.bz2"


LICENSE="LGPL-2"
SLOT="2.0"
KEYWORDS="*"
IUSE="+introspection +modemmanager zeroconf"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/json-glib-0.14
	>=net-libs/libsoup-2.42:2.4
	sys-apps/dbus
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
	modemmanager? ( >=net-misc/modemmanager-1 )
	zeroconf? ( >=net-dns/avahi-0.6.10[dbus] )
	!<sci-geosciences/geocode-glib-3.10.0
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.40
	>=x11-libs/libnotify-0.7
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.4.1-fix-GLIBC-features.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# debug only affects CFLAGS
	gnome2_src_configure \
		--enable-backend \
		--with-dbus-service-user=geoclue \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		$(use_enable introspection) \
		$(use_enable modemmanager 3g-source) \
		$(use_enable modemmanager cdma-source) \
		$(use_enable modemmanager modem-gps-source) \
		$(use_enable zeroconf nmea-source)
}

pkg_preinst() {
	enewgroup geoclue
	enewuser geoclue -1 -1 /var/lib/geoclue geoclue
	gnome2_pkg_preinst
}
