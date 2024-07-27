# Author: Kenji Nakajima
# Last modified: '2024/07/27'
# Purpose: Interactively add user accounts to server.

# Description:
# 1) Check if user already exists
# 2) Promt for '/etc/passwd' display
# 3) Input UUID for user
# 4) Execute the 'useradd' command
# 5) Copy existing '.login' and '.cshrc' files to user's home directory
# 6) Change file ownership/permissions for '.login' and '.cshrc'
# 7) Create user password
# 8) Use the 'make -C /var/yp' comamnd to synchronize the password to /var/yp
# 9) Promt for '/etc/passwd' display


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
                sleep 0.5
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
        useradd -u "$id" -g XXX -d /home/"$i" -s /bin/csh "$i"
if [[ $? -eq 0 ]]
then
        chmod 755 /home/"$i"

        cp /home/XXX/.login /home/"$i"
        if [[ $? -eq 0 ]]
        then
                echo "Added '.login' to "$i"'s home directory."
                chown "$i" /home/"$i"/.login
                chgrp staff /home/"$i"/.login
        else
                echo "Failed to add '.cshrc' to "$i"'s home directory.."
                sleep 0.5
                exit 1
        fi

        cp /home/XXX/.cshrc /home/"$i"
        if [[ $? -eq 0 ]]
        then
                echo "Added '.cshrc' to "$i"'s home directory."
                chown "$i" /home/"$i"/.cshrc
                chgrp staff /home/"$i"/.cshrc
        else
                echo "Failed to add '.cshrc' to "$i"'s home directory.."
                sleep 0.5
                exit 1
        fi

        echo ""
        
        passwd "$i"
        if [[ $? -eq 0 ]]
        then
                make -C /var/yp
        else
                echo "Password creation failed.."
                echo "Please try again for user "$i" and execute the follwoing command: 'make -C /var/yp'"
                sleep 0.5
                exit 1
        fi
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
        echo "Failed to create user or user password."
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


