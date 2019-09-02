#!/usr/bin/env bash
#set -x

send_tg_message() { 
/usr/bin/curl --silent --output /dev/null --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" --data-urlencode "text=$1" \
		--data-urlencode "parse_mode=markdown" "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" 
}

create_pkg() {
if [[ "$2" = "True" ]]; then
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

RESULT=""
package="$1"
mode="$2"

cd $HOME/$package/ 
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
else
prettyprint_up 
echo "$pkgname failed!"
prettyprint_down 
RESULT="$RESULT \n $pkgname - $pkgver - FAIL"
fi

printf ${RESULT}
#send_tg_message ${RESULT}
