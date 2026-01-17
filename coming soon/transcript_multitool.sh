#
# transcript tools
#
# github.com/jessicakay/glossy
#
# jessdkant.bsky.social
#

read -p $'\n\t ~ search type? [e]mbedded or [d]irectory: ' s_type
read -p $'\n\t ~ Target (url): ' targ
read -p $'\n\t ~ Keyword (blank for save transcript): ' kw

case "$s_type" in
	e)
	if [ $kw == "" ]; then
			transcript_filename=$(echo $targ | sed 's/[^a-z0-9]//gI' | tail -c 16)
			printf "\n\n" && curl $targ -o outfile_temp
			grep '(?s)ccItems:\K\{\"en\"\:\[.*?\}\]\}' outfile_temp -Poz |
			jq -c '.en[] | {Begin,Content} ' > "${transcript_filename}_transcript.JSON"
			cat ${transcript_filename}_transcript.JSON | \
				jq -r '.Content' | \
				tr "\n" "\ " > "${transcript_filename}_raw.txt"
			printf "\n\nsaved to \"${transcript_filename}\".\n"
	else
			printf "\n\n" && curl $targ -o outfile_temp &&
			printf "\n results: \n\n" &&
			grep '(?s)ccItems:\K\{\"en\"\:\[.*?\}\]\}' outfile_temp -Poz |
			jq -c '.en[] | {Begin,Content} ' |
				tr "{|}" "\ " | tr ",|\"" " " | grep -i $kw
			printf "\n"
	fi;;
	d)
	folder_name=$(echo $targ | grep -Po "http?s\:\/\/\K.*?\/" | sed 's/[\/."www"]//g')
        mkdir $folder_name && cd $folder_name
        printf "\n\t ~ directory: $folder_name created\n"

        wget $(curl $targ | tr " " "\n" | grep -Po "http.*?.vtt") --random-wait | \
		grep -Pi "$kw" *.vtt;;
	*) return;;
esac
# empty keyword saves transcript to filename using last 16 characters of URL string

