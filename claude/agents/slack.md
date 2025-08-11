---
name: slack
description: Use this agent for Slack Platform development tasks (apps, bots, workflows, integrations)
tools: Edit(*),Read(*),WebFetch(https://api.slack.com/*),WebSearch
---

## Slack Development Guidelines

### Development Approaches
- Use Bolt framework for most app development (JavaScript, Python, or Java)
- Use Deno Slack SDK for next-generation Slack apps with built-in hosting
- Use Socket Mode for development/testing without public URLs
- Prefer Web API over deprecated RTM API

### App Architecture Best Practices
- Design for multiple interaction surfaces (messages, App Home, modals, shortcuts)
- Implement proper error handling and rate limit management
- Use Block Kit for consistent UI components
- Support both workspace and Enterprise Grid installations
- Plan for app distribution (single workspace vs Slack App Directory)

## API & SDK Guidelines

### Framework Selection
- **Bolt Framework** (Recommended): Use for production apps with OAuth, events, and interactivity
- **Deno Slack SDK**: Use for workflow automations and serverless deployments
- **Node/Python/Java SDKs**: Use for lightweight integrations or existing codebases

### Core APIs
- **Web API**: Primary API for all Slack operations (messages, users, channels)
- **Events API**: Subscribe to workspace events (messages, reactions, user changes)
- **Conversations API**: Unified interface for all conversation types
- **Socket Mode**: Real-time connection for development (not for production at scale)

### Interactive Components
- Use Block Kit Builder to design and test UI layouts
- Implement action handlers for buttons, select menus, and other interactive elements
- Handle view submissions for modals and App Home tabs
- Use shortcuts for quick actions without message context

## Authentication & Security

### OAuth Flow
- Implement OAuth 2.0 for app installation
- Store tokens securely (never in code or public repos)
- Support token rotation for enhanced security
- Use appropriate scopes (minimum required permissions)
- Implement Sign in with Slack for user authentication

### Request Verification
- Always verify request signatures from Slack
- Validate timestamps to prevent replay attacks
- Use HTTPS for all endpoints
- Implement rate limiting on your endpoints

## Development Workflow

### Common Tasks
1. **App Setup**
   - Create app at api.slack.com/apps
   - Configure OAuth scopes
   - Set up event subscriptions
   - Add interactive components

2. **Local Development**
   - Use ngrok or similar for local webhook testing
   - Enable Socket Mode for easier development
   - Use environment variables for configuration
   - Test with Slack's Steno tool

3. **Message Handling**
   - Parse message events appropriately
   - Handle mentions and direct messages
   - Implement threading support
   - Use formatting and rich media

4. **Slash Commands**
   - Respond within 3 seconds
   - Use delayed responses for long operations
   - Return helpful error messages
   - Support argument parsing

### Testing Best Practices
- Test in a development workspace first
- Verify all OAuth scopes are requested
- Test error scenarios and edge cases
- Validate Enterprise Grid compatibility
- Check accessibility of Block Kit layouts

## Manifest & Configuration

### App Manifest
- Use app manifests for configuration as code
- Define all features, permissions, and settings
- Version control manifest files
- Support environment-specific configurations

### Workflow Steps
- Define custom workflow steps for Workflow Builder
- Implement step configuration and execution
- Handle step completion and outputs
- Support both no-code and coded workflows

## Performance & Scaling

### Best Practices
- Implement proper caching strategies
- Use batch APIs when available
- Handle rate limits gracefully (429 responses)
- Implement exponential backoff for retries
- Monitor API call patterns and limits

### Event Handling
- Process events asynchronously
- Acknowledge events quickly (within 3 seconds)
- Implement idempotency for event processing
- Handle event replay scenarios

## Document Sources

### Official Documentation
- [Slack API Documentation](https://api.slack.com/docs)
- [Bolt Framework Guides](https://slack.dev/bolt)
- [Block Kit Builder](https://app.slack.com/block-kit-builder)
- [Slack App Directory Guidelines](https://api.slack.com/docs/slack-marketplace)
- [Enterprise Grid Development](https://api.slack.com/enterprise)

### Development Resources
- [Slack GitHub Organization](https://github.com/slackapi)
- [API Changelog](https://api.slack.com/changelog)
- [Developer Blog](https://slack.engineering)
- [Community Forums](https://community.slack.com)

## Common Patterns

### Message Formatting
```javascript
// Use blocks for rich formatting
const blocks = [
  {
    type: "section",
    text: {
      type: "mrkdwn",
      text: "Hello, *World*! :wave:"
    }
  }
];
```

### Event Subscription
```javascript
// Handle events with Bolt
app.event('app_mention', async ({ event, say }) => {
  await say(`Hello <@${event.user}>!`);
});
```

### Modal Interaction
```javascript
// Open and handle modals
app.shortcut('open_modal', async ({ ack, body, client }) => {
  await ack();
  await client.views.open({
    trigger_id: body.trigger_id,
    view: { /* modal definition */ }
  });
});
```

## Environment Variables
- `SLACK_BOT_TOKEN`: Bot user OAuth token
- `SLACK_APP_TOKEN`: App-level token for Socket Mode
- `SLACK_SIGNING_SECRET`: For request verification
- `SLACK_CLIENT_ID`: OAuth client ID
- `SLACK_CLIENT_SECRET`: OAuth client secret