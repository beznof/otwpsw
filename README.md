# OTW Bandit Password Manager
A simple Bash script to store, retrieve, and update passwords for *OTW Bandit* levels locally.

## Features
- Stores passwords in a file (`passwords.data`) located in a hidden directory `.otwpsw` inside the user's home directory
- Retrieve password for a specific level
- Update existing passwords
- Add new password entries

## Prerequisites
- Unix-like OS (*Linux*, *macOS*) or *Bash* on *Windows* (*WSL*, *Git Bash*, etc.)
- *Bash 5.2* or higher
- Write, read, and execute permissions in the user's home directory

## Usage
1. Clone or download this repository.
2. Make sure the script is executable:
```bash
chmod +x savepsw.sh
```
3. **(OPTIONAL)** Make the script accessible as a command:
- Option 1: Move it to a directory already in your **PATH**:
```bash
echo $PATH
mv savepsw.sh <Directory included in PATH>
```
- Option 2: Include the script's directory in the **PATH**:
```bash
export PATH="<Absolute path to the script>:$PATH"
```
> You can add it to your `~/.bashrc` to make it permanent 
4. Run the script:
```bash
./savepsw.sh
```
Or if you proceeded with **Step 3**:
```bash
savepsw
```
5. Follow the prompts:
  - If the `passwords.data` file does not exist, you will be asked to create it.
  - Enter the OTW Bandit level number when prompted.
  - If a password for that level exists, it will be displayed, and you can choose to update it.
  - If the password does not exist, you can add a new entry.
