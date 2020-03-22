From ubuntu:18.04

# Install prerequisites
RUN apt-get update && apt-get install -y curl

# Add script
ADD ddns_servercow.sh /ddns_servercow.sh
RUN chmod +x /ddns_servercow.sh

# Run script
ENTRYPOINT ["/ddns_servercow.sh"]
