# Claude Workflow for Devastation Development

This document outlines the workflow for collaborating with Claude on Devastation container development.

## Workflow Phases

### 1. Discussion Phase
- Discuss the change needed or issue to be fixed
- Explore implementation options
- Define an implementation strategy
- Document any architecture or configuration changes needed

### 2. Planning Phase
- Present a detailed implementation plan
- Include specific file changes and approach
- Wait for review and approval before proceeding

### 3. Implementation Phase
- Implement the approved changes
- Make only the changes that were approved
- Follow code style and repository organization guidelines

### 4. Testing Phase
- Build the image: `make <container>`
- Launch interactively: `docker run -it --rm devastation/<container>:latest`
- Validate the implemented changes behave as expected

### 5. Feedback Phase
- Review results and address any issues
- Document any unexpected behavior
- Proceed to the next change once current change is verified

## Common Issues and Solutions

### Package Installation
- Prefer apt-get for installing packages when available in standard repositories
- Fall back to language-specific package managers (pip, npm, etc.) for packages not available via apt
- Use non-interactive flags whenever possible (`--no-input`, `--no-interaction`, etc.)
- Avoid commands that execute programmatically during build as they may cause hangs

### Configuration
- Maintain consistent configuration patterns between containers
- Use symlinks and environment variables to ensure tools are properly available
- Follow the principle of least surprise when modifying configurations
