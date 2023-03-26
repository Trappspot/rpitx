#!/bin/sh

echo Install rpitx - some package need internet connection -

sudo apt-get update
#rtl-sdr and buffer are used for rtl-sdr
sudo apt-get install -y libsndfile1-dev git imagemagick libfftw3-dev rtl-sdr buffer build-essential

# We use CSDR as a dsp for analogs modes thanks to HA7ILM
git clone https://github.com/F5OEO/csdr
cd csdr || exit
make && sudo make install
cd ../ || exit
 cd src || exit   
git clone https://github.com/F5OEO/librpitx
cd librpitx/src || exit
make && sudo make install
cd ../../ || exit

cd pift8
git clone https://github.com/F5OEO/ft8_lib
cd ft8_lib
make && sudo make install
cd ../
make
cd rpitx
./install.sh
make
sudo make install
cd .. || exit

printf "\n\n"
printf "In order to run properly, rpitx need to modify /boot/config.txt. Are you sure (y/n) "
read -r CONT

if [ "$CONT" = "y" ]; then
  echo "Set GPU to 250Mhz in order to be stable"
   LINE='gpu_freq=250'
   FILE='/boot/config.txt'
   grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
   #PI4
   LINE='force_turbo=1'
   grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
   echo "Installation completed !"
else
  echo "Warning : Rpitx should be instable and stop from transmitting !";
fi


