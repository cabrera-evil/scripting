# Godot Stable Installer

## Objective
Install or upgrade the official latest stable Godot Linux x86_64 editor safely from the Debian terminal menu.

## Problem
The repository has no Godot installer, so users cannot install or update the editor through its existing script collection.

## Scope
- Add a Bash installer at `linux/debian/app/terminal/godot.sh`.
- Resolve the latest release and its official non-.NET x86_64 ZIP from GitHub release metadata.
- Detect an already-current installation and otherwise install/upgrade `/usr/local/bin/godot`.

## Constraints
- Follow the existing Bash section and logging conventions and use strict mode.
- Fail clearly for unsupported architecture, missing tools, network/API failures, and missing/invalid assets.
- Validate the ZIP before extraction; do not run the installer or invoke sudo during development verification.
- Do not push, open a PR, or run native RDD lifecycle commands.

## Task Checklist
- [x] Add the Godot installer with latest stable metadata lookup, safe archive validation, version comparison, and privileged install.
- [x] Run the requested syntax, ShellCheck (when available), and diff checks.
- [x] Commit this work unit on `feat/godot-stable-installer`; record the work-unit commit SHA below.

## Acceptance Criteria
- The installer selects only `Godot_v<version>-stable_linux.x86_64.zip` from the latest release API response.
- It skips successfully when the installed Godot version matches the latest stable version; otherwise upgrades safely.
- It reports actionable failures for required prerequisites, architecture, metadata/network, and release asset problems.
- No live install or sudo operation is performed as part of verification.

## Checks
- `bash -n linux/debian/app/terminal/godot.sh`
- `shellcheck linux/debian/app/terminal/godot.sh` when ShellCheck is installed
- `git diff --check`
- Live install: N/A; this work unit must not execute the installer or use sudo.

## Delivery Strategy
- `single-pr`
- Estimated authored changes: approximately 150 lines; one installer and its work-unit document.
- Rollback boundary: remove `linux/debian/app/terminal/godot.sh` and this task document.

## Verification and Commit Evidence
- `bash -n linux/debian/app/terminal/godot.sh` — passed.
- `shellcheck linux/debian/app/terminal/godot.sh` — passed.
- `git diff --check` — passed.
- Live install: N/A; explicitly not run because this work unit forbids executing the installer or using sudo.
- Work-unit commit: `d0aa009` (`feat: add Godot stable installer`).
