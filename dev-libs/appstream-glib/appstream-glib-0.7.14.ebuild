# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit bash-completion-r1 gnome2 meson

DESCRIPTION="Provides GObjects and helper methods to read and write AppStream metadata"
HOMEPAGE="https://people.freedesktop.org/~hughsient/appstream-glib/"
SRC_URI="https://people.freedesktop.org/~hughsient/${PN}/releases/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/8" # soname version
KEYWORDS="*"
IUSE="doc +introspection stemmer"

RDEPEND="
	app-arch/gcab
	app-arch/libarchive
	dev-db/sqlite:3
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/json-glib-1.1.1
	dev-libs/libyaml
	>=media-libs/fontconfig-2.11:1.0
	>=media-libs/freetype-2.4:2
	>=net-libs/libsoup-2.51.92:2.4
	sys-apps/util-linux
	>=x11-libs/gdk-pixbuf-2.39.2:2[introspection?]
	x11-libs/gtk+:3
	x11-libs/pango
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
	stemmer? ( dev-libs/snowball-stemmer )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.9
	>=sys-devel/gettext-0.19.7
	dev-util/gperf
"
# ${PN} superseeds appdata-tools, require dummy package until all ebuilds
# are migrated to appstream-glib
RDEPEND="${RDEPEND}
	!<dev-util/appdata-tools-0.1.8-r1
"

src_configure() {
	local emesonargs=(
		-Ddep11=true
		-Dbuilder=true
		-Drpm=false
		-Dalpm=false
		-Dfonts=true
		-Dman=true
		$(meson_use doc gtk-doc)
		$(meson_use introspection introspection)
		$(meson_use stemmer stemmer)
	)

	meson_src_configure
}
