# Blender Stable Installer

## Objective
Install or upgrade the latest official stable Blender Linux x64 distribution from the Debian desktop app scripts.

## Problem
The repository does not provide a Blender installer that discovers current stable releases or validates downloaded distribution archives.

## Scope
- Add `linux/debian/app/desktop/blender.sh`.
- Discover the highest semantic Blender release series and exact stable Linux x64 archive from Blender's official release index.
- Verify the archive against its matching official SHA-256 file, preserve the complete distribution tree under `/opt`, and atomically update `/usr/local/bin/blender`.

## Constraints
- Follow repository Bash section/logging conventions and strict mode.
- Reject unsupported architecture, missing tools, invalid metadata/assets/checksums, malformed archives, and unexpected archive layout.
- Use temporary directories with cleanup traps; do not run the installer or use sudo during verification.
- Do not use third-party metadata sources, push, open a PR, or run native RDD lifecycle commands.

## Task Checklist
- [x] Add the Blender installer with validated latest-stable discovery, checksum verification, safe tree installation, and atomic executable link update.
- [x] Run the requested syntax, ShellCheck (when available), and diff checks.
- [x] Commit this work unit on `feat/godot-stable-installer`; record the work-unit commit SHA below.

## Acceptance Criteria
- The script chooses only a `Blender<major>.<minor>/` series and `blender-X.Y.Z-linux-x64.tar.xz` asset, with the highest versions selected via version sorting.
- It downloads and validates the matching official SHA-256 data before extraction and rejects unsafe archive entries or incorrect layouts.
- It preserves a current version when already installed; otherwise it installs a complete versioned `/opt` tree and atomically points `/usr/local/bin/blender` to it.
- Verification never executes the installer or invokes sudo.

## Checks
- `bash -n linux/debian/app/desktop/blender.sh`
- `shellcheck linux/debian/app/desktop/blender.sh` when ShellCheck is installed
- `git diff --check`
- Live install: N/A; explicitly not run because this work unit forbids executing the installer or using sudo.

## Delivery Strategy
- `single-pr`
- Estimated authored changes: approximately 200 lines; one installer and its work-unit document.
- Rollback boundary: remove `linux/debian/app/desktop/blender.sh` and this task document.

## Verification and Commit Evidence
- `bash -n linux/debian/app/desktop/blender.sh` — passed.
- `shellcheck linux/debian/app/desktop/blender.sh` — passed.
- `git diff --check` — passed.
- Live install: N/A; explicitly not run because this work unit forbids executing the installer or using sudo.
- Work-unit commit: `8433620` (`feat: add Blender stable installer`).
