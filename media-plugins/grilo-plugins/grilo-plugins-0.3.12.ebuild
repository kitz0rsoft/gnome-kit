# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2+ )

inherit gnome2 python-any-r1 meson

DESCRIPTION="A framework for easy media discovery and browsing"
HOMEPAGE="https://wiki.gnome.org/Projects/Grilo"

LICENSE="LGPL-2.1+"
SLOT="0.3"
KEYWORDS="*"
IUSE="daap dvd examples chromaprint flickr freebox lua subtitles test thetvdb tracker upnp-av vimeo +youtube"

# Bump gom requirement to avoid segfaults
RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=media-libs/grilo-0.3.1:${SLOT}=[network,playlist]
	media-libs/libmediaart:2.0
	>=dev-libs/gom-0.3.2

	>=dev-libs/gmime-3
	dev-libs/json-glib
	dev-libs/libxml2:2
	dev-db/sqlite:3

	chromaprint? ( media-libs/gstreamer:1.0 )
	daap? ( >=net-libs/libdmapsharing-2.9.12:3.0 )
	dvd? ( >=dev-libs/totem-pl-parser-3.4.1 )
	flickr? ( net-libs/liboauth )
	freebox? ( net-dns/avahi )
	>=net-libs/gnome-online-accounts-3.17.91:=
	lua? (
		>=dev-lua/lua-5.3
		app-arch/libarchive
		dev-libs/libxml2:2
		>=dev-libs/totem-pl-parser-3.4.1 )
	subtitles? ( net-libs/libsoup:2.4 )
	thetvdb? (
		app-arch/libarchive
		dev-libs/libxml2 )
	tracker? ( >=app-misc/tracker-0.10.5:= )
	youtube? (
		>=dev-libs/libgdata-0.9.1:=
		>=dev-libs/totem-pl-parser-3.4.1 )
	upnp-av? (
		net-libs/libsoup:2.4
		net-libs/dleyna-connector-dbus
		net-misc/dleyna-server )
	vimeo? (
		>=dev-libs/totem-pl-parser-3.4.1 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/yelp-tools
	>=dev-util/gdbus-codegen-2.44
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	lua? ( dev-util/gperf )
	upnp-av? ( test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/dbusmock[${PYTHON_USEDEP}]') ) )
"

python_check_deps() {
	use upnp-av && use test && has_version "dev-python/dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use upnp-av && use test && python-any-r1_pkg_setup
}

src_prepare () {
	gnome2_src_prepare
}

# FIXME: some unittests required python-dbusmock
src_configure() {
	# --enable-debug only changes CFLAGS, useless for us
	# Plugins
	# shoutcast seems to be broken
	local emesonargs=(
		-Denable-bookmarks=yes
		-Denable-filesystem=yes
		-Denable-gravatar=yes
		-Denable-jamendo=yes
		-Denable-local-metadata=yes
		-Denable-magnatune=yes
		-Denable-metadata-store=yes
		-Denable-podcasts=yes
		-Denable-raitv=yes
		-Denable-shoutcast=no
		-Denable-tmdb=yes
		-Denable-chromaprint=$(usex chromaprint yes no)
		-Denable-dmap=$(usex daap yes no)
		-Denable-optical-media=$(usex dvd yes no)
		-Denable-flickr=$(usex flickr yes no)
		-Denable-freebox=$(usex freebox yes no)
		-Denable-lua-factory=$(usex lua yes no)
		-Denable-opensubtitles=$(usex subtitles yes no)
		-Denable-thetvdb=$(usex thetvdb yes no)
		-Denable-tracker=$(usex tracker yes no)
		-Denable-dleyna=$(usex upnp-av yes no)
		-Denable-vimeo=$(usex vimeo yes no)
		-Denable-youtube=$(usex youtube yes no)
	)

	meson_src_configure
}

src_install() {
	if use examples; then
		docinto examples
		doins help/examples/*.c
	fi

	meson_src_install \
		DOC_MODULE_VERSION=${SLOT%/*} \
		HELP_ID="grilo-plugins-${SLOT%/*}" \
		HELP_MEDIA=""

	# The above doesn't work and collides with 0.2 slot
	mv "${ED}"/usr/share/help/C/examples/example-tmdb{,-0.3}.c || die
	mv "${ED}"/usr/share/help/C/grilo-plugins/legal{,-0.3}.xml || die
	mv "${ED}"/usr/share/help/C/grilo-plugins/grilo-plugins{,-0.3}.xml || die
}
