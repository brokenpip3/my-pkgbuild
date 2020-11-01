#!/usr/bin/env bash

#set -x

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'|head -n 1
}

tmpdir=$(pwd)

package="$1"
source "${tmpdir}"/pkgbuild/"${package}"/PKGBUILD

re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)$"
if [[ $url =~ $re ]]; then
  protocol=${BASH_REMATCH[1]}
  separator=${BASH_REMATCH[2]}
  hostname=${BASH_REMATCH[3]}
  user=${BASH_REMATCH[4]}
  reponame=${BASH_REMATCH[5]}
fi

if [[ ${hostname} != 'github.com' ]]; then
		echo "-- Sources not hosted on github.com --"
		exit 0
fi

repo="$user/$reponame"
lastver=$(get_latest_release "$repo")
lastver_clean=$(grep -P -o '(\d(\.(?=\d))?){2,}' <<<"${lastver}")

printf "\n"
echo "-- Checking new version for pkgbuild: ${pkgname} ---"
printf "\n"

if [[ ${lastver_clean} != "" ]] && [[ ${lastver_clean} != ${pkgver} ]]; then
  echo "Found version ${lastver_clean} different from ${pkgver}"
  echo "Let's try pkgbuild with version ${lastver}"
  sed -i "s/pkgver=${pkgver}/pkgver=${lastver_clean}/g" "$tmpdir/pkgbuild/$package/PKGBUILD"
  touch "$tmpdir/newversion"
  echo "${pkgver}" > "$tmpdir/newversion"
else
  echo "No version tagged or no new version"
  exit 0
fi
