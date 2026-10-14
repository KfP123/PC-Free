# Using PC-Free from an iPhone

This repo includes a Codespaces setup (`.devcontainer/`) that installs and starts Windows 10 by itself.
You don't type any commands.

## One-time setup

1. In Safari, go to **github.com/settings/codespaces** and set **Default idle timeout** to the maximum (240 minutes).
   Otherwise the Codespace may shut down while you are using Windows.
2. Open this repository on GitHub, tap **Code → Codespaces → Create codespace on main**.
   (If you don't see the Codespaces tab, tap **aA → Request Desktop Website** first.)
   It uses a 4-core machine. Free accounts get about 30 hours a month of that.

## Every time you want Windows

1. Go to **github.com/codespaces** and open your codespace (or create one as above).
2. Wait **10–15 minutes**. Windows is installed fresh each time the Codespace starts.
3. Open the **Ports** tab and tap the globe icon next to **Windows desktop (8006)**.
   The address looks like `https://<codespace-name>-8006.app.github.dev`.
4. First time only: in Safari tap **Share → Add to Home Screen**. The address stays the same for this codespace.
5. When you're done, go to **github.com/codespaces → ⋯ → Stop codespace** so you don't use up your free hours.

## Keeping your files

Windows is wiped every time the Codespace stops, **except the `Shared` folder** (also drive `Z:`).
Put your `.exe` files and anything you want to keep there.

- To put a file there from your iPhone: in the Codespace editor, long-press the `shared` folder → **Upload…**
- Or download it inside Windows with Edge and save it to `Shared`.

## Notes

- Default Windows login: user `Docker`, password `admin`. To change it, add Codespaces secrets named
  `WINDOWS_USERNAME` and `WINDOWS_PASSWORD` at github.com/settings/codespaces.
- Keep port 8006 **private** (the default). Making it public would let anyone with the link control your Windows.
- A codespace that hasn't been used for 30 days is deleted automatically. Just create a new one; you'll need to
  add the new address to your Home Screen again. Files in `shared/` are deleted with it.
