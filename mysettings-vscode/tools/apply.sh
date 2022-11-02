#! /bin/bash

wget -nv -O /tmp/extensions \
  https://raw.githubusercontent.com/dcjulian29/choco-packages/main/mysettings-vscode/tools/extensions.default

IFS=$'\n' read -d '' -r -a packages < /tmp/extensions

for i in "${packages[@]}"; do
    code --install-extension $i --force
done

wget -nv -O /tmp/extensions \
  https://raw.githubusercontent.com/dcjulian29/choco-packages/main/mysettings-vscode/tools/extensions.remove

IFS=$'\n' read -d '' -r -a packages < /tmp/extensions

for i in "${packages[@]}"; do
    code --uninstall-extension $i --force
done

wget -nv -O ~/.config/Code/User/settings.json \
  https://raw.githubusercontent.com/dcjulian29/choco-packages/main/mysettings-vscode/tools/vscode.json
