for pkg in $(cat ./arch-official-packages.txt); do
  read -p "Do you want to remove package '$pkg' (y/n)? " confirm
  if [[ $confirm == [Yy] ]]; then
    sudo pacman -Rnsu "$pkg"
  else
    echo "Skipping package '$pkg'."
  fi
done

mv ./config.sh ./exclude-config.sh
rm -rf $HOME/.shell_config_features.d/trigger-on-change.sh
