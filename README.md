- # User Management Script
- 
* This repository contains a Bash script (`create_users.sh`) for automating user and group management on a Linux server. The script reads a text file containing usernames and groups, creates users and groups as specified, sets up home directories with appropriate permissions, generates random passwords, and logs all actions.
- 
- ## Usage Instructions
* 
- ### Cloning the Repository
- 
1) **Clone the repository:**
- 
   - ```bash
   - git clone https://github.com/<your-username>/user-management-script.git
  - ```
2 **Navigate to the repository:**
-
   - ```
   - cd user-management-script
   - ```
 - 
- 
3 **Make create_users.sh executable:**
-
   - ```
   - chmod +x create_users.sh

   - ```
 - 
- 
4 **Create an example users.txt file:**
-
   - ```
   light;sudo,dev,www-data
   idimma;sudo
   mayowa;dev,www-data

   ```
 - 
5 **Execute create_users.sh with users.txt:**
-
   - ```
  ./create_users.sh users.txt


   ```
 - 
**Example Usage**
Assuming you have cloned the repository, navigated to it, created users.txt with the above content, and made create_users.sh executable, you can now execute the script to create users and manage groups as specified in users.txt.

#Additional Information
*The script logs all actions to /var/log/user_management.log.
*Passwords are securely stored in /var/secure/user_passwords.csv, accessible only to the file owner.