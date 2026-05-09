# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Copilot, etc.) when working with code in this repository.

## Repository Overview

A collection of skills for Claude.ai and Claude Code. Skills are packaged instructions and scripts that extend Claude's capabilities.

## Creating a New Skill

### Directory Structure

```
skills/
  {skill-name}/           # kebab-case directory name
    SKILL.md              # Required: skill definition
    scripts/              # Optional: executable code
      {script-name}.sh    # Bash scripts (preferred)
    references/           # Optional: documentation
    assets/               # Optional: templates, resources
    ...                   # Any additional files or directories
  {skill-name}.zip        # Required: packaged for distribution
```

### Naming Conventions

- **Skill directory**: `kebab-case` (e.g., `app-deploy`, `log-monitor`)
- **SKILL.md**: Always uppercase, always this exact filename
- **Scripts**: `kebab-case.sh` (e.g., `deploy.sh`, `fetch-logs.sh`)
- **Zip file**: Must match directory name exactly: `{skill-name}.zip`

### SKILL.md Format

```markdown
---
name: {skill-name}
description: "{One sentence describing when to use this skill. Include trigger phrases and discovery keywords. Always quote if the value contains colons (:)."
license: {SPDX license identifier, e.g., MIT or Apache-2.0}
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - {skill-name}
  - {natural language trigger phrase}
  - {task-oriented trigger phrase}
---

# {Skill Title}

{Brief description of what the skill does.}

## How It Works

{Numbered list explaining the skill's workflow}

## Usage

```bash
bash /mnt/skills/user/{skill-name}/scripts/{script}.sh [args]
```

**Arguments:**
- `arg1` - Description (defaults to X)

**Examples:**
{Show 2-3 common usage patterns}

## Output

{Show example output users will see}

## Present Results to User

{Template for how Claude should format results when presenting to users}

## Troubleshooting

{Common issues and solutions, especially network/permissions errors}
```

Required frontmatter standards:

- `name` must exactly match the skill folder name in `skills/{skill-name}/`.
- `description` must explain when to use the skill and include user-facing discovery phrases.
- `metadata.author` must be `gustavog-gutierrez`.
- `metadata.version` must be present as a quoted string.
- `allowed-tools` must list the minimum tools needed by the skill.
- `triggers` must include the skill name, spaced name, and 2+ common user intents so agents can auto-discover it.
- Avoid unrelated vendor or project names in examples unless the skill is specifically about that vendor or project.

### Skill Writing Standards

- Write all skill content in English, including headings, instructions, examples, comments, templates, and scripts unless a skill's explicit purpose is translation or localization.
- Skills must be generic in domain: they should apply to any project and avoid references to specific vendors, platforms, organizations, products, repositories, or internal team names unless the skill is specifically about that domain.
- Skills must be specific in behavior: describe concrete actions, required inputs, decision rules, outputs, validation steps, and failure handling.
- Skills must be strict in structure and rules: use explicit sections, ordered workflows, required outputs, guardrails, and quality checks instead of vague guidance.
- Examples must use neutral placeholders such as `existing system of record`, `approved provider`, `project documentation`, `domain user`, or `organization standard` instead of vendor-specific names.
- If a technology, provider, framework, or tool is not essential to the skill's purpose, describe the capability generically rather than naming the product.
- Do not include project-specific assumptions. If context is unknown, instruct the agent to ask a clarifying question or mark the value as `TBD`.

### Most Important Rule: Reusable Capability, Not Project Context

A skill must be treated as a reusable professional capability, specialized behavior, micro-methodology, or reasoning mode.

A skill must **not** contain:

- Specific business context
- Project names
- Customer or client names
- Unnecessary concrete technologies
- Temporary timeline details
- Mutable information that belongs in project documentation, memory, or requirements

A skill **must** contain:

- Behavior
- Methodology
- Rules
- Output format
- Standards
- Constraints
- Expected quality bar
- Mental workflow
- Expected output

Before creating or updating any skill, verify that every section teaches reusable behavior rather than documenting a specific project, business context, or one-off requirement.

### Best Practices for Context Efficiency

Skills are loaded on-demand — only the skill name and description are loaded at startup. The full `SKILL.md` loads into context only when the agent decides the skill is relevant. To minimize context usage:

- **Keep SKILL.md under 500 lines** — put detailed reference material in separate files
- **Write specific descriptions** — helps the agent know exactly when to activate the skill
- **Use progressive disclosure** — reference supporting files that get read only when needed
- **Prefer scripts over inline code** — script execution doesn't consume context (only output does)
- **File references work one level deep** — link directly from SKILL.md to supporting files

### Script Requirements

- Use `#!/bin/bash` shebang
- Use `set -e` for fail-fast behavior
- Write status messages to stderr: `echo "Message" >&2`
- Write machine-readable output (JSON) to stdout
- Include a cleanup trap for temp files
- Reference the script path as `/mnt/skills/user/{skill-name}/scripts/{script}.sh`

### Creating the Zip Package

After creating or updating a skill:

```bash
cd skills
zip -r {skill-name}.zip {skill-name}/
```

### YAML Frontmatter Validation

Before committing a new or modified skill, validate the SKILL.md frontmatter to ensure the skills CLI can parse it:

```bash
python3 -c "
import yaml, sys

with open('skills/{skill-name}/SKILL.md', 'r') as f:
    content = f.read()

frontmatter = content.split('---')[1]
try:
    data = yaml.safe_load(frontmatter)
    required = ['name', 'description', 'license', 'metadata', 'allowed-tools', 'triggers']
    for field in required:
        if field not in data:
            print(f'ERROR: Missing required field: {field}')
            sys.exit(1)
    # Check metadata subfields
    if 'author' not in data.get('metadata', {}):
        print('ERROR: Missing metadata.author')
        sys.exit(1)
    if 'version' not in data.get('metadata', {}):
        print('ERROR: Missing metadata.version')
        sys.exit(1)
    print('OK: Frontmatter is valid YAML with all required fields')
except yaml.error.YAMLError as e:
    print(f'YAML PARSE ERROR: {e}')
    sys.exit(1)
"
```

**Common pitfalls that break the skills CLI:**

- Description contains `:` (colon) without quotes — YAML interprets it as a new mapping key
  - **Wrong:** `description: Design systems: patterns, components, and guidelines`
  - **Right:** `description: "Design systems: patterns, components, and guidelines"`
- Any frontmatter field value containing special YAML characters (`:`, `#`, `{`, `}`, `[`, `]`) must be quoted
- Indentation must be consistent (2 spaces, no tabs)

### End-User Installation

Document these two installation methods for users:

**Claude Code:**
```bash
cp -r skills/{skill-name} ~/.claude/skills/
```

**claude.ai:**
Add the skill to project knowledge or paste SKILL.md contents into the conversation.

If the skill requires network access, instruct users to add required domains at `claude.ai/settings/capabilities`.
