# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"
GNOME3_EAUTORECONF="yes"

inherit gnome3 meson vala

DESCRIPTION="GLib-based library for accessing online service APIs using the GData protocol"
HOMEPAGE="https://wiki.gnome.org/Projects/libgdata"

LICENSE="LGPL-2.1+"
SLOT="0/22" # subslot = libgdata soname version

IUSE="+crypt gnome-online-accounts gtk gtk-doc +introspection test vala"
# needs dconf
RESTRICT="test"

REQUIRED_USE="
	gnome-online-accounts? ( crypt )
	vala? ( introspection )
"

KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/json-glib-1[introspection?]
	>=dev-libs/libxml2-2:2
	>=net-libs/liboauth-0.9.4
	>=net-libs/libsoup-2.55.90:2.4[introspection?]
	gtk? ( x11-libs/gtk+:3 )
	crypt? ( app-crypt/gcr:= )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.36:=[introspection?,vala?] )
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.25
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	test? ( >=net-libs/uhttpmock-0.5
		>=x11-libs/gdk-pixbuf-2.39.2:2 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	eapply_user
}

src_configure() {
	local emesonargs=(
		"-Dinstalled_tests=false"
		-Dgnome=$(usex crypt enabled disabled)
		-Dgoa=$(usex gnome-online-accounts enabled disabled)
		-Dgtk=$(usex gtk enabled disabled)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use gtk-doc man)
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use test always_build_tests)
	)

	meson_src_configure
}

src_test() {
	meson_src_test
}

pkg_postinst() {
	gnome3_pkg_postinst
}

pkg_postrm() {
	gnome3_pkg_postrm
}
