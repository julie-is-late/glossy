# install packages

sudo apt install ffmpeg jq xclip

# find location of MP4 file on page

read -p "Target (url): " targ && ffmpeg -i $(curl -s $targ | grep "\Khttps.*?mp4" -oPm 1) -c copy outfile.mp4 

# find stream and rip to ffmpeg 
read -p "Target (url): " targ && ffmpeg -i $(curl $targ | grep "\Khttps.*?m3u" -oP | grep "https" -m 1) -c copy outfile.mp4

# pull whole data model from Sliq, only show first 100 characters

grep '(?s)dataModel = \{.*?\};' outfile_temp -Poz | tail +2 | head -c 100

# extract transcript from embedded VTT subtitles file 
curl $(targ) | grep -i '[a-z]' | sed  's/\r//g' | tr '\n' ' '

# make shortcut to allow any user to expand subtitles of file with URL in clipboard
alias expvtt="curl $(xclip -selection clipboard -o) | grep -i '[a-z]' | sed  's/\r//g' | tr '\n' ' '"

# extract subtitles, concatenate into and search transcript for keywords:
# for Sliq platform

read -p "Target (url): " targ && read -p "Keyword: " kw &&
    printf "\n\n" && curl $targ -o outfile_temp &&
	printf "\n results: \n\n" &&
	grep '(?s)ccItems:\K\{\"en\"\:\[.*?\}\]\}' outfile_temp -Poz |
	jq -c '.en[] | {Begin,Content} ' | tr "{|}" "\ " | tr ",|\"" " " |
	grep -i $kw && printf "\n"


# extract transcript from Sliq
# version 1
grep '(?s)ccItems:\K\{\"en\"\:\[.*?\}\]\}' outfile_temp -Poz | 
	jq |  tr "{|}'" "\n" | sed 's/^,$//g'| grep $kw | printf "\n\n"

# version 2
grep '(?s)ccItems:\K\{\"en\"\:\[.*?\}\]\}' outfile_temp -Poz |
	jq -c '.en[] | {Begin,Content} ' | tr "{|}" "\ " | tr ",|\"" " "

# version 3
grep '(?s)ccItems:\K\{\"en\"\:\[.*?\}\]\}' outfile_temp -Poz |   jq '.en | select(.Content | contains("$kw")) | {Begin, Content}'


# testing azleg.gov/actvlive
curl azleg.gov/actvlive | tr "\'" "\n" |  grep "\Khttp.*?media.*?m3u?8" -Poz

read -p "Target (url): " targ && ffmpeg -i $(curl $targ -L | tr "\'" "\n" |  grep "\Khttp.*?m3u?8" -Poz) -c copy out.mp4

# for rhode island

curl https://capitoltvri.cabcast.tv/watch/stream/2 |  tr "\"" "\n" | grep  "\Khttps.*?1080.*?m3u?8" -Poz -m 1

# stream counter
curl $targ |  tr "\"" "\n" | grep '^https.*?m..?.$' -E | printf "there are $(wc -l) streams"

# granicus
read -p "Target (url): " targ && ffmpeg -i $(curl $targ -L |
	tr "\'" "\n" |  grep "\Khttp.*?m3u?8" -Poz |
	grep "m3u" -z -m 1) -c copy out.mp4


curl $targ | grep "(?s)\Khttp[a-zA-Z0-9./]+m3u?8" -Poz -m 1

