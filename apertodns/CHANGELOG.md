# Changelog

## [2.1.0] - 2024-12-25

### Added
- **Two authentication methods**:
  - DDNS Token (recommended) - More secure, revocable
  - Email + Password - For convenience
- New `auth_method` configuration option
- Improved documentation with both authentication examples

### Changed
- Updated configuration schema to support both auth methods
- Enhanced logging to show which authentication method is in use

## [2.0.1] - 2024-12-25

### Added
- Initial release of ApertoDNS DDNS Add-on for Home Assistant
- Support for multiple domains
- Configurable update interval (60-86400 seconds)
- Multiple IP detection services with fallback
- Detailed logging with configurable levels
- DDNS Token authentication
- Automatic IP change detection

### Features
- Multi-architecture support (aarch64, amd64, armhf, armv7, i386)
- Boot on startup option
- Seamless Home Assistant integration
