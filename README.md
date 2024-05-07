# Dynamic DNS Updater for Servercow
This container is a dyndns client for servercow. 
It is designed to run in a Docker environment and updates the DNS records of a domain hosted on servercow.de with the current public IP address.


## Prerequisites

Before running this script, ensure you have the following:

- Docker installed on your system.
- Access to a domain hosted on servercow.de.
- Servercow.de credentials (username and password) with access to the DNS API.

## Usage

### Environment Variables

- `DOMAIN`: The domain name for which DNS records need to be updated.
- `USER`: servercow.de username (user needs access to the DNS API).
- `PASSWORD`: servercow.de password.
- `INTERVAL` (optional): Interval in seconds between each DNS update (default is 120 seconds).
- `SUBDOMAIN` (optional): Subdomain to update (default is the root domain).
- `IPv4` (optional): Whether to update IPv4 address (default is true).
- `IPv6` (optional): Whether to update IPv6 address (default is false). See notes below. ⚠️  
- `PROVIDER_IPv4` (optional): Provider URL to fetch IPv4 address (default is http://ifconfig.co).
- `PROVIDER_IPv6` (optional): Provider URL to fetch IPv6 address (default is http://ifconfig.co).

### Running the Docker Container

1. Run the Docker container:

```bash
docker run -d \
  --name ddns-servercow \
  -e DOMAIN="yourdomain.com" \
  -e USER="your_api_username" \
  -e PASSWORD="your_api_password" \
  -e IPv4="true" \
  -e IPv6="false" \
  tobvor/ddns-servercow
```

2. Docker Compose Example

```yaml
version: '3'

services:
  ddns-servercow:
    image: tobvor/ddns-servercow
    container_name: ddns-servercow
    environment:
      - DOMAIN=yourdomain.com
      - USER=your_api_username
      - PASSWORD=your_api_password
      - IPv4=true
      - IPv6=false
    restart: always
```

### Notes

- Make sure to replace `"yourdomain.com"`, `"your_api_username"`, and `"your_api_password"` with your actual domain name, Servercow.de API username, and password respectively.
- If you want to specify a subdomain, you can set the `SUBDOMAIN` environment variable accordingly.
- You can enable/disable IPv4 and IPv6 updates by setting the `IPv4` and `IPv6` environment variables.
- If you want to use a different provider to fetch IP addresses, you can set `PROVIDER_IPv4` and `PROVIDER_IPv6` environment variables accordingly.
- ⚠️ If the parameter `IPv6` is set to `true`, either IPv6 support must be activated for Docker (see [Enable IPv6 support](https://docs.docker.com/config/daemon/ipv6/)) or the container must be executed within the host network using `network_mode: host`. 

## Behavior

The script continuously checks the public IP address of the container at a specified interval. If the IP address changes, it updates the DNS records of the specified domain/subdomain on Servercow.de accordingly.

## License

This script is licensed under the [MIT License](LICENSE). Feel free to modify and distribute it as needed.