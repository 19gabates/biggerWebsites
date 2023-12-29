# Bash Web Server Setup Script

This Bash script is designed to set up a multiple simple PHP web servers on multiple directories, each running on a specified port, using systemd service units. Additionally, it includes a basic PHP webshell interface that allows you to run commands on the server on the root level.

The main use case for the script is to deploy multiple webshells on a linux system that are hidden from users to allow for root level remote code execution. The script was created for a red vs blue team interaction. There are a couple of ways that the blue team is expected to deal with the script, listed below is what I believe are the easiest to implement in order.
1. Implement firewalls for all unused ports. This prevents red teams from making connections to the PHP server
2. Find the systemd processes and check where the webshell directory is located, then removing the file/directory will remove the webshell
3. Restart the system and check ```ps aux``` for the PHP servers. From the output the directories can be found and the file can be deleted, removing the webshell.
4. NMap the system and search for PHP servers, if an easily accessible webpage is found, use the command execution to find where the directory is located.

## Prerequisites

Before using this script, ensure that PHP is installed on your system. If PHP is not installed, the script will let you know.

## Usage

```bash
# Clone or download this repository to the target machine machine.

# Open a terminal and navigate to the directory where the script is located.

# Make any changes needed. ie settting different ports, different directory locations, different systemd process names

# Make the script executable if it's not already:
chmod +x biggerWebsites.sh

# Run the script:
./biggerWebsites.sh
```

## Configuration

In the script, you can configure the following parameters:

- `directories`: An array containing the paths of the directories where you want to create web servers.
- `ports`: An array containing the port numbers for each web server.
- `service_names`: An array containing the names that will be used for the systemd process names

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

