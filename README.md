# OTW Bandit Password Manager
A simple Bash script to save, retrieve, and update passwords for **OTW Bandit** levels in a local file.

## Features
- Stores passwords in a file (`passwords.data`)
- Retrieve password for a specific level
- Update existing passwords
- Add new password entries

## Prerequisites
- Linux or macOS terminal (Bash shell)

## Usage
1. Clone or download this repository.
2. Make sure the script is executable:
```bash
chmod +x savepsw.sh
```
3. Run the script:
```bash
./savepsw.sh
```
4. Follow the prompts:
  - If the `passwords.data` file does not exist, you will be asked to create it.
  - Enter the OTW Bandit level number when prompted.
  - If a password for that level exists, it will be displayed and you will have the option to update it.
  - If the password does not exist, you can add a new entry.
