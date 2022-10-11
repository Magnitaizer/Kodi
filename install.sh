#!/bin/sh

sudo pacman -Syu  --noconfirm
sudo pacman -S kodi --noconfirm
sudo pacman -R pulseaudio pulseaudio-zeroconf pulseaudio-bluetooth pulseaudio-alsa pulseaudio-ctl manjaro-pulse plasma-pa --noconfirm

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

sudo sed -i --follow-symlinks "38s+.*ExecStart.*+ExecStart=-/sbin/agetty -a "$USER' %I $TERM+' /etc/systemd/system/getty.target.wants/getty@tty1.service

sudo sed -i 's+GRUB_TIMEOUT=.*+GRUB_TIMEOUT=0+' /etc/default/grub

sudo update-grub

sudo systemctl enable sshd.service

sudo systemctl disable sddm.service

echo "Installation Successful!"

while true; do
    read -p "Would you like to reboot? [Y/N]" yn
    case $yn in
        [Yy]* ) sudo reboot; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
