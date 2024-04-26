cPanelConfigTool
cPanelConfigTool is a bash script designed to perform a WHM global backup of essential configuration files. It simplifies the process of backing up critical configuration files related to Apache, SMTP (Exim), AutoSSL options, backups, Greylist, Hulk, ModSecurity, MySQL, WHM configuration, and UI themes.

Features
Automation: Automates the backup process, saving time and effort.
Customizable: Easily configurable to include/exclude specific configuration files as needed.
Efficient: Performs a global backup of essential cPanel/WHM configuration files in one go.

Installation
Clone the repository:

git clone https://github.com/yourusername/cPanelConfigTool.git

Change directory to cPanelConfigTool:

cd cPanelConfigTool

Make the script executable:

chmod +x cpconfigtool_v1.sh

Run the script by executing the following command:
./cpconfigtool_v1.sh
T

Configuration Files Backed Up
apache
smtp-exim
autossl_options
backups
greylist
hulk
modsecurity
mysql
whmconf
ui_themes
Contributions
Contributions are welcome! If you have any suggestions, feature requests, or bug reports, please feel free to open an issue or create a pull request.
