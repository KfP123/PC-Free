# Using PC-Free from an iPhone

Creating a Codespace from this repo starts **EXE Runner**: a simple desktop in your browser where you
upload Windows `.exe` files and double-tap them to run (using Wine, no full Windows install).
You don't type any commands.

## One-time setup

1. In Safari, go to **github.com/settings/codespaces** and set **Default idle timeout** to the maximum
   (240 minutes). Otherwise the Codespace may shut down while you're using it.
2. Open this repository on GitHub, tap **Code → Codespaces → Create codespace on main**.
   (If you don't see the Codespaces tab, tap **aA → Request Desktop Website** first.)
   It uses the standard 2-core machine. Free accounts get about 60 hours a month of that.

## Every time you want to run a program

1. Go to **github.com/codespaces** and open your codespace.
2. Wait for it to start. The **first time** it builds EXE Runner, which takes about 5 minutes. After
   that it starts in about a minute.
3. Open the **Ports** tab and tap the globe icon next to **EXE Runner (3000)**.
   The address looks like `https://<codespace-name>-3000.app.github.dev`.
4. First time only: in Safari tap **Share → Add to Home Screen**. The address stays the same for this
   codespace.
5. When you're done, go to **github.com/codespaces → ⋯ → Stop codespace** so you don't use up your free hours.

## Using EXE Runner

- **Turn your phone sideways.** Windows programs expect a wide screen.
- **Upload a program:** open the side panel (the handle on the left edge) → **Files** → **Upload**.
  Uploaded files appear on drive **D:** in the file window. Double-tap an `.exe` to run it.
- **Keyboard:** tap the keyboard button at the bottom right.
- **Menu:** right-click the empty background (two-finger tap, or long-press) for **My files**,
  **Wine settings**, **Install Visual C++ runtime** (many programs need it, so run it if a program won't
  start), and **Terminal**.
- **Your uploads and installed programs are kept** when the Codespace stops. They're stored in
  `exe-runner/data` inside the Codespace.

## Notes

- Keep port 3000 **private** (the default). Only your GitHub account can open it. Making it public
  would let anyone with the link use it.
- A codespace that hasn't been used for 30 days is deleted automatically, along with your uploads.
  Create a new one and add the new address to your Home Screen again.
- Want an always-on version instead? See [exe-runner/README.md](./exe-runner/README.md) for running
  EXE Runner on your own server.

## Full Windows 10 desktop (older option)

The repo also has a setup that runs a complete Windows 10 virtual machine. It's slower: Windows
reinstalls every time the Codespace starts (10–15 minutes), and it needs the 4-core machine. To use it,
tap **Code → Codespaces → ⋯ → New with options**, choose **PC-Free: full Windows 10 desktop** under
*Dev container configuration*, then open port **8006** once Windows has installed.
