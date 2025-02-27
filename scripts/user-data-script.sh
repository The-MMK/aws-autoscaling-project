#!/bin/bash
# Update packages
yum update -y

# Install Apache web server
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Get instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Create a simple web page with instance information
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Auto Scaling Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
            text-align: center;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        .server-info {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 20px;
            margin: 20px 0;
        }
        h1 {
            color: #0066cc;
        }
        .server-id {
            font-size: 24px;
            color: #cc0000;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>AWS Auto Scaling Demo</h1>
        <div class="server-info">
            <h2>Server Information</h2>
            <p><strong>Instance ID:</strong> <span class="server-id">${INSTANCE_ID}</span></p>
            <p><strong>Availability Zone:</strong> ${AVAILABILITY_ZONE}</p>
            <p><strong>Private IP:</strong> ${PRIVATE_IP}</p>
            <p><strong>Server Time:</strong> <span id="server-time"></span></p>
        </div>
    </div>
    <script>
        // Update server time every second
        setInterval(function() {
            document.getElementById('server-time').textContent = new Date().toLocaleString();
        }, 1000);
    </script>
</body>
</html>
EOF

# Set proper permissions
chmod 644 /var/www/html/index.html
