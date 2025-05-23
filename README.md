# SSH Root Setup Script

This script configures a Linux server to allow secure **root login via SSH using my GitHub public key**.

---

## ⚠️ Warning

**Do not run this script unless you want to give me (`iamjoshgilman`) root access to your system.**  
It will download my public key from GitHub and install it into `/root/.ssh/authorized_keys`.

---

## 🔧 What It Does

- Creates the `/root/.ssh` directory if missing
- Downloads my public SSH key from GitHub
- Sets proper file permissions
- Updates `/etc/ssh/sshd_config` to:
  - Disable password authentication
  - Enable public key authentication
  - Allow root login only via keys
- Restarts the SSH service

