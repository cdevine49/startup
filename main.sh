#!/bin/sh

ALPINE_VERSION=$(grep VERSION_ID /etc/*release* | cut -d '=' -f 2 | cut -d '.' -f 1,2)

uncomment_community_packages()
{
	local pattern="^#.*v${ALPINE_VERSION/\./\\\.}\/community$"
	sed -i "/$pattern/s/^#//" /etc/apk/repositories
}

uncomment_community_packages

apk update
apk add vim=8.2.0-r0

# Switches the Escape and CapsLock keys

swap_esc_and_capslock()
{
	local KEYMAP='/etc/local.d/swap_esc_capslock.kmap'
	local KEYMAP_SCRIPT='/etc/local.d/swap_esc_capslock.start'

	apk add kbd &&
		dumpkeys > /root/backup.kmap &&
		touch $KEYMAP &&
		echo "keymaps 0-127" > $KEYMAP &&
		echo "keycode 1 = CtrlL_Lock" >> $KEYMAP &&
		echo "keycode 58 = Escape" >> $KEYMAP &&
		loadkeys $KEYMAP &&
		chmod +x $KEYMAP &&
		touch $KEYMAP_SCRIPT &&
		echo "/usr/bin/loadkeys /etc/local.d/swap_esc_capslock.kmap" >> $KEYMAP_SCRIPT &&
		rc-update add local default
}

swap_esc_and_capslock

install_docker()
{
	apk add docker &&
	apk add py-pip &&
	pip install docker-compose==1.23.2 &&
	service docker start &&
	rc-update add docker boot
}

install_docker

setup_zsh()
{
	apk add zsh=5.7.1-r0
	sed -i "s/\/bin\/ash/\/bin\/zsh/g" /etc/passwd
}

setup_zsh

# Restricts file permissions

setup-xorg-base && apk add alpine-desktop && apk add xfce4 xfce4-terminal && apk add slim && apk add firefox-esr && apk add xmodmap
rc-service dbus start && rc-update add dbus && rc-service udev start && rc-update add udev && rc-update add slim && reboot
