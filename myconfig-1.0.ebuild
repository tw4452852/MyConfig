# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="myconfig desc"
HOMEPAGE="http://totorow.herokuapp.com"
SRC_URI=""

EGIT_REPO_URI="git://github.com/tw4452852/MyConfig.git"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"
IUSE="tw"

DEPEND=""
RDEPEND="${DEPEND}
	app-shells/zsh
	dev-vcs/git
	dev-vcs/mercurial
	x11-wm/dwm
	mail-client/mutt
	mail-filter/procmail
	net-mail/fetchmail"

src_compile() {
	einfo "Makefile shouldn't be used by emerge"
}

src_install() {
	dodir /opt/${P}
	cp -a ${S}/ ${D}/opt/ || die "source install failed"
	fowners -R root:users /opt/${P}/
	einfo "install ${P} to /opt/${P}"
	dodoc README
}

pkg_postinst() {
	einfo "go into /opt/${P} and make"
}
