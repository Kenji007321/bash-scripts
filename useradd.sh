# Author: Kenji Nakajima
# Last update: '2024/07/13'
# Description: Interactive useradd script (create multiple users at once)

for t in "$@"
do
        check=$(grep "$t" /etc/passwd 2> /dev/null | cut -d ':' -f 1)
        if [[ "$t" = "$check" ]]
        then
                echo "User "$t" already exists."
                exit 1
        else
                echo "Creating user "$t".."
        fi
done

sleep 0.5

read -p "Print all 'user:uuid:guid' from /etc/passwd?([y]/[n]): " output1
case $output1 in
        y|Y|yes|Yes)
                sort -t: -k3n /etc/passwd | cut -d ':' -f 1,3,4
                echo ""
                sleep 1
                ;;
        n|N|no|No)
                ;;
        *)
                echo "Please select a valid option." >&2
                exit 1
                ;;
esac

for i in "$@"
do
        read -p "Enter UUID for "$i": " id
        useradd -u "$id" "$i"
if [[ $? -eq 0 ]]
then
        passwd "$i"
else
        exit 1
fi
        
if [[ $? -eq 0 ]]
then
        user=$(sort -t: -k3n /etc/passwd | cut -d ':' -f 1,3,4 | grep "$i")
        echo "     (user:uuid:guid)"
        echo "User "\'$user\'" created."
        echo ""
else
        echo "Failed to create user."
        echo ""
        exit 1
fi
done

if [[ $? -eq 0 ]]
then
        read -p "View all 'user:uuid:guid' from /etc/passwd?([y]/[n]): " output2
        case $output2 in
                y|Y|yes|Yes)
                        sort -t: -k3n /etc/passwd | cut -d ':' -f 1,3,4 | less
                        ;;
                n|N|no|No)
                        exit 1
                        ;;
                *)
                        echo "Exiting.." >&2
                        exit 1
                        ;;
        esac
fi


