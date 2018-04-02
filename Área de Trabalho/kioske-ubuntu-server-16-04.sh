#!/bin/bash
echo "Script de Instalação do Kioske com Ubuntu 16.04"
echo "1-Atualizando sistema..."
apt update >> /dev/null 2>&1
apt upgrade >> /dev/null 2>&1

echo "2-Instalando dependências..."
apt install --no-install-recommends xorg openbox pulseaudio -y >> /dev/null 2>&1
apt-get install upstart-sysv xserver-xorg-legacy libnss3-dev libcups2-dev libgconf2-dev libxss-dev libatk1.0-dev libgtkglextmm-x11-1.2-dev -y >> /dev/null 2>&1
wget -O chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" >> /dev/null 2>&1
dpkg -i chrome.deb >> /dev/null 2>&1
apt-get -f install -y >> /dev/null 2>&1
dpkg -i chrome.deb >> /dev/null 2>&1


echo "3 Adicionando usuário"
usermod -a -G audio quiosque
usermod -a -G video quiosque
adduser quiosque dialout


echo "4-Editando script"
a=/opt/quiosque.sh
echo "#! /bin/bash" >> $a
echo "xset -dpms" >> $a
echo "openbox-session &" >> $a
echo "start-pulseaudio-x11" >> $a
echo "while true; do" >> $a
#echo "        /usr/bin/firefox" >> $a
echo "rm -rf ~/.{config,cache}/google-chrome/" >> $a
echo "google-chrome --kiosk --no-first-run  'http://www.unifap.br/public/toten'" >> $a
echo "done" >> $a
chmod +x $a >> /dev/null 2>&1

echo "5-Editando arquivo de inicialização"
b=/etc/init/quiosque.conf
echo "start on (filesystem and stopped udevtrigger)" >> $b
echo "stop on runlevel [06]" >> $b
echo "console output" >> $b
echo "emits starting-x" >> $b
echo "respawn" >> $b
echo "exec sudo -u quiosque startx /etc/X11/Xsession /opt/quiosque.sh --" >> $b


echo "6-Editando início automático"
c=/etc/X11/Xwrapper.config
echo "allowed_users=anybody" >> $c
echo "needs_root_rights = yes" >> $c

echo "Entre com uma tecla para reiniciar o servidor"
read x 
shutdown -r now




