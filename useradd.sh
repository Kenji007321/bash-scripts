# Author: Kenji Nakajima
# Last update: '2024/07/13'
# Description: Interactive useradd script (add multiple users at once)


read -p "Do you want to print all user:uuid information?([y]/[n]): " output1
case $output1 in
        y|Y|yes|Yes)
                sort -t: -k3n /etc/passwd | cut -d ':' -f 1,3
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
        passwd "$i"
if [[ $? -eq 0 ]]
then
        user=$(sort -t: -k3n /etc/passwd | cut -d ':' -f 1,3 | grep "$i")
        echo "User "\'$user\'" created"
        echo ""
else
        echo "Failed to create user"
        echo ""
        exit 2
fi
done

if [[ $? -eq 0 ]]
then
        read -p "Do you want to view all user:uuid information?([y]/[n]): " output2
        case $output2 in
                y|Y|yes|Yes)
                        sort -t: -k3n /etc/passwd | cut -d ':' -f 1,3 | less
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


