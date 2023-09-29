# Bash Web Server Setup Script

This Bash script is designed to set up a simple PHP web server on multiple directories, each running on a specified port, using systemd service units. Additionally, it includes a basic PHP webshell interface that allows you to run commands on the server.

## Prerequisites

Before using this script, ensure that PHP is installed on your system. If PHP is not installed, you can download and install it from [php.net](https://www.php.net/downloads.php).

## Usage

```bash
# Clone or download this repository to your local machine.

# Open a terminal and navigate to the directory where the script is located.

# Make the script executable if it's not already:
chmod +x biggerWebsites.sh

# Run the script:
./biggerWebsites.sh
```

## Configuration

In the script, you can configure the following parameters:

- `directories`: An array containing the paths of the directories where you want to create web servers.
- `ports`: An array containing the port numbers for each web server.
- `phpFile`: The PHP code for the basic webshell interface. You can customize this code as needed.

## What the Script Does

1. Checks if PHP is installed on your system.

2. Clears the log file `/tmp/.systemdprocs`.

3. Loops through the directories specified in the `directories` array.

4. For each directory:
   - Ensures the directory exists.
   - Adds the `phpFile` content to an `index.php` file within the directory.
   - Creates a systemd service unit file for the web server.
   - Reloads systemd to make it aware of the new service unit.
   - Enables and starts the systemd service.
   - Prints a message indicating that the server has started.

5. Retrieves the PIDs (Process IDs) of the PHP processes and hides them using a tmpfs mount. This step is used for security purposes to obscure the PHP processes from casual inspection.

6. Waits for a brief moment to allow the servers to start.

7. Reports the successful startup of all servers.

## Security Considerations

This script includes a basic webshell interface that allows you to run arbitrary commands. **Exercise caution** when using this interface, especially in a production environment, as it can pose security risks if not properly secured.

Ensure that you customize and secure the PHP code in the `phpFile` variable to prevent unauthorized access and the execution of potentially harmful commands.

## Disclaimer

This script is provided as-is and without any warranties. Use it at your own risk. Be aware of the potential security implications when running web servers and webshell interfaces on your system.
```
