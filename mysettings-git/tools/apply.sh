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

    key=${key:1}
    key=${key:0:-1}

    value=${value:1}
    value=${value:0:-1}

    git config --global --replace-all $key $value
done < $INPUT

IFS=$OLDIFS
DIR=$(mktemp -t -d git-extras-install.XXXXXXXXXX)

cd "$dir"

echo "Setting up 'git-extras'...."
git clone https://github.com/tj/git-extras.git

cd git-extras
git checkout

$(git describe --tags $(git rev-list --tags --max-count=1)) &> /dev/null

sudo make install

rm -rf "$dir"
