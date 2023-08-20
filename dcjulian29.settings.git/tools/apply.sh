INPUT=config.csv
OLDIFS=$IFS
IFS=','

while read key value
do
    [[ $key != \"* ]] && continue

    [[ $key =~ ^.Key ]] && continue
    [[ $key =~ .core.editor. ]] && continue
    [[ $key =~ .*winmerge.* ]] && continue
    [[ $value =~ .*winmerge.* ]] && continue
    [[ $key =~ .*credential.helper.* ]] && continue

    key=${key:1}
    key=${key:0:-1}

    value=${value:1}
    value=${value:0:-1}

    git config --global --replace-all $key $value
done < $INPUT

git config --global --replace-all core.editor nano
git config --global --replace-all core.autocrlf false

echo "Setting up Git Credential Manager..."
wget -O /tmp/gcm.deb https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.3.2/gcm-linux_amd64.2.3.2.deb
sudo dpkg -i /tmp/gcm.deb
git-credential-manger-core configure

git config --global --replace-all credential.credentialStore secretservice

echo "Setting up 'git-extras'...."
IFS=$OLDIFS
DIR=$(mktemp -t -d git-extras-install.XXXXXXXXXX)

cd "$dir"

git clone https://github.com/tj/git-extras.git
cd git-extras
git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) &> /dev/null

sudo make install
cd ..
rm -rf "$dir"

echo "Installing Gitflow-AVH..."
wget https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh
sudo bash gitflow-installer.sh install stable
