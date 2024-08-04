# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.28"

inherit gnome3 linux-info readme.gentoo-r1 vala meson

DESCRIPTION="Simple GNOME 3 application to access remote or virtual systems"
HOMEPAGE="https://wiki.gnome.org/Apps/Boxes"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"

# We force 'bindist' due to licenses from gnome-boxes-nonfree
IUSE="rdp" #bindist

# NOTE: sys-fs/* stuff is called via exec()
# FIXME: ovirt is not available in tree
# FIXME: use vala.eclass but only because of libgd not being able
#        to use its pre-generated files so do not copy all the
#        vala deps like live ebuild has.
# FIXME: qemu probably needs to depend on spice[smartcard]
#        directly with USE=spice
RDEPEND="
	>=app-arch/libarchive-3:=
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/gobject-introspection-1.62.0:=
	>=dev-libs/libxml2-2.7.8:2
	>=sys-libs/libosinfo-1.7.0
	>=sys-apps/osinfo-db-20190319
	>=app-emulation/qemu-1.3.1[spice,smartcard,usbredir]
	>=app-emulation/libvirt-0.9.3[libvirtd,qemu]
	>=app-emulation/libvirt-glib-3.0.0
	>=app-emulation/libgovirt-0.3.4
	>=x11-libs/gtk+-3.24.12:3
	>=net-libs/gtk-vnc-0.4.4
	app-crypt/libsecret[vala]
	app-emulation/spice[smartcard]
	>=net-misc/spice-gtk-0.32[gtk3,smartcard,usbredir,vala]
	virtual/libusb:1

	rdp? ( net-misc/freerdp )
	>=app-misc/tracker-0.16:0=

	>=sys-apps/util-linux-2.20
	>=net-libs/libsoup-2.38:2.4

	sys-fs/mtools
	>=virtual/libgudev-165:=
"
#	!bindist? ( gnome-extra/gnome-boxes-nonfree )

DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/yelp-tools
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="Before running gnome-boxes, you will need to load the KVM modules.
If you have an Intel Processor, run:
# modprobe kvm-intel

If you have an AMD Processor, run:
# modprobe kvm-amd"

pkg_pretend() {
	linux-info_get_any_version

	if linux_config_exists; then
		if ! { linux_chkconfig_present KVM_AMD || \
			linux_chkconfig_present KVM_INTEL; }; then
			ewarn "You need KVM support in your kernel to use GNOME Boxes!"
		fi
	fi
}

src_prepare() {
	vala_src_prepare
	gnome3_src_prepare
}

src_configure() {
	# debug needed for splitdebug proper behavior (cardoe), bug #????
	local emesonargs=(
		$(meson_use rdp rdp)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome3_pkg_postinst
	readme.gentoo_print_elog
}
