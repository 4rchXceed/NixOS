pacman=$(checkupdates | wc -l)
aur=$(yay -Qua | wc -l)
flatpak=$('n\n' 2>/dev/null | flatpak update | grep -Eo "^[\ ]*[0-9]+\." | wc -l)

echo "main:$pacman aur:$aur flatpak:$flatpak"
