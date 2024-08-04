# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 virtualx meson

DESCRIPTION="GNOME power management service"
HOMEPAGE="https://projects.gnome.org/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.62.2:2
	>=x11-libs/gtk+-3.24.12:3
	>=x11-libs/cairo-1
	>=sys-power/upower-0.99:=
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	sys-devel/gettext
	x11-base/xorg-proto
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"
