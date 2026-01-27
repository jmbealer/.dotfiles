# NixOS Dotfiles

This repository contains my NixOS system configuration, structured as a **modular flake**. This setup separates machine-level configuration, user-level configuration, and reusable modules for better scalability and maintenance.

## 📂 Directory Structure

```text
.
├── flake.nix                # Entry point for the system configuration
├── flake.lock               # Lockfile for reproducible dependencies
├── hosts/                   # Machine-specific configurations
│   └── myhost/              # Configuration for the 'myhost' machine
│       ├── default.nix      # Main system configuration (formerly configuration.nix)
│       └── hardware-configuration.nix
├── homes/                   # User-specific configurations (Home Manager)
│   └── 0xjb/                # Configuration for user '0xjb'
│       └── default.nix      # Main user configuration (formerly home.nix)
├── modules/                 # Reusable configuration blocks
│   └── home-manager/        # User-level modules
│       └── editors/
│           └── nvf.nix      # Neovim (nvf) configuration
└── secrets/                 # Encrypted secrets (SOPS)
    └── secrets.yaml
```

## 🚀 Getting Started

### Prerequisites
*   **NixOS** installed on your machine.
*   **Git** to clone this repository.
*   **Flakes** enabled in your Nix configuration.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ```

2.  **Apply the system configuration:**
    ```bash
    sudo nixos-rebuild switch --flake .#myhost
    ```

## 🛠️ Customization

### Adding a New Host
1.  Create a new directory in `hosts/` (e.g., `hosts/laptop`).
2.  Generate a hardware config: `nixos-generate-config --dir hosts/laptop`.
3.  Create a `default.nix` in that folder importing your hardware config and other modules.
4.  Add the new host entry to `flake.nix` under `nixosConfigurations`.

### Adding a New User
1.  Create a new directory in `homes/` (e.g., `homes/newuser`).
2.  Create a `default.nix` with your Home Manager configuration.
3.  Import this user configuration in the relevant host configuration or `flake.nix`.

### Modifying Modules
*   **System-wide changes:** Edit files in `hosts/myhost/`.
*   **User-specific changes:** Edit files in `homes/0xjb/`.
*   **Component changes:** Edit specific modules in `modules/` (e.g., `nvf.nix`).

## 🔐 Secrets
Secrets are managed using **sops-nix**.
*   **Edit secrets:** `sops secrets/secrets.yaml`
*   **Key location:** Keys are expected at `/home/0xjb/.config/sops/age/keys.txt` or `/etc/ssh/ssh_host_ed25519_key` depending on configuration.
