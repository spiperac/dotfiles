# Dotfiles

Personal configuration files and the Ansible provisioning for my Fedora Workstation (GNOME) setup.

![screenshot](./screenshot.png)

## Layout

```
ansible/            provisioning (site.yml + roles)
config/             stow package
scripts/            helper scripts
```

## Installation

```bash
git clone https://github.com/spiperac/dotfiles.git
cd dotfiles
./setup.sh
```

Log out and back in afterwards for the zsh login shell and the `libvirt`/`wireshark` group membership.

## Roles

| Role | Contents |
| --- | --- |
| `repos` | RPM Fusion, Terra (pinned), Kubernetes, Flathub |
| `base` | toolchain, CLI utilities, zsh, tmux, neovim, ghostty, foot |
| `gnome` | GNOME packages, fonts, dconf settings |
| `apps` | mpv, gimp, zathura, discord, bitwarden, obsidian |
| `development` | python, go, node, rust, clang, emacs, zed, dbeaver |
| `devops` | podman, kubectl, helm, opentofu, trivy, checkov, doctl |
| `security` | openvpn, wireshark |
| `pentest` | nmap, ffuf, gobuster, hashcat, john, ghidra, burp, seclists, exploitdb, ligolo-ng |
| `virtualization` | libvirt/KVM, virt-manager, virtiofs, SPICE folder sharing |

Run a single role:

```bash
cd ansible && ansible-playbook site.yml -K --tags pentest
```

## Notes

- Fedora only. The playbook refuses to run elsewhere.
- Existing dotfiles in `$HOME` are moved to `*.pre-stow` before stowing.
- `wsl-setup.yml` and `freebsd-setup.yml` are unrelated legacy playbooks.
