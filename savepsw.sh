#!/bin/bash

# File that stores passwords
PASSWORDS_FILE="passwords.data"

# Colors for text
WARNING="\033[1;31m"
SUCCESS="\033[1;32m"
HIGHLIGHT="\033[1;33m"
RESET="\033[0m"

# Function to verify file's presence
check_file() {
	if [ -e "$PASSWORDS_FILE" ]
	then 
		return 0;
	fi

	echo -e "${WARNING}File doesn't exist\n"
	echo -en "Do you wish to create it? [y/n]: ${RESET}"
	read yn

	case "$yn" in
		[Yy]* )
			touch "$PASSWORDS_FILE"
			if [ $? -eq 0 ]
			then
				echo -e "\n${SUCCESS}File created successfully${RESET}\n"
				return 0
			else
				echo -e "\n${WARNING}Couldn't create the file${RESET}\N"
				return 1
			fi
			;;
		* )
			return 2;
			;;
	esac
}

# Function to handle entries
find_entry() {
	if grep -qE "^$1," "$PASSWORDS_FILE"
	then
		password=$(awk -F, -v level="$1" '{ if($1 == level) { print $2 } }' "$PASSWORDS_FILE")
		echo -e "Password for level $1: ${SUCCESS}${password}${RESET}\n"

		echo -n "Would you like to modify it? [y/n]: "
		read yn
		echo ""
		
		case "$yn" in 
			[Yy]* )
				echo -n "Enter a new password: "
				read new_password
				awk -F, -v level="$1" -v pass="$new_password" '{ if($1 == level) { print $1","pass} else { print $0 } }' "$PASSWORDS_FILE" > passwords.tmp && mv passwords.tmp "$PASSWORDS_FILE"
				echo ""

				if [ $? -eq 0 ]
				then
					echo -e "${SUCCESS}Password updated successfully${RESET}\n"
				else
					echo -e "${WARNING}Couldn't update the password${RESET}\n"
					return 3
				fi 
				;;
			* )
				;;
		esac
	else
		echo -n "${WARNING}Entry does not exist. Would you like to add it? [y/n]: ${RESET}"
		read yn
		echo ""

		case "$yn" in
			[Yy]* )
				echo -n "Enter a new password: "
				read new_password
				echo ""
				echo "$1,$new_password" >> "$PASSWORDS_FILE"

				if [ $? -eq 0 ]
				then
					echo -e "${SUCCESS}Password saved successfully${RESET}\n"
					sort -k1,1 -n -t',' passwords.data -o passwords.data
				else 
					echo -e "${WARNING}Couldn't save the password${RESET}\n"
					return 4
				fi
				;;
			* )
				;;
		esac
	fi


	
	return 0
}

# Intro
echo -e "\n${HIGHLIGHT}Save a password for OTW Bandit${RESET}\n"

# Verifying file's existence
check_file
check_file_ec=$?
if [ $check_file_ec -ne 0 ] 
then
	exit $check_file_ec
fi

# User prompt
echo -n "Enter the level: "
read level
echo ""

find_entry "$level"
find_entry_ec=$?
exit $find_entry_ec


