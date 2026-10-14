# EXE Runner: run Windows .exe files from your iPhone

EXE Runner is a small always-on server that runs Windows programs with Wine (the same idea as
Winlator). You open it in Safari, upload an `.exe`, and double-tap it. It runs both 64-bit and
older 32-bit programs, keeps your files and installed programs, and has no monthly hour limit.

It's made for **Oracle Cloud's free tier**, which includes a server with 4 ARM processor cores and
24 GB of RAM at no cost. On that ARM server, Windows programs run through
[Hangover](https://github.com/AndreRH/hangover), which translates x86 code with FEX and Box64.

Everything below can be done from an iPhone in Safari.

## 1. Create an Oracle Cloud account

1. Go to **oracle.com/cloud/free** and tap **Start for free**.
2. Pick your **Home Region** carefully. Choose one close to you, because it can't be changed later.
3. Oracle asks for a credit card to verify your identity. Free-tier resources aren't charged.

## 2. Create the server

In the Oracle Cloud console, tap **☰ → Compute → Instances → Create instance**.

1. **Name:** `exe-runner`
2. **Image and shape:**
   - **Change image** → **Ubuntu** → **Canonical Ubuntu 24.04** (not the "Minimal" one).
   - **Change shape** → **Ampere** → **VM.Standard.A1.Flex**, then set **4 OCPUs** and **24 GB memory**.
3. **Networking:** keep the defaults, and make sure **Assign a public IPv4 address** is on.
4. **SSH keys:** choose **Generate a key pair for me** and save the private key to Files. You
   won't need it normally, but keep it just in case.
5. Tap **Show advanced options → Management → Initialization script → Paste cloud-init script**
   and paste this, replacing the password with your own (letters and numbers are safest):

   ```bash
   #!/bin/bash
   export EXE_RUNNER_PASSWORD='choose-a-long-password'
   curl -fsSL https://raw.githubusercontent.com/KfP123/PC-Free/main/exe-runner/install.sh | bash
   ```

6. Tap **Create**.

If Oracle says **"Out of capacity"**, its free ARM servers are all taken right now in that area.
Try a different **Availability Domain** in the Placement section, or try again later. This is common
and usually clears up within a day.

## 3. Open the web ports

The server needs to accept web traffic.

1. On your instance's page, find **Primary VNIC** and tap the **Subnet** link.
2. Open **Security** (or **Security Lists**) → **Default Security List** → **Add Ingress Rules**.
3. Fill in:
   - **Source CIDR:** `0.0.0.0/0`
   - **IP Protocol:** TCP
   - **Destination Port Range:** `80,443`
4. Tap **Add Ingress Rules**.

## 4. Open EXE Runner

1. Wait about **15 minutes** after creating the server. It installs and builds everything by itself.
2. On the instance page, copy the **Public IP address**, for example `129.146.10.20`.
3. In Safari, open your address with the dots changed to dashes:
   **`https://129-146-10-20.sslip.io`**
4. Log in with user **`me`** and the password you chose.
5. Tap **Share → Add to Home Screen** to get an app icon.

If the page doesn't load yet, wait a few more minutes. The first start builds everything.

## Using it

- **Turn your phone sideways.** Windows programs expect a wide screen.
- **Upload a program:** open the side panel (the handle on the left edge) → **Files** → **Upload**.
  Uploaded files appear on drive **D:** in the file window, and you double-tap an `.exe` to run it.
- **Keyboard:** tap the keyboard button at the bottom right.
- **Menu:** right-click the empty background (two-finger tap, or long-press) for:
  - **My files**, which reopens the D: window
  - **Wine settings**
  - **Install Visual C++ runtime**, which many programs need. Run it if a program won't start.
  - **Terminal**
- **The first launch** of a program can take a little while, especially on the first run after setup.

## Good to know

- **What runs well:** ordinary programs, installers, tools and older games. **What doesn't:** demanding
  3D games, because the server has no graphics card, and programs with anti-cheat or copy protection.
- **Your files and installed programs are kept** on the server between visits.
- **Oracle may stop free servers that sit idle for a long time.** If EXE Runner stops loading, go to
  **Compute → Instances**, open your instance, and tap **Start**. It comes back up on its own.
- **Updating:** reboot the instance from the Oracle console. At every boot it downloads the latest
  EXE Runner from this repo and rebuilds.
- **Security:** keep a strong password. Anyone with the address and password can use the computer.
