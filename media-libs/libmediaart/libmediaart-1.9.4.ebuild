
EAPI="6"

VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.16"

inherit autotools flag-o-matic gnome2 vala virtualx

DESCRIPTION="Manages, extracts and handles media art caches"
HOMEPAGE="https://github.com/GNOME/libmediaart"

LICENSE="LGPL-2.1+"
SLOT="2.0"
KEYWORDS="*"
# gtk/qt5 is only used for mp3 album art -- you have a choice of implementations. We default to gtk+
IUSE="+introspection -qt5 vala"
REQUIRED_USE="
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	!qt5? ( >=x11-libs/gdk-pixbuf-2.39.2:2 )
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
	qt5? ( dev-qt/qtgui:5 )
"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection-common
	>=dev-util/gtk-doc-am-1.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	# Make doc parallel installable
	cd "${S}"/docs/reference/${PN} || die
	sed -e "s/\(DOC_MODULE.*=\).*/\1${PN}-${SLOT}/" \
		-e "s/\(DOC_MAIN_SGML_FILE.*=\).*/\1${PN}-docs-${SLOT}.xml/" \
		-i Makefile.am Makefile.in || die
	sed -e "s/\(<book.*name=\"\)libmediaart/\1${PN}-${SLOT}/" \
		-i html/libmediaart.devhelp2 || die
	mv libmediaart-docs{,-${SLOT}}.xml || die
	mv libmediaart-overrides{,-${SLOT}}.txt || die
	mv libmediaart-sections{,-${SLOT}}.txt || die
	mv html/libmediaart{,-${SLOT}}.devhelp2 || die
	cd "${S}" || die

	eautoreconf

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	if use qt5 ; then
		local myconf="--with-qt-version=5"
		append-cxxflags -std=c++11
	fi

	gnome2_src_configure \
		--enable-unit-tests \
		$(use_enable introspection) \
		$(use_enable qt5 qt) \
		$(use_enable !qt5 gdkpixbuf) \
		$(use_enable vala) \
		${myconf}
}

src_test() {
	dbus-launch virtx emake check #513502
}
