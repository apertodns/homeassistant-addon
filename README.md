# ApertoDNS Home Assistant Add-ons

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Release](https://img.shields.io/github/v/release/apertodns/homeassistant-addon)](https://github.com/apertodns/homeassistant-addon/releases)
[![Home Assistant Add-on](https://img.shields.io/badge/Home%20Assistant-Add--on-blue.svg)](https://www.home-assistant.io/addons/)

Official ApertoDNS add-ons repository for Home Assistant.

## Add-ons

### ApertoDNS DDNS

Keep your ApertoDNS dynamic DNS domains updated with your current public IP address.

**Features:**
- Automatic IP change detection
- Support for multiple domains
- Configurable update interval (60s - 24h)
- Multiple fallback IP detection services
- Two authentication methods (Token or Email/Password)
- Support for all architectures (amd64, aarch64, armv7, armhf, i386)
- Detailed logging with configurable levels

## Installation

### Step 1: Add Repository

1. Open Home Assistant
2. Go to **Settings** → **Add-ons** → **Add-on Store**
3. Click the menu (⋮) in the top right corner
4. Select **Repositories**
5. Add this repository URL:
   ```
   https://github.com/apertodns/homeassistant-addon
   ```
6. Click **Add** → **Close**

### Step 2: Install Add-on

1. Refresh the page or click the refresh button
2. Find **ApertoDNS DDNS** in the add-on store
3. Click **Install**

### Step 3: Configure

1. Go to the **Configuration** tab
2. Choose authentication method:

**Option A - DDNS Token (Recommended):**
```yaml
auth_method: token
token: "your-ddns-token-here"
domains:
  - "your-domain.apertodns.com"
```

**Option B - Email/Password:**
```yaml
auth_method: credentials
email: "your-email@example.com"
password: "your-password"
domains:
  - "your-domain.apertodns.com"
```

3. Click **Save**
4. Start the add-on

## Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `auth_method` | Authentication method: `token` or `credentials` | `token` |
| `token` | Your DDNS token from ApertoDNS dashboard | - |
| `email` | Your ApertoDNS account email | - |
| `password` | Your ApertoDNS account password | - |
| `domains` | List of domains to update | `[]` |
| `update_interval` | Update interval in seconds (60-86400) | `300` |
| `log_level` | Log level: `debug`, `info`, `warning`, `error` | `info` |

## Getting Your DDNS Token

1. Log in to [ApertoDNS Dashboard](https://www.apertodns.com/dashboard)
2. Go to your domain settings
3. Click **Generate DDNS Token**
4. Copy the token and paste it in the add-on configuration

## Supported Architectures

- `amd64` - Intel/AMD 64-bit
- `aarch64` - ARM 64-bit (Raspberry Pi 4, etc.)
- `armv7` - ARM 32-bit v7 (Raspberry Pi 3, etc.)
- `armhf` - ARM 32-bit hard-float
- `i386` - Intel/AMD 32-bit

## Troubleshooting

### Add-on won't start
- Check that your token or credentials are correct
- Verify you have at least one domain configured
- Check the logs for detailed error messages

### IP not updating
- Ensure your Home Assistant has internet access
- Check if the domain exists in your ApertoDNS account
- Try reducing the update interval

### Authentication errors
- Regenerate your DDNS token in the ApertoDNS dashboard
- If using email/password, verify your credentials work on the web

## Documentation

- **ApertoDNS Website:** https://www.apertodns.com
- **Documentation:** https://www.apertodns.com/docs
- **Support:** support@apertodns.com

## Changelog

See [CHANGELOG.md](apertodns/CHANGELOG.md) for release history.

## License

MIT License - Copyright (c) 2024-2025 Andrea Ferro - ApertoDNS

## Author

**Andrea Ferro**
Email: support@apertodns.com
Website: https://www.apertodns.com
