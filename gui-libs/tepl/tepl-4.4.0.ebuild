# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome3 vala virtualx

DESCRIPTION="GtkSourceView-based text editors and IDE helper library"
HOMEPAGE="https://wiki.gnome.org/Projects/Gtef"

LICENSE="LGPL-2.1+"
SLOT="4"
KEYWORDS="*"

IUSE="+introspection test vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=x11-libs/amtk-5.0
	>=dev-libs/glib-2.62.2:2
	>=x11-libs/gtk+-3.24.12:3
	>=x11-libs/gtksourceview-4.0
	>=dev-libs/libxml2-2.5
	app-i18n/uchardet
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	test? ( dev-util/valgrind )
	vala? ( $(vala_depend) )
	>=sys-devel/gettext-0.19.4
	>=dev-util/gtk-doc-am-1.25
	virtual/pkgconfig
"

src_prepare() {
	# requires running gvfs-metadata
	sed -e 's:\(g_test_add_func.*/file/load_save_metadata_sync.*\):/*\1*/:' \
		-e 's:\(g_test_add_func.*/file/load_save_metadata_async.*\):/*\1*/:' \
		-e 's:\(g_test_add_func.*/file/set_without_load.*\):/*\1*/:' \
		-i testsuite/test-file-metadata.c || die

	use vala && vala_src_prepare
	gnome3_src_prepare
}

src_configure() {
	gnome3_src_configure \
		--enable-gvfs-metadata \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(use_enable test valgrind)
}

src_test() {
	virtx emake check
}
