#!/usr/bin/env bash
#set -x

RESULT=""
package="$1"
mode="$2"

create_pkg() {
if [[ "$mode" = "True" ]]; then
  makepkg -sci --noconfirm  --nodeps --skipchecksums
else
  makepkg -sci --noconfirm  --skipchecksums
fi
}

prettyprint_up () {
echo ""
echo ""
echo "####"
}

prettyprint_down () {
echo "####"
echo ""
echo ""
}

cd $HOME/pkgbuild/$package/ 
source PKGBUILD
prettyprint_up 
echo "Makepkg for pkg: $pkgname"
prettyprint_down 
create_pkg
if [[ $? = 0 ]]; then
  prettyprint_up 
  echo "$pkgname success!"
  prettyprint_down 
  RESULT="$RESULT \n $pkgname - $pkgver - OK"
  printf ${RESULT}
  exit 0
else
  prettyprint_up 
  echo "$pkgname failed!"
  prettyprint_down 
  RESULT="$RESULT \n $pkgname - $pkgver - FAIL"
  printf ${RESULT}
  exit 1
fi
