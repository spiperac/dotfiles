#!/usr/bin/env python3
"""Check that every Gentoo atom referenced by the dotfiles exists in the emerge tree.

Scans ansible/roles/*/vars/gentoo.yaml for every key that ends in
"_packages", plus the atoms mentioned in roles/system/files/package.use/*,
and checks each one against the ebuilds present in every synced repository
(/var/db/repos/*). Overlay packages (e.g. GURU) count as found as long as
the overlay is synced. Exits 1 if any atom is missing (a likely typo).
"""
from __future__ import annotations

import sys
from pathlib import Path

REPO_DIR = Path(__file__).resolve().parents[1]
VARS_DIR = REPO_DIR / "ansible" / "roles"
PACKAGE_USE_DIR = VARS_DIR / "system" / "files" / "package.use"
EBUILD_TREE = Path("/var/db/repos")


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


def find_in_tree(atom: str) -> str | None:
    category, sep, package = atom.partition("/")
    if not sep:
        return None
    for repo in sorted(EBUILD_TREE.iterdir()):
        if not repo.is_dir():
            continue
        pkg_dir = repo / category / package
        if pkg_dir.is_dir() and any(pkg_dir.glob("*.ebuild")):
            return repo.name
    return None


def main() -> int:
    if not EBUILD_TREE.exists():
        print(f"Ebuild tree not found ({EBUILD_TREE}).", file=sys.stderr)
        return 2

    atoms = atoms_from_vars() | atoms_from_package_use()
    if not atoms:
        print("No atoms found to check.")
        return 0

    missing = {
        atom: find_in_tree(atom)
        for atom in atoms
    }

    for atom in sorted(missing):
        location = missing[atom]
        print(f"{location + ':':<10}  {atom}" if location else f"missing       {atom}")

    missing_atoms = {atom for atom, loc in missing.items() if loc is None}
    if missing_atoms:
        print(f"\n{len(missing_atoms)} of {len(atoms)} atoms were not found in any synced repository.")
        print("If any are GURU packages, run 'emaint sync -r guru' and re-run verify.")
        return 1
    print(f"\nAll {len(atoms)} atoms were found.")
    return 0


if __name__ == "__main__":
    sys.exit(main())