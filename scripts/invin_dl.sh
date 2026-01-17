#
# inv downloader
# github.com/jessicakay/glossy
#

printf "\n\t github.com/jessicakay/glossy\n"
read -p $'\n\t ~ Target (url): ' targ
read -p $'\n\t ~ choose filename prefix: ' outNAME
targ="${targ:=$default_URL}"

function grab_inv(){
	if ! [[ -z $(  curl -s $new_targ ) ]]; then
		case "$file_fmt" in
			a) targ=$new_targ ; ffmpeg -i $targ -vn -ac 2 -b:a 192k $outNAME.mp3 ;;
			v) targ=$new_targ ; ffmpeg -i $targ -c copy $outNAME.mp4 ;;
			b) targ=$new_targ ; ffmpeg -i $targ -c copy $outNAME.mp4 &&
				ffmpeg -i $outNAME.mp4 --vn -ac 2 -b:a 192k $outNAME.mp3 ;;
		esac
		fi
		}

read -p $'\t ~ [a]udio [v]ideo or [b]oth: ' file_fmt
case "$file_fmt" in
	a) file_form="mp3" ;;
	v) file_form="mp4" ;;
	b) file_form="mp4" ;;
	*)
		printf "\n\t-! incorrect format choice, try again...\n"
		return ;;
esac
buffer="$(curl -s $targ)"

printf "\n\t ~ grabbing identifiers...\n\n"
curl -s -m 10 --no-keepalive $targ > temp.txt
if ! [[ -z $(echo $targ | grep -Pozi "ClientID="| tr -d '\0' ) ]] && ! [[ -z $(echo $targ | grep -Pozi "eventID=" | tr -d '\0' ) ]]; then
    clientid="$(echo $targ | grep -Pozi "ClientID=\K[0-9]+" | tr -d '\0' )"
    event_id="$(echo $targ | grep -Pozi "eventID=\K[0-9]+" | tr -d '\0' )"
    printf "\n\t ~ client ID $clientid\n\t ~ event ID $event_id\n\n\t ~ attempting to grab stream..\n\n"
    new_targ="https://api.v3.invintus.com/StreamURI/hls/$clientid/$event_id/media.m3u8"
    printf "\n$new_targ\n"
    printf "\ncolumn a"
    grab_inv
elif ! [[ -z $(echo $buffer| grep -Pozi "ClientID=" | tr -d '\0') ]] &&  [[ -z $(echo $targ | grep -Pozi "eventID=" | tr -d '\0' ) ]]; then
    clientid="$(cat temp.txt | tr "\'" " " | grep -Pozi "ClientID\K.*?[0-9]+" | tr -d '\0' )"
    event_id="$(cat temp.txt | tr "\'" " " | grep -Pozi "eventID.*?\K[0-9]+[^\{\}]" -m 1 | tr -d '\0' )"
    printf "\n\t\t ~ client ID $clientid\n\t\t ~ event ID $event_id\n"
    rm temp.txt
    printf "\ncolumn b"
else
    # some implementations use redirects, no-keepalive overrides throttling
    curl -s -m 10 --no-keepalive -L $targ > temp.txt
    clientid="$(cat temp.txt | tr "\'" " " | grep -Pozi "ClientID.*?\K[0-9:]+" -m 1 |  tr -d '\0:' )"
    event_id="$(cat temp.txt | tr "\'" " " | grep -Pozi "event.*?\K[0-9:]+" -m 1 |  tr -d '\0' |
    sed 's/:/\n/g' | grep "[0-9]+" -oP | uniq )"
    printf "\n\t ~ client ID $clientid\n\t ~ event ID $event_id\n"
    if [[ ${#event_id} > 11 ]]; then
        event_id=$(echo $event_id | head -c 10 )
    fi
    new_targ="https://api.v3.invintus.com/StreamURI/hls/$clientid/$event_id/media.m3u8"
    printf "\n$new_targ\n"
    printf "\ncolumn c"
    grab_inv
fi
