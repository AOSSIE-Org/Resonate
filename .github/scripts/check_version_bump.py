#!/usr/bin/env python3
"""Check that pubspec.yaml's version was bumped relative to the base branch.

The Play Store and App Store reject an upload whose build number is not higher
than the last one they accepted. Flutter takes both numbers from pubspec.yaml's
`version: <semver>+<build>` line -- the semver becomes versionName /
CFBundleShortVersionString and the build number becomes versionCode /
CFBundleVersion. A release PR that forgets to touch that line produces a binary
the store will refuse, which is only discovered at upload time.

Usage:
    check_version_bump.py --base-file <pubspec> --head-file <pubspec>
    check_version_bump.py --base 3.0.0+7 --head 3.0.1+8

Exits 0 when the version moved correctly, 1 when it did not, and 2 when either
version could not be read (a malformed pubspec is a failure worth shouting
about rather than skipping).
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# `version: 3.0.0+7`, tolerating comments and extra spacing.
_VERSION_LINE = re.compile(
    r"^version:\s*(?P<version>[^\s#]+)", re.MULTILINE
)
# Flutter allows a pre-release/build suffix on the semver half (3.0.0-beta.1+7).
_VERSION = re.compile(
    r"^(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)"
    r"(?P<pre>-[0-9A-Za-z.-]+)?"
    r"(?:\+(?P<build>\d+))?$"
)


class VersionError(Exception):
    """Raised when a version string or pubspec cannot be understood."""


class Version:
    def __init__(self, raw: str) -> None:
        match = _VERSION.match(raw.strip())
        if not match:
            raise VersionError(
                f"'{raw}' is not a Flutter version. Expected "
                "<major>.<minor>.<patch>+<build>, for example 3.0.1+8."
            )
        self.raw = raw.strip()
        self.release = (
            int(match["major"]),
            int(match["minor"]),
            int(match["patch"]),
        )
        self.pre = match["pre"] or ""
        self.build = int(match["build"]) if match["build"] is not None else None

    @property
    def release_str(self) -> str:
        return ".".join(str(part) for part in self.release) + self.pre

    def __str__(self) -> str:
        return self.raw


def read_version(path: Path) -> Version:
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as error:
        raise VersionError(f"could not read {path}: {error}") from error

    match = _VERSION_LINE.search(text)
    if not match:
        raise VersionError(f"{path} has no top-level `version:` line.")
    return Version(match["version"])


def compare(base: Version, head: Version) -> list[str]:
    """Return a list of problems; empty means the bump is acceptable."""
    problems: list[str] = []

    # A missing build number is the exact mistake this check exists to catch:
    # Flutter defaults versionCode to 1, so the upload collides immediately.
    if head.build is None:
        problems.append(
            f"`version: {head}` has no build number. Add one, for example "
            f"`{head.release_str}+{(base.build or 0) + 1}`."
        )
        return problems

    if base.build is None:
        # Nothing to compare against, but the head is well-formed, so allow it.
        return problems

    if head.build <= base.build:
        problems.append(
            f"the build number must increase: base is +{base.build}, "
            f"this branch is +{head.build}. "
            f"Try `{head.release_str}+{base.build + 1}`."
        )

    if head.release < base.release:
        problems.append(
            f"the version went backwards: base is {base.release_str}, "
            f"this branch is {head.release_str}."
        )

    return problems


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base-file", type=Path)
    parser.add_argument("--head-file", type=Path)
    parser.add_argument("--base")
    parser.add_argument("--head")
    args = parser.parse_args(argv)

    try:
        base = Version(args.base) if args.base else read_version(args.base_file)
        head = Version(args.head) if args.head else read_version(args.head_file)
    except VersionError as error:
        print(f"::error::Version check could not run: {error}")
        return 2
    except (AttributeError, TypeError):
        parser.error("pass either --base/--head or --base-file/--head-file")
        return 2

    problems = compare(base, head)
    if not problems:
        print(f"Version bumped: {base} -> {head}")
        return 0

    print(f"Version not bumped correctly: base {base}, this branch {head}")
    for problem in problems:
        print(f"  - {problem}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
