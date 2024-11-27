sudo pacman -S --needed --noconfirm - <./arch-official-packages.txt

mv ./exclude-config.sh ./config.sh
sudo cp -R ./trigger-on-change.sh $HOME/.shell_config_features.d/trigger-on-change.sh
sudo chmod +x $HOME/.shell_config_features.d/trigger-on-change.sh
