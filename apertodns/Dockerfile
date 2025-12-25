# ============================================================================
# ApertoDNS DDNS Add-on for Home Assistant
#
# @author Andrea Ferro <support@apertodns.com>
# @version 2.1.0
# @link https://www.apertodns.com
# ============================================================================

ARG BUILD_FROM
FROM $BUILD_FROM

# Install required packages
RUN apk add --no-cache \
    curl \
    bash \
    jq

# Copy root filesystem
COPY rootfs /

# Set permissions
RUN chmod a+x /run.sh

# Set workdir
WORKDIR /

# Run script
CMD [ "/run.sh" ]
