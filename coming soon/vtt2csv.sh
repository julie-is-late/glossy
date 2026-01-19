read -p "filename (save as):" file_name
if [[ -z "$(ls -las $file_name )" ]]; then
    printf "temp exists\n"
    printf "\n\nfiles found: $(ls -las $file_name )"
 else
    cat file.vtt | sed 's/\ --> \|\n/\n/g' | awk '{print "\"" $0 "\","}' > "${file_name}"
    cat temp | sed 's/\"\",//g' | tr "\n" " " | awk '{print "\t" $0}' | sed  's/  /\n/g' >  "${file_name}".csv
    # rm temp
    head  -n 1 "${file_name}"
fi
