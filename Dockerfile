# Start with a minimal Alpine image
FROM alpine:3.18

# Install basic dependencies: Git, Curl, and Bash
RUN apk update && apk add --no-cache \
    git \
    curl \
    bash \
    chrony \
    go

# Manually install Go 1.21.1
RUN curl -LO https://go.dev/dl/go1.21.1.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz \
    && rm go1.21.1.linux-amd64.tar.gz

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"

# Clone the Cloudflare Roughtime repo
RUN git clone https://github.com/cloudflare/roughtime.git /opt/roughtime

# Build the Roughtime client (adjust the path based on repo exploration)
RUN cd /opt/roughtime \
    && go build ./cmd/getroughtime/main.go  # Adjust based on repo

# Copy the update_time script
COPY update_time.sh /usr/local/bin/update_time.sh
RUN chmod +x /usr/local/bin/update_time.sh

# Copy the custom Chrony configuration
COPY chrony.conf /etc/chrony/chrony.conf

# Start Chrony in the foreground
CMD /usr/sbin/chronyd -d

