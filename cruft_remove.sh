#!/bin/bash

read -p "Enter folder for cruft cleanup (\".\" for current directory): " folder

if [[ ! -e ${folder} ]]
then
        echo " "
        echo "Directory doesn't exist."
sleep 1
        echo "Aborting..."
        exit
fi

read -p "How many days is too old?: " old

readarray -t f < <(find "${folder}" -maxdepth 1 -type f -mtime +"${old}")

readarray -t wcf < <(printf "%s\n" "${f[@]}" 2> /dev/null | wc -l)

readarray -t fn < <(printf "%s\n" "${f[@]}")

if [[ "${wcf[@]}" -eq 1 ]] && [[ $(printf "%s" "${f[@]}" | wc -l) -eq 0 ]]
then
        wcf2=$(( "${wcf[@]}" - 1 ))
else
        readarray -t wcf2 < <(printf "%s\n" "${f[@]}" 2> /dev/null | wc -l)
fi

if [[ "${wcf2[@]}" -gt 0 ]]
then
        echo " "
        echo "You have ${wcf2[@]} file(s) to be removed"

        echo " "

        echo "The file(s) below was last modified more than ${old} days ago: "

        printf ">%s\n" "${fn[@]}"
        echo " "

#Select command below

        PS3="Do you want to delete the file(s)?: "
        select options in  yes no
        do
        if [[ $options = yes ]]
        then
                echo " "
                echo "You have selected \"yes\""
        sleep 1
                echo " "
                echo "Removing the following files..."
                echo "${fn[@]}"
                for file in "${fn[@]}"; do
                rm -vf "${file}" 2> /dev/null
        done
        sleep 1
        if [[ $? = 0 
        #!/bin/bash

read -p "Enter folder for cruft cleanup (\".\" for current directory): " folder

if [[ ! -e ${folder} ]]
then
        echo " "
        echo "Directory doesn't exist."
sleep 1
        echo "Aborting..."
        exit
fi

read -p "How many days is too old?: " old

readarray -t f < <(find "${folder}" -maxdepth 1 -type f -mtime +"${old}")

readarray -t wcf < <(printf "%s\n" "${f[@]}" 2> /dev/null | wc -l)

readarray -t fn < <(printf "%s\n" "${f[@]}")

if [[ "${wcf[@]}" -eq 1 ]] && [[ $(printf "%s" "${f[@]}" | wc -l) -eq 0 ]]
then
        wcf2=$(( "${wcf[@]}" - 1 ))
else
        readarray -t wcf2 < <(printf "%s\n" "${f[@]}" 2> /dev/null | wc -l)
fi

if [[ "${wcf2[@]}" -gt 0 ]]
then
        echo " "
        echo "You have ${wcf2[@]} file(s) to be removed"

        echo " "

        echo "The file(s) below was last modified more than ${old} days ago: "

        printf ">%s\n" "${fn[@]}"
        echo " "

#Select command below

        PS3="Do you want to delete the file(s)?: "
        select options in  yes no
        do
        if [[ $options = yes ]]
        then
                echo " "
                echo "You have selected \"yes\""
        sleep 1
                echo " "
                echo "Removing the following files..."
                echo "${fn[@]}"
                for file in "${fn[@]}"; do
                rm -vf "${file}" 2> /dev/null
        done
        sleep 1
        if [[ $? = 0 ]]
        then
                echo " "
                echo "Files removed successfully!"
        else
                echo "Error! Failed to remove files."
        fi
        exit 0
        elif [[ $options = no ]]
        then
                echo " "
                echo "You have selected \"no\""
                echo " "
        sleep 1
                echo "aborting..."
        sleep 1
        exit 0
        else
                echo " "
                echo "Error. Try again."
        exit 0
        fi
        done
else
        echo " "
        echo "All files have recently been modified."
        sleep 1
        exit 0
fi



