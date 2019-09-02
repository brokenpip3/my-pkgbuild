#!/usr/bin/env bash

#set -x

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'|head -n 1   
}

package="$1"
source $HOME/pkgbuild/$package/PKGBUILD 

re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)$"
if [[ $url =~ $re ]]; then
  protocol=${BASH_REMATCH[1]}
  separator=${BASH_REMATCH[2]}
  hostname=${BASH_REMATCH[3]}
  user=${BASH_REMATCH[4]}
  reponame=${BASH_REMATCH[5]}
fi

repo="$user/$reponame"
lastver=$(get_latest_release "$repo")
lastver_clean=$(grep -P -o '(\d(\.(?=\d))?){2,}' <<<"${lastver}")

echo "####"
echo "Check new version for pkgbuild: $pkgname"
echo "####"

if [[ ${lastver_clean} != "" ]] && [[ ${lastver_clean} != ${pkgver} ]]; then
  echo "Found version ${lastver_clean} different from ${pkgver}"
  echo "Let's try pkgbuild with version ${lastver}"
  sed -i "s/pkgver=${pkgver}/pkgver=${lastver_clean}/g" "$HOME/pkgbuild/$package/PKGBUILD"
else
  echo "No version tagged or no new version"
fi
