git clone --recursive https://github.com/uglide/RedisDesktopManager.git -b 0.9 /tmp/rdm && cd /tmp/rdm
cd src/
./configure
source /opt/qt59/bin/qt59-env.sh && qmake && make && sudo make install
cd /usr/share/redis-desktop-manager/bin
sudo mv qt.conf qt.backup
