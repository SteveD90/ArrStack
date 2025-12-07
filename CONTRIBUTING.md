# Contributing to ArrStack

Thank you for considering contributing to ArrStack! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow

## How to Contribute

### Reporting Issues

1. Check if the issue already exists
2. Use the issue template if available
3. Include:
   - Description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, Docker version, etc.)
   - Relevant logs or error messages

### Suggesting Enhancements

1. Check existing issues and discussions
2. Clearly describe the enhancement
3. Explain the use case and benefits
4. Consider backward compatibility

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/ArrStack.git
   cd ArrStack
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Update documentation as needed
   - Test your changes thoroughly

4. **Commit with clear messages**
   ```bash
   git commit -m "Add: Description of what you added"
   git commit -m "Fix: Description of what you fixed"
   git commit -m "Update: Description of what you updated"
   ```

5. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then open a pull request on GitHub

## Development Guidelines

### Docker Compose Changes

- Test with `docker compose config` before committing
- Ensure all services start successfully
- Use environment variables for configuration
- Document any new variables in `.env.example`

### Documentation

- Update README.md for major changes
- Keep documentation clear and concise
- Include examples where helpful
- Check for typos and grammar

### Scripts

- Use bash for shell scripts
- Include error handling (`set -euo pipefail`)
- Add comments for complex logic
- Make scripts executable (`chmod +x`)

### Security

- Never commit secrets or credentials
- Always use environment variables for sensitive data
- Review .gitignore before committing
- Scan Docker images for vulnerabilities

## Testing

### Local Testing

Before submitting a PR:

1. **Test docker-compose**
   ```bash
   docker compose config
   docker compose up -d
   docker compose ps
   docker compose logs
   ```

2. **Test scripts**
   ```bash
   shellcheck *.sh  # If shellcheck is installed
   bash -n create_dirs.sh  # Check syntax
   ```

3. **Verify documentation**
   - Check all links work
   - Ensure code examples are correct
   - Preview markdown rendering

### Integration Testing

- Test on a clean environment if possible
- Verify all services can communicate
- Check file permissions and ownership
- Test backup and restore procedures

## Commit Message Guidelines

Use conventional commits format:

- `Add:` New features or files
- `Fix:` Bug fixes
- `Update:` Changes to existing functionality
- `Remove:` Removed features or files
- `Docs:` Documentation changes
- `Style:` Formatting, no code change
- `Refactor:` Code refactoring
- `Test:` Adding tests
- `Chore:` Maintenance tasks

Examples:
```
Add: Support for custom SABnzbd categories
Fix: Permission issues with downloads directory
Update: Docker Compose to version 3.8
Docs: Improve installation instructions
```

## Project Structure

```
ArrStack/
├── .github/
│   └── workflows/          # GitHub Actions
├── .env.example            # Environment template
├── docker-compose.yaml     # Service definitions
├── create_dirs.sh         # Directory setup script
├── backup_configs.sh      # Backup script
├── Dockerfile.example     # Sample Dockerfile
├── README.md              # Main documentation
├── DOCKER_HUB.md         # Docker Hub guide
├── SETUP_GUIDE.md        # Setup instructions
└── CONTRIBUTING.md       # This file
```

## Review Process

1. Automated checks run on all PRs
2. Maintainers review code and documentation
3. Changes may be requested
4. Once approved, PR will be merged
5. Changes deployed in next release

## Release Process

1. Update version in relevant files
2. Update CHANGELOG (if exists)
3. Create git tag: `git tag -a v1.0.0 -m "Release v1.0.0"`
4. Push tag: `git push origin v1.0.0`
5. GitHub Actions builds and publishes to Docker Hub
6. Create GitHub Release with notes

## Questions?

- Open a discussion on GitHub
- Check existing documentation
- Review closed issues for similar questions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

Thank you for contributing to ArrStack! 🎉
