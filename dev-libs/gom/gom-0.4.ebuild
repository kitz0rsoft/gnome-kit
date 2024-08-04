# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python3+ )

inherit gnome2 python-r1 meson

DESCRIPTION="GObject to SQLite object mapper library"
HOMEPAGE="https://wiki.gnome.org/Projects/Gom"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="+introspection"

RDEPEND="
	>=dev-db/sqlite-3.7:3
	>=dev-libs/glib-2.62.2:2
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
	>=dev-python/pygobject-3.16:3
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
	x11-libs/gdk-pixbuf:2
"
# TODO: make gdk-pixbuf properly optional with USE=test

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	local emasonargs=(
		$(meson_use introspection introspection)
	)
	python_foreach_impl meson_src_configure
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_install() {
	python_foreach_impl meson_src_install
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postinst() {
	gnome2_pkg_postinst
	gnome2_schemas_update
}
