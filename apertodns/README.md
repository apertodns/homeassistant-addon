# ApertoDNS DDNS Add-on for Home Assistant

Official ApertoDNS Dynamic DNS add-on for Home Assistant. Keep your ApertoDNS domains updated with your current public IP address automatically.

## Installation

### Method 1: Add Repository (Recommended)

1. Open Home Assistant
2. Go to **Settings** > **Add-ons** > **Add-on Store**
3. Click the menu (⋮) in the top right corner
4. Select **Repositories**
5. Add this repository URL:
   ```
   https://github.com/apertodns/homeassistant-addon
   ```
6. Find "ApertoDNS DDNS" in the add-on store and click **Install**

### Method 2: Manual Installation

1. Copy the `apertodns` folder to your Home Assistant `addons` directory
2. Restart Home Assistant
3. Go to **Settings** > **Add-ons** > **Add-on Store**
4. Find "ApertoDNS DDNS" under "Local add-ons"

## Configuration

### Options

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `auth_method` | list | No | token | Authentication method: "token" or "credentials" |
| `token` | password | Conditional | - | Your ApertoDNS DDNS Token (64 hex characters). Required if auth_method is "token" |
| `email` | email | Conditional | - | Your ApertoDNS account email. Required if auth_method is "credentials" |
| `password` | password | Conditional | - | Your ApertoDNS account password. Required if auth_method is "credentials" |
| `domains` | list | Yes | - | List of domains to update |
| `update_interval` | int | No | 300 | Update interval in seconds (60-86400) |
| `log_level` | list | No | info | Log level (debug, info, warning, error) |

### Example Configuration

#### Method 1: DDNS Token (Recommended)

```yaml
auth_method: "token"
token: "your-64-character-ddns-token-here"
domains:
  - "myhost.apertodns.com"
  - "another.apertodns.com"
update_interval: 300
log_level: "info"
```

#### Method 2: Email + Password

```yaml
auth_method: "credentials"
email: "your@email.com"
password: "your_password"
domains:
  - "myhost.apertodns.com"
  - "another.apertodns.com"
update_interval: 300
log_level: "info"
```

## Where to Find Your DDNS Token

1. Log in to [ApertoDNS Dashboard](https://www.apertodns.com)
2. Navigate to **Domains**
3. Select your domain
4. Find the **DDNS Token** field (64 character hex string)

> **Note:** The DDNS Token method is recommended as it provides better security - tokens can be revoked individually without changing your account password.

## Response Codes

The add-on will log the following responses:

| Response | Description |
|----------|-------------|
| `good` | Update successful |
| `nochg` | IP unchanged (no update needed) |
| `badauth` | Authentication failed - check your token |
| `notfqdn` | Domain not found in your account |
| `abuse` | Too many requests - update rate limited |
| `911` | Server error - will retry |

## Troubleshooting

### Check Logs

1. Go to **Settings** > **Add-ons** > **ApertoDNS DDNS**
2. Click the **Log** tab

### Common Issues

**"Authentication failed"**
- Verify your DDNS token is correct (64 hex characters)
- Ensure you're using the DDNS Token, not your account password

**"Domain not found"**
- Check the domain name is spelled correctly
- Verify the domain exists in your ApertoDNS account

**"Could not determine public IP"**
- Check your internet connection
- The add-on uses multiple IP services as fallback

## Support

- **Documentation:** https://www.apertodns.com/docs#rn-homeassistant
- **Email:** support@apertodns.com
- **Website:** https://www.apertodns.com

## License

MIT License - Copyright (c) 2024 ApertoDNS

## Author

Andrea Ferro <support@apertodns.com>
