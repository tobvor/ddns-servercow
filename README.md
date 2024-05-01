# Dynamic DNS Updater
This container is a dyndns client for servercow. 
It is designed to run in a Docker container and updates the DNS records of a domain hosted on Servercow.de with the current public IP address of the container.

## Prerequisites

Before running this script, ensure you have the following:

- Docker installed on your system.
- Access to a domain hosted on Servercow.de.
- Servercow.de API credentials (username and password).

## Usage

### Environment Variables

- `DOMAIN`: The domain name for which DNS records need to be updated.
- `USER`: Your Servercow.de API username.
- `PASSWORD`: Your Servercow.de API password.
- `INTERVAL` (optional): Interval in seconds between each DNS update (default is 120 seconds).
- `SUBDOMAIN` (optional): Subdomain to update (default is the root domain).

### Running the Docker Container

1. Build the Docker image:

```bash
docker build -t dynamic-dns-updater .
```

2. Run the Docker container:

```bash
docker run -d \
  --name dynamic-dns \
  -e DOMAIN="yourdomain.com" \
  -e USER="your_api_username" \
  -e PASSWORD="your_api_password" \
  dynamic-dns-updater
```

### Notes

- Make sure to replace `"yourdomain.com"`, `"your_api_username"`, and `"your_api_password"` with your actual domain name, Servercow.de API username, and password respectively.
- If you want to specify a subdomain, you can set the `SUBDOMAIN` environment variable accordingly.

## Behavior

The script continuously checks the public IP address of the container at a specified interval. If the IP address changes, it updates the DNS records of the specified domain/subdomain on Servercow.de accordingly.

## License

This script is licensed under the [MIT License](LICENSE). Feel free to modify and distribute it as needed.
