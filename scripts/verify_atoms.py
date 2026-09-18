#!/usr/bin/env python3
"""Check that every Gentoo atom referenced by the dotfiles exists in the emerge tree.

Scans ansible/roles/*/vars/gentoo.yaml for every key that ends in
"_packages", plus the atoms mentioned in roles/system/files/package.use/*,
and checks each one against the Portage package database. Exits 1 if any
atom is missing (a likely typo).
"""
from __future__ import annotations

import sys
from pathlib import Path

REPO_DIR = Path(__file__).resolve().parents[1]
VARS_DIR = REPO_DIR / "ansible" / "roles"
PACKAGE_USE_DIR = VARS_DIR / "system" / "files" / "package.use"


def atoms_from_vars() -> set[str]:
    import yaml

    atoms: set[str] = set()
    for path in sorted(VARS_DIR.glob("*/vars/gentoo.yaml")):
        data = yaml.safe_load(path.read_text()) or {}
        for key, value in data.items():
            if key.endswith("_packages") and isinstance(value, list):
                atoms.update(atom for atom in value if isinstance(atom, str) and atom)
    return atoms


def atoms_from_package_use() -> set[str]:
    atoms: set[str] = set()
    if not PACKAGE_USE_DIR.is_dir():
        return atoms
    for path in sorted(PACKAGE_USE_DIR.glob("*")):
        if not path.is_file():
            continue
        for line in path.read_text().splitlines():
            line = line.split("#", 1)[0].strip()
            if not line:
                continue
            atoms.add(line.split()[0])
    return atoms


def check_with_portage(atoms: set[str]) -> set[str]:
    import portage

    dbapi = portage.db[portage.root]["porttree"].dbapi
    return {atom for atom in atoms if not dbapi.match(atom)}


def check_with_eix(atoms: set[str]) -> set[str]:
    import subprocess

    missing: set[str] = set()
    for atom in sorted(atoms):
        result = subprocess.run(
            ["eix", "-q", atom],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0 or not result.stdout.strip():
            missing.add(atom)
    return missing


def main() -> int:
    atoms = atoms_from_vars() | atoms_from_package_use()
    if not atoms:
        print("No atoms found to check.")
        return 0

    try:
        missing = check_with_portage(atoms)
    except ImportError:
        try:
            missing = check_with_eix(atoms)
        except FileNotFoundError:
            print("Neither the Portage Python module nor eix is available.", file=sys.stderr)
            return 2

    for atom in sorted(atoms):
        print(f"{'missing' if atom in missing else 'ok     '}  {atom}")

    if missing:
        print(f"\n{len(missing)} of {len(atoms)} atoms were not found in the emerge tree.")
        return 1
    print(f"\nAll {len(atoms)} atoms were found.")
    return 0


if __name__ == "__main__":
    sys.exit(main())