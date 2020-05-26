#!/bin/bash

## Author: Aditya Shakya
## This script will download needed AUR pkgs, build them and automatically setup localrepo for this custom archlinux iso.

#colors
R='\033[1;31m'
B='\033[1;34m'
C='\033[0;36m'
G='\033[1;32m'
W='\033[1;37m'
Y='\033[1;33m'

DIR="$(pwd)"
PKG1="colorpicker"
PKG2="betterlockscreen"
PKG3="ksuperkey"
PKG4="networkmanager-dmenu-git"
PKG5="obmenu-generator"
PKG6="perl-linux-desktopfiles"
PKG7="plymouth"
PKG8="polybar"
PKG9="yay"

## Banner
echo
echo -e $B"┌──────────────────────────────────┐"
echo -e $B"│   $R┏━┓┏━┓┏━╸╻ ╻   ╻  ╻┏┓╻╻ ╻╻ ╻   $B│"
echo -e $B"│   $R┣━┫┣┳┛┃  ┣━┫   ┃  ┃┃┗┫┃ ┃┏╋┛   $B│"
echo -e $B"│   $R╹ ╹╹┗╸┗━╸╹ ╹   ┗━╸╹╹ ╹┗━┛╹ ╹   $B│"
echo -e $B"└──────────────────────────────────┘"
echo -e $W" By:$C Aditya Shakya"
echo -e $W" Github:$C @adi1090x"
echo -e $W" Reddit:$C @adi1090x"
echo

## Setting Things Up
echo
echo -e $Y"[*] Installing Dependencies - "$C
echo
sudo pacman -Sy git archiso --noconfirm
echo
echo -e $G"[*] Succesfully Installed."$C
echo
echo -e $Y"[*] Modifying /usr/bin/mkarchiso - "$C
sudo cp /usr/bin/mkarchiso{,.bak} && sudo sed -i -e 's/-c -G -M/-i -c -G -M/g' /usr/bin/mkarchiso
echo
echo -e $G"[*] Succesfully Modified."$C
echo

## Cloning AUR Packages
cd $DIR/pkgs

echo -e $Y"[*] Downloading AUR Packages - "$C
echo
echo -e $Y"[*] Cloning colorpicker - "$C
git clone https://aur.archlinux.org/colorpicker.git --depth 1 $PKG1
echo
echo -e $Y" [*] Cloning betterlockscreen - "$C
git clone https://aur.archlinux.org/betterlockscreen.git --depth 1 $PKG2
echo
echo -e $Y"[*] Cloning ksuperkey - "$C
git clone https://aur.archlinux.org/ksuperkey.git --depth 1 $PKG3
echo
echo -e $Y"[*] Cloning networkmanager-dmenu-git - "$C
git clone https://aur.archlinux.org/networkmanager-dmenu-git.git --depth 1 $PKG4
echo
echo -e $Y"[*] Cloning obmenu-generator - "$C
git clone https://aur.archlinux.org/obmenu-generator.git --depth 1 $PKG5
echo
echo -e $Y"[*] Cloning perl-linux-desktopfiles - "$C
git clone https://aur.archlinux.org/perl-linux-desktopfiles.git --depth 1 $PKG6
echo
echo -e $Y"[*] Cloning plymouth - "$C
git clone https://aur.archlinux.org/plymouth.git --depth 1 $PKG7
echo
echo -e $Y"[*] Cloning polybar - "$C
git clone https://aur.archlinux.org/polybar.git --depth 1 $PKG8
echo
echo -e $Y"[*] Cloning yay - "$C
git clone https://aur.archlinux.org/yay.git --depth 1 $PKG9
echo
echo -e $G"[*] Downloaded Successfully."$C
echo

## Building AUR Packages
mkdir -p ../localrepo/i686 ../localrepo/x86_64

echo -e $Y"[*] Building AUR Packages - "$C
echo

echo -e $Y"[*] Building $PKG1 - "$C
cd $PKG1 && makepkg -s
mv *.pkg.tar.xz ../../localrepo/x86_64
cd ..

echo -e $Y"[*] Building $PKG2 - "$C
cd $PKG2 && makepkg -s
mv *.pkg.tar.xz ../../localrepo/x86_64
cd ..

echo -e $Y"[*] Building $PKG3 - "$C
cd $PKG3 && makepkg -s
mv *.pkg.tar.xz ../../localrepo/x86_64
cd ..

echo -e $Y"[*] Building $PKG4 - "$C
cd $PKG4 && makepkg -s
mv *.pkg.tar.xz ../../localrepo/x86_64
cd ..

echo -e $Y"[*] Building $PKG5 - "$C
cd $PKG5 && makepkg -s
mv *.pkg.tar.xz ../../localrepo/x86_64
cd ..

echo -e $Y"[*] Building $PKG6 - "$C
cd $PKG6 && makepkg -s
mv *.pkg.tar.xz ../../localrepo/x86_64
cd ..

echo -e $Y"[*] Building $PKG7 - "$C
cd $PKG7
cp -r $DIR/pkgs/miniloop $DIR/pkgs/$PKG7
sed -i '$d' PKGBUILD
cat >> PKGBUILD <<EOL
  sed -i -e 's/Theme=.*/Theme=miniloop/g' \$pkgdir/etc/plymouth/plymouthd.conf
  sed -i -e 's/ShowDelay=.*/ShowDelay=1/g' \$pkgdir/etc/plymouth/plymouthd.conf
  cp -r ../../miniloop \$pkgdir/usr/share/plymouth/themes
}
EOL
sum1=$(md5sum lxdm-plymouth.service |  awk -F ' ' '{print $1}')
cat > lxdm-plymouth.service <<EOL
[Unit]
Description=LXDE Display Manager
Conflicts=getty@tty1.service
After=systemd-user-sessions.service getty@tty1.service plymouth-quit.service

[Service]
ExecStart=/usr/sbin/lxdm
Restart=always
IgnoreSIGPIPE=no

[Install]
Alias=display-manager.service
EOL
sum2=$(md5sum lxdm-plymouth.service |  awk -F ' ' '{print $1}')
sed -i -e "s/$sum1/$sum2/g" PKGBUILD
makepkg -s
mv *.pkg.tar.xz ../../localrepo/x86_64
cd ..

echo -e $Y"[*] Building $PKG8 - "$C
cd $PKG8 && makepkg -s
mv *.pkg.tar.xz ../../localrepo/x86_64
cd ..

echo -e $Y"[*] Building $PKG9 - "$C
cd $PKG9 && makepkg -s
mv *.pkg.tar.xz ../../localrepo/x86_64
cd ..

echo
echo -e $G"[*] All Packages Builted Successfully."$C
echo

## Setting up LocalRepo
cd $DIR/localrepo/x86_64
echo -e $Y"[*] Setting Up Local Repository - "$C
echo
repo-add localrepo.db.tar.gz *
echo
echo -e $Y"[*] Appending Repo Config in Pacman file - "$C
echo
echo "[localrepo]" >> $DIR/iso/pacman.conf
echo "SigLevel = Optional TrustAll" >> $DIR/iso/pacman.conf
echo "Server = file://$DIR/localrepo/\$arch" >> $DIR/iso/pacman.conf
echo

## Setting up oh-my-zsh
echo -e $Y"[*] Setting Up Oh-My-Zsh - "$C
echo
cd $DIR/iso/airootfs/etc/skel && git clone https://github.com/robbyrussell/oh-my-zsh.git --depth 1 .oh-my-zsh
cp $DIR/pkgs/agnoster_alt.zsh-theme $DIR/iso/airootfs/etc/skel/.oh-my-zsh/custom/themes
cp $DIR/iso/airootfs/etc/skel/.oh-my-zsh/templates/zshrc.zsh-template $DIR/iso/airootfs/etc/skel/.zshrc
sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="agnoster_alt"/g' $DIR/iso/airootfs/etc/skel/.zshrc
cat >> $DIR/iso/airootfs/etc/skel/.zshrc <<EOL
# omz
alias zshconfig="geany ~/.zshrc"
alias ohmyzsh="thunar ~/.oh-my-zsh"

# ls
alias l='ls -lh'
alias ll='ls -lah'
alias la='ls -A'
alias lm='ls -m'
alias lr='ls -R'
alias lg='ls -l --group-directories-first'

# git
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push origin master'
EOL
cp -r $DIR/iso/airootfs/etc/skel/.oh-my-zsh $DIR/iso/airootfs/root && cp $DIR/iso/airootfs/etc/skel/.zshrc $DIR/iso/airootfs/root
echo
echo -e $R"[*] Done."
echo

## Changing ownership to root to avoid false permissions error
echo -e $Y"[*] Making owner ROOT to avoid problems with false permissions."$C
sudo chown -R root:root $DIR/iso/
echo

echo -e $Y"[*] Cleaning Up... "$C
cd $DIR/pkgs
rm -rf $PKG1 $PKG2 $PKG3 $PKG4 $PKG5 $PKG6 $PKG7 $PKG8 $PKG9
echo
echo -e $R"[*] Setup Completed."
echo
exit
