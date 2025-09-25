#!/bin/bash

# File that stores passwords
PASSWORDS_FILE="passwords.data"
PASSWORDS_FILE_DIR="/home/"$(whoami)"/.otwpsw"
PASSWORDS_FILE_FP="${PASSWORDS_FILE_DIR}/${PASSWORDS_FILE}"

# Colors for text
WARNING="\033[1;31m"
SUCCESS="\033[1;32m"
HIGHLIGHT="\033[1;33m"
RESET="\033[0m"

# Function to verify file's presence
check_file() {
	if [ -e "$PASSWORDS_FILE_FP" ]
	then 
		return 0;
	fi

	echo -e "${WARNING}File (${PASSOWRDS_FILES_FP}) doesn't exist\n"
	echo -en "Do you wish to create it? [y/n]: ${RESET}"
	read yn

	case "$yn" in
		[Yy]* )
			if [ ! -d "$PASSWORDS_FILE_DIR" ]
			then
				error_mkdir=$(mkdir "$PASSWORDS_FILE_DIR" 2>&1 1>/dev/null)
				
				if [ $? -ne 0 ]
				then
					echo -e "${WARNING}Error creating directory (${PASSWORDS_FILE_DIR})${RESET}:\n\t${error_mkdir}\n"
					return 1
				fi
			fi

			error_touch=$(touch "$PASSWORDS_FILE_FP" 2>&1 1>/dev/null)
			if [ $? -eq 0 ]
			then
				echo -e "\n${SUCCESS}File created successfully${RESET}\n"
				return 0
			else
				echo -e "\n${WARNING}Couldn't create the file:${RESET}\n\t${error_touch}\n"
				return 2
			fi
			;;
		* )
			return 3;
			;;
	esac
}

# Function to handle entries
find_entry() {
	if grep -qE "^$1," "$PASSWORDS_FILE_FP"
	then
		password=$(awk -F, -v level="$1" '{ if($1 == level) { print $2 } }' "$PASSWORDS_FILE_FP")
		echo -e "Password for level $1: ${SUCCESS}${password}${RESET}\n"

		echo -n "Would you like to modify it? [y/n]: "
		read yn
		echo ""
		
		case "$yn" in 
			[Yy]* )
				echo -n "Enter a new password: "
				read new_password
				echo ""
				error_awk=$(awk -F, -v level="$1" -v pass="$new_password" '{ if($1 == level) { print $1","pass} else { print $0 } }' "$PASSWORDS_FILE_FP" 2>&1 1>"${PASSWORDS_FILE_DIR}/passwords.tmp" && mv "${PASSWORDS_FILE_DIR}/passwords.tmp" "$PASSWORDS_FILE_FP" 2>&1 1>/dev/null)

				if [ $? -eq 0 ]
				then
					echo -e "${SUCCESS}Password updated successfully${RESET}\n"
				else
					echo -e "${WARNING}Couldn't update the password:${RESET}\n\t${error_awk}\n"
					return 4
				fi 
				;;
			* )
				;;
		esac
	else
		echo -en "${WARNING}Entry does not exist. Would you like to add it? [y/n]: ${RESET}"
		read yn
		echo ""

		case "$yn" in
			[Yy]* )
				echo -n "Enter a new password: "
				read new_password
				echo ""
				error_append=$(echo "$1,$new_password" 2>&1 1>>"$PASSWORDS_FILE_FP")

				if [ $? -eq 0 ]
				then
					echo -e "${SUCCESS}Password saved successfully${RESET}\n"
					sort -k1,1 -n -t',' "$PASSWORDS_FILE_FP" -o "$PASSWORDS_FILE_FP"
				else 
					echo -e "${WARNING}Couldn't save the password:${RESET}\n\t${error_append}\n"
					return 5
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


