# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 virtualx

DESCRIPTION="GtkSourceView-based text editors and IDE helper library"
HOMEPAGE="https://wiki.gnome.org/Projects/Gtef"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="valgrind"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=x11-libs/gtk+-3.24.12:3
	>=dev-libs/gobject-introspection-1.62.0:=
"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )
	>=sys-devel/gettext-0.19.4
	>=dev-util/gtk-doc-am-1.25
	virtual/pkgconfig
"

src_configure() {
	econf $(use_enable valgrind) || die
}

src_test() {
	virtx emake check
}


