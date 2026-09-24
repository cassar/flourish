#!/usr/bin/env python3
"""Bump the pinned Ruby or Node version across this repo's version files.

Usage: runtime_bump.py ruby|node [--dry-run]

Prefers a newer patch in the current series (Ruby X.Y, Node X); only when
there is none does it move to the newest stable series. Prints GitHub Actions
outputs (from, to, kind) to stdout; prints nothing if there's no bump to make,
or the target isn't installable yet (Docker Hub image / node-build definition).

kind=patch -> safe to auto-merge; kind=major -> needs review.
"""
import json
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

RUBY_RELEASES = "https://raw.githubusercontent.com/ruby/www.ruby-lang.org/master/_data/releases.yml"
RUBY_IMAGE = "https://hub.docker.com/v2/repositories/library/ruby/tags/{}-slim"
NODE_RELEASES = "https://nodejs.org/dist/index.json"
NODE_BUILD_DEF = "https://raw.githubusercontent.com/nodenv/node-build/master/share/node-build/{}"

VERSION = r"\d+\.\d+\.\d+"


def fetch(url):
    with urllib.request.urlopen(url, timeout=30) as r:
        return r.read().decode()


def exists(url):
    try:
        with urllib.request.urlopen(url, timeout=30) as r:
            return r.status == 200
    except urllib.error.HTTPError:
        return False


def parse(v):
    return tuple(int(p) for p in v.split("."))


def ruby_current():
    return Path(".ruby-version").read_text().strip().removeprefix("ruby-")


def ruby_releases():
    # Only plain X.Y.Z entries -- skips previews/RCs (e.g. 4.1.0-preview1)
    return re.findall(rf"^- version: ({VERSION})\s*$", fetch(RUBY_RELEASES), re.M)


def node_current():
    return Path(".node-version").read_text().strip().removeprefix("v")


def node_releases():
    return [r["version"].removeprefix("v") for r in json.loads(fetch(NODE_RELEASES)) if r["lts"]]


# (path, pattern, replacement-template) -- only these exact spots are ever edited.
# {v} is the new version, {major} its major number.
RUBY_FILES = [
    (".ruby-version", r"^(ruby-)?" + VERSION + "$", r"\g<1>{v}"),
    (".tool-versions", r"^ruby " + VERSION + "$", "ruby {v}"),
    ("Dockerfile", r"^ARG RUBY_VERSION=" + VERSION + "$", "ARG RUBY_VERSION={v}"),
    ("Dockerfile.ci", r"^ARG RUBY_VERSION=" + VERSION + "$", "ARG RUBY_VERSION={v}"),
    (".buildkite/pipeline.yml", r"\bruby:" + VERSION + r"-slim\b", "ruby:{v}-slim"),
    ("Gemfile", r"""^ruby (["'])""" + VERSION + r"\1", r"ruby \g<1>{v}\g<1>"),
]
NODE_FILES = [
    (".node-version", r"^v?" + VERSION + "$", "{v}"),
    (".nvmrc", r"^v?\d+(\.\d+\.\d+)?$", "{major}"),
    (".tool-versions", r"^nodejs " + VERSION + "$", "nodejs {v}"),
    ("Dockerfile", r"^ARG NODE_VERSION=" + VERSION + "$", "ARG NODE_VERSION={v}"),
    ("Dockerfile.ci", r"^ARG NODE_VERSION=" + VERSION + "$", "ARG NODE_VERSION={v}"),
]

RUNTIMES = {
    # series(): the part of the version that must match for an auto-mergeable bump
    "ruby": dict(current=ruby_current, releases=ruby_releases, series=lambda v: v[:2],
                 available=lambda v: exists(RUBY_IMAGE.format(v)), files=RUBY_FILES),
    "node": dict(current=node_current, releases=node_releases, series=lambda v: v[:1],
                 available=lambda v: exists(NODE_BUILD_DEF.format(v)), files=NODE_FILES),
}


def main():
    runtime, dry_run = sys.argv[1], "--dry-run" in sys.argv
    rt = RUNTIMES[runtime]
    current = rt["current"]()
    cur = parse(current)
    newer = sorted({parse(v) for v in rt["releases"]() if parse(v) > cur})
    if not newer:
        return

    same_series = [v for v in newer if rt["series"](v) == rt["series"](cur)]
    target = same_series[-1] if same_series else newer[-1]
    kind = "patch" if same_series else "major"
    version = ".".join(map(str, target))

    if not rt["available"](version):
        print(f"{runtime} {version} not installable yet, skipping", file=sys.stderr)
        return

    for path, pattern, template in rt["files"]:
        f = Path(path)
        if not f.exists():
            continue
        repl = template.format(v=version, major=target[0])
        text, n = re.subn(pattern, repl, f.read_text(), flags=re.M)
        if n:
            print(f"{path}: {n} replacement(s)", file=sys.stderr)
            if not dry_run:
                f.write_text(text)

    print(f"from={current}")
    print(f"to={version}")
    print(f"kind={kind}")


if __name__ == "__main__":
    main()
