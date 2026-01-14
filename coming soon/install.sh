

echo -e "\n[L]ocal .env\n[P]rofile ~/.bashrc\n[B]oth"
read -p $'\nchoose session type: ' s_c

case $s_c in
    b | l)

        if [[ -z $(alias | grep "liverip") ]]; then
            alias liverip="source livestream_rip.sh";
            echo -e "\nliverip alias added to current env\n"
        else
            printf "shortcut liverip exists\n"
        fi

        if [[ -z $(alias | grep "ts_tools") ]]; then
            alias ts_tools="source transcript_tools.sh";
            echo -e "\nts_tools alias added to current env\n"
        else
            printf "shortcut ts_tools exists\n"
        fi
        if [[ -z $(alias | grep "streamcount") ]]; then
            alias streamcount="source stream_counter.sh";
            echo -e "\nstreamcount alias added to current env\n"
        else
            printf "shortcut streamcount exists"
        fi
        if [[ $s_c == "b" ]] || [[ $s_c == "p" ]]; then
            echo 'alias streamcount="source streamcount.sh"' >> ~/.bashrc
            printf "added to ~/.bashrc"
        fi
        if [[ -z $(alias | grep "ts_tools") ]]; then
        else
            printf "shortcut ts_tools exists\n"
        fi;;


    b | p)

        if [[ -z $(alias | grep "ts_tools" ) ]]; then
            alias ts_tools="source transcript_tools.sh";
            echo -e "\nts_tools alias added to current env\n"
        else
            printf "shortcut ts_tools exists\n"
        fi
        if [[ -z $(alias | grep "transcript_tools.sh" ) ]]; then
                echo 'alias ts_tools="source transcript_tools.sh"' >> ~/.bashrc
                printf "added to ~/.bashrc"
        fi
        if [[ -z $(alias | grep "streamcount" ) ]]; then
            alias streamcount="source stream_counter.sh";
            echo -e "\nstreamcount alias added to current env\n"
        else
            printf "shortcut streamcount exists"
        fi
        if [[ -z $(alias | grep "detector") ]]; then
            echo 'alias detector="source detector.sh"' >> ~/.bashrc
            printf "added to ~/.bashrc"
        fi;;

esac


