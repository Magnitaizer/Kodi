#!/bin/sh

pacman -Syu  --noconfirm
pacman -S kodi --noconfirm
pacman -R pulseaudio pulseaudio-equalizer pulseaudio-jack pulseaudio-lirc pulseaudio-rtp pulseaudio-zeroconf pulseaudio-bluetooth pulseaudio-pa pulseaudio-alsa pulseaudio-ctl manjaro-pulse plasma-pa --noconfirm

if grep -q 'DEFAULT_SESSION=kodi' "/home/$USER/.xinitrc"; then
   echo 'skipping this part...'
else
#  echo 'xset s off -dpms' >> /home/$USER/.xinitrc
   sed -i 's+DEFAULT_SESSION=.*+DEFAULT_SESSION=kodi+' /home/$USER/.xinitrc
fi

if grep -q 'exec startx' "/home/$USER/.bash_profile"; then
  echo 'skipping this part...'
else
  echo ' ' >> /home/$USER/.bash_profile
  echo 'if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]; then' >> /home/$USER/.bash_profile
  echo '     exec startx' >> /home/$USER/.bash_profile
  echo 'fi' >> /home/$USER/.bash_profile
fi

sed -i --follow-symlinks "38s+.*ExecStart.*+ExecStart=-/sbin/agetty -a "$USER' %I $TERM+' /etc/systemd/system/getty.target.wants/getty@tty1.service

sed -i 's+GRUB_TIMEOUT=.*+GRUB_TIMEOUT=0+' /etc/default/grub

update-grub

systemctl enable sshd.service

systemctl disable sddm.service

reboot
