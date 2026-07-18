# Security Policy

## Supported versions

Only the latest release is supported. Update before reporting.

## Reporting a vulnerability

Please **do not open a public issue** for security problems.

Instead, either:

- Use GitHub's [private vulnerability reporting](https://github.com/ousid/claudebar/security/advisories/new), or
- Email **oussama@coderflex.com** with a description and steps to reproduce.

You'll get a response within a few days. Once fixed, the issue will be disclosed in the release notes with credit to the reporter (unless you prefer to stay anonymous).

## Scope

Especially interested in:

- OAuth flow weaknesses (token exchange, state/PKCE handling)
- Keychain token exposure
- Anything that could leak the token or usage data to a third party

Out of scope: issues in Anthropic's endpoints themselves (report those to [Anthropic](https://www.anthropic.com/security)), and attacks requiring an already-compromised machine.
