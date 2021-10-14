# machine

My development machine setup.

- AWS CLI
- [cariad/wev](https://github.com/cariad/wev)
- Fira Code
- Google Chrome
- [Obsidian.md](https://obsidian.md)
- pipenv
- pyenv
- Restores SSH keys
- ShellCheck
- Visual Studio Code

## Installation

Install Ubuntu 21.04 desktop, then:

```bash
git clone https://github.com/cariad/machine.git ~/.machine
cd ~/.machine
./install
```

## Secrets

### cariad/machine.secrets

The private repository [cariad/machine.secrets](https://github.com/cariad/machine.secrets) holds my secrets.

- `.ssh/`: SSH keys and config

## Disaster plan

Even though the repository is private, the secrets are all encrypted and I accept the risk of hacks and leaks.

On learning that my secrets have been compromised, my disaster plan is to use the head-start enabled by encryption to revoke them all at:

- [github.com keys](https://github.com/settings/keys)
- [gitlab.com keys](https://gitlab.com/-/profile/keys)

### Initial secret setup

1. Create a Git repository at `~/.machine.secrets`.
1. Create an SSH key pair:

    ```bash
    ssh-keygen -t ed25519 -C "cariad@cariad.earth"
    mkdir                    ~/.machine.secrets/.ssh
    mv ~/.ssh/id_ed25519     ~/.machine.secrets/.ssh
    mv ~/.ssh/id_ed25519.pub ~/.machine.secrets/.ssh
    ```

1. Create `~/.machine.secrets/.ssh/config`:

    ```text
    IdentityFile ~/.ssh/id_ed25519
    ```

1. Make your configuration private:

    ```bash
    chmod 600 ~/.machine.secrets/.ssh/config
    ```

1. Push `~/.machine.secrets` to a safe remote.
1. Share your public key to authenticate:
    - [github.com keys](https://github.com/settings/keys)
    - [gitlab.com keys](https://gitlab.com/-/profile/keys)
