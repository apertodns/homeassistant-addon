#!/usr/bin/with-contenv bashio
# ============================================================================
# ApertoDNS DDNS Add-on for Home Assistant
#
# Main run script that handles DDNS updates at configured intervals.
# Supports two authentication methods:
#   1. DDNS Token (recommended) - Using token:token format
#   2. Email + Password - Using email:password format
#
# @author Andrea Ferro <support@apertodns.com>
# @version 2.1.0
# @link https://www.apertodns.com
# ============================================================================

set -e

# ============================================================================
# Configuration
# ============================================================================

API_URL="https://api.apertodns.com/nic/update"
IP_SERVICES=(
    "https://api.ipify.org"
    "https://ifconfig.me"
    "https://icanhazip.com"
    "https://ipinfo.io/ip"
)

# ============================================================================
# Read configuration from Home Assistant
# ============================================================================

AUTH_METHOD=$(bashio::config 'auth_method')
TOKEN=$(bashio::config 'token')
EMAIL=$(bashio::config 'email')
PASSWORD=$(bashio::config 'password')
DOMAINS=$(bashio::config 'domains')
UPDATE_INTERVAL=$(bashio::config 'update_interval')
LOG_LEVEL=$(bashio::config 'log_level')

# Set defaults
AUTH_METHOD=${AUTH_METHOD:-token}
UPDATE_INTERVAL=${UPDATE_INTERVAL:-300}
LOG_LEVEL=${LOG_LEVEL:-info}

# Validate authentication based on method
if [ "$AUTH_METHOD" == "token" ]; then
    if [ -z "$TOKEN" ]; then
        bashio::log.fatal "DDNS Token is required when using token authentication."
        bashio::log.fatal "Get your token from the ApertoDNS dashboard."
        exit 1
    fi
    AUTH_USER="$TOKEN"
    AUTH_PASS="$TOKEN"
elif [ "$AUTH_METHOD" == "credentials" ]; then
    if [ -z "$EMAIL" ] || [ -z "$PASSWORD" ]; then
        bashio::log.fatal "Email and password are required when using credentials authentication."
        exit 1
    fi
    AUTH_USER="$EMAIL"
    AUTH_PASS="$PASSWORD"
else
    bashio::log.fatal "Invalid auth_method: $AUTH_METHOD. Use 'token' or 'credentials'."
    exit 1
fi

if [ -z "$DOMAINS" ] || [ "$DOMAINS" == "null" ]; then
    bashio::log.fatal "At least one domain is required."
    exit 1
fi

# ============================================================================
# Logging functions
# ============================================================================

log_debug() {
    if [ "$LOG_LEVEL" == "debug" ]; then
        bashio::log.debug "$1"
    fi
}

log_info() {
    if [ "$LOG_LEVEL" == "debug" ] || [ "$LOG_LEVEL" == "info" ]; then
        bashio::log.info "$1"
    fi
}

log_warning() {
    if [ "$LOG_LEVEL" != "error" ]; then
        bashio::log.warning "$1"
    fi
}

log_error() {
    bashio::log.error "$1"
}

# ============================================================================
# Get current public IP
# ============================================================================

get_public_ip() {
    local ip=""

    for service in "${IP_SERVICES[@]}"; do
        log_debug "Trying to get IP from $service"
        ip=$(curl -s --max-time 10 "$service" 2>/dev/null | tr -d '\n\r ')

        # Validate IP format (basic IPv4 check)
        if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            log_debug "Got IP $ip from $service"
            echo "$ip"
            return 0
        fi

        log_debug "Invalid response from $service: $ip"
    done

    log_error "Failed to determine public IP from any service"
    return 1
}

# ============================================================================
# Update a single domain
# ============================================================================

update_domain() {
    local domain="$1"
    local ip="$2"

    log_debug "Updating domain: $domain with IP: $ip"

    local response
    response=$(curl -s --max-time 30 \
        -u "${AUTH_USER}:${AUTH_PASS}" \
        "${API_URL}?hostname=${domain}&myip=${ip}" 2>&1)

    local result
    result=$(echo "$response" | tr '[:upper:]' '[:lower:]' | cut -d' ' -f1)

    case "$result" in
        good*)
            log_info "Domain $domain updated successfully (IP: $ip)"
            return 0
            ;;
        nochg*)
            log_debug "Domain $domain - IP unchanged ($ip)"
            return 0
            ;;
        badauth*)
            log_error "Domain $domain - Authentication failed. Check your credentials."
            return 1
            ;;
        notfqdn*|nohost*)
            log_error "Domain $domain - Domain not found. Verify the domain exists in your account."
            return 1
            ;;
        abuse*)
            log_error "Domain $domain - Too many update requests. Please wait before retrying."
            return 1
            ;;
        911*)
            log_error "Domain $domain - Server error. Will retry later."
            return 1
            ;;
        *)
            log_warning "Domain $domain - Unknown response: $response"
            return 1
            ;;
    esac
}

# ============================================================================
# Main update loop
# ============================================================================

bashio::log.info "=========================================="
bashio::log.info "  ApertoDNS DDNS Add-on v2.1.0"
bashio::log.info "=========================================="
bashio::log.info "Authentication: ${AUTH_METHOD}"
bashio::log.info "Update interval: ${UPDATE_INTERVAL} seconds"
bashio::log.info "Log level: ${LOG_LEVEL}"
bashio::log.info "Domains configured: $(echo "$DOMAINS" | jq -r 'length')"
bashio::log.info "=========================================="

LAST_IP=""

while true; do
    log_debug "Starting update cycle"

    # Get current public IP
    CURRENT_IP=$(get_public_ip)

    if [ -z "$CURRENT_IP" ]; then
        log_warning "Could not determine public IP. Retrying in ${UPDATE_INTERVAL} seconds..."
        sleep "$UPDATE_INTERVAL"
        continue
    fi

    # Check if IP changed
    if [ "$CURRENT_IP" != "$LAST_IP" ]; then
        log_info "IP changed: ${LAST_IP:-'(none)'} -> $CURRENT_IP"

        # Update all domains
        for domain in $(echo "$DOMAINS" | jq -r '.[]'); do
            update_domain "$domain" "$CURRENT_IP"
        done

        LAST_IP="$CURRENT_IP"
    else
        log_debug "IP unchanged ($CURRENT_IP), skipping update"
    fi

    log_debug "Sleeping for ${UPDATE_INTERVAL} seconds"
    sleep "$UPDATE_INTERVAL"
done
