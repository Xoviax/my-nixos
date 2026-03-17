# Step-by-Step Guide: Customizing Waybar on NixOS with Hyprland (ThinkPad T480)

This guide walks you through finding, understanding, and customizing Waybar when running Hyprland on NixOS, with optional notes for the ThinkPad T480.

---

## 1. Identify Waybar Configuration Location

### Where Waybar looks for config

Waybar reads its configuration from the **XDG config directory**:

- **Default path:** `~/.config/waybar/`
- **Main files:**
  - **`config`** (or `config.json`) — module layout and options (JSON/JSONC).
  - **`style.css`** — appearance (fonts, colors, spacing).

If these files are missing, Waybar falls back to built-in defaults. You can see which config it uses by running Waybar with debug output:

```bash
waybar -l trace
```

Check the log for lines like `Using config: /home/xoviax/.config/waybar/config`.

### NixOS / Home Manager declarative config

When Waybar is managed by Home Manager, the config and style are generated from your NixOS/Home Manager expressions and placed in the Nix store; Home Manager then links them into `~/.config/waybar/`. So:

- **Imperative (manual):** Edit files directly in `~/.config/waybar/`.
- **Declarative (NixOS):** Edit your Nix/Home Manager modules; after `home-manager switch` (or `nixos-rebuild switch`), the files in `~/.config/waybar/` are replaced by the managed versions.

**Tip:** Always back up `~/.config/waybar/` before switching to declarative config or before major edits.

---

## 2. Understand the `config` File

### Format and structure

The `config` file is **JSON** (Waybar also accepts **JSONC** — JSON with `//` comments). Top-level keys define the bar and its layout:

- **`layer`** — `"top"` or `"bottom"`.
- **`height`** — Bar height in pixels.
- **`width`** — Optional width (e.g. for a side bar).
- **`position`** — `"top"` or `"bottom"` (when using `position` in CSS, this can still matter for layout).
- **`modules-left`**, **`modules-center`**, **`modules-right`** — Arrays of module names in order.

Each **module** is configured in a top-level object keyed by the module name (e.g. `"clock"`, `"cpu"`, `"battery"`).

### Example skeleton

```json
{
  "layer": "top",
  "height": 30,
  "position": "top",
  "modules-left": ["hyprland/workspaces", "hyprland/window"],
  "modules-center": ["clock"],
  "modules-right": ["pulseaudio", "network", "battery", "tray"]
}
```

### Common modules (short reference)

| Module             | Purpose                    | Typical options |
|--------------------|----------------------------|------------------|
| `clock`            | Date and time              | `format`, `tooltip-format`, `interval` |
| `cpu`              | CPU usage                  | `format`, `interval` |
| `memory`           | RAM usage                  | `format`, `interval` |
| `network`          | Network (name, speed)      | `format-wifi`, `format-ethernet`, `interval` |
| `battery`          | Battery (level, state)     | `format`, `format-charging`, interval |
| `hyprland/workspaces` | Hyprland workspaces    | `format`, `active-only` |
| `hyprland/window`  | Current window title       | `format`, `max-length` |
| `pulseaudio`       | Volume                     | `format`, `format-muted` |
| `tray`             | System tray icons          | `icon-size`, `spacing` |

### Enabling, disabling, and reordering

- **Enable:** Add the module name to one of `modules-left`, `modules-center`, or `modules-right`.
- **Disable:** Remove it from those arrays.
- **Reorder:** Change the order inside the array (left-to-right or right-to-left depending on the slot).

Example: move clock to the right and add CPU/memory on the left:

```json
{
  "modules-left": ["hyprland/workspaces", "hyprland/window", "cpu", "memory"],
  "modules-center": [],
  "modules-right": ["pulseaudio", "network", "battery", "clock", "tray"]
}
```

### Per-module configuration

Each module is configured by a block under its name. Examples:

**Clock — 12-hour format with AM/PM**

```json
"clock": {
  "format": "{:%I:%M %p}",
  "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
  "interval": 1
}
```

**CPU — custom format and 2s interval**

```json
"cpu": {
  "format": "{usage}%",
  "interval": 2
}
```

**Battery — format and charging string**

```json
"battery": {
  "format": "{capacity}% {icon}",
  "format-charging": "{capacity}% ",
  "format-plugged": "{capacity}% ",
  "interval": 10
}
```

**Result:** The bar shows the requested info; clock updates every second, CPU every 2s, battery every 10s.

---

## 3. Understand the `style.css` File

### Role of `style.css`

`style.css` controls **appearance only**: fonts, colors, background, borders, margins, padding. No module logic goes here.

### Global bar

```css
* {
  font-family: "JetBrainsMono Nerd Font", sans-serif;
  font-size: 14px;
}

window#waybar {
  background-color: rgba(46, 52, 64, 0.95);
  color: #eceff4;
}
```

### Targeting modules

Common selectors:

| Selector              | Targets |
|-----------------------|--------|
| `#waybar`             | The bar window |
| `#clock`               | Clock module |
| `#cpu`                 | CPU module |
| `#battery`             | Battery module |
| `#workspaces`         | Workspaces container (Hyprland: `#hyprland-workspaces`) |
| `.modules-left`       | Left group |
| `.modules-center`     | Center group |
| `.modules-right`      | Right group |

For **Hyprland workspaces**, the active button usually gets a class like `active`; empty workspaces may use `empty`. So you often see:

- `#workspaces button` — all workspace buttons
- `#workspaces button.active` — active workspace
- `#workspaces button.empty` — empty workspace (if your config adds this)

(Exact IDs/classes can depend on Waybar version; check with `waybar -l trace` or the Waybar docs.)

### Example: fonts, colors, spacing

```css
#clock {
  font-weight: bold;
  padding: 0 12px;
  margin: 0 4px;
}

#battery {
  padding: 0 10px;
  margin: 0 4px;
}

.modules-left,
.modules-right {
  margin: 0 6px;
}
```

### Styling different states

**Active workspace**

```css
#workspaces button.active {
  background-color: #4c566a;
  color: #eceff4;
  border-bottom: 3px solid #88c0d0;
}
```

**Low battery**

```css
#battery.low {
  color: #bf616a;
}

#battery.critical {
  color: #bf616a;
  background-color: rgba(191, 97, 106, 0.3);
  animation: blink 1s linear infinite;
}

@keyframes blink {
  50% { opacity: 0.5; }
}
```

**Muted PulseAudio**

```css
#pulseaudio.muted {
  color: #6b7280;
}
```

---

## 4. Hyprland Integration

### What Waybar can show

- **Workspaces:** From the `hyprland/workspaces` module (Hyprland-specific).
- **Window title:** From the `hyprland/window` module.

These use Hyprland’s IPC/socket, so they only work when Waybar runs under Hyprland.

### Required modules in `config`

**Workspaces**

```json
"hyprland/workspaces": {
  "format": "{name}",
  "format-icons": {
    "default": "",
    "active": "",
    "urgent": ""
  },
  "on-click": "activate",
  "sort": 1
}
```

**Window title**

```json
"hyprland/window": {
  "format": "{}",
  "max-length": 50
}
```

### Monitor identification (T480 single internal display)

On a T480 with one built-in screen, the monitor is often `eDP-1`. Your Hyprland config already uses it (e.g. `monitor=eDP-1,...`). Waybar’s Hyprland modules follow Hyprland’s workspace/monitor model; you don’t usually set a monitor in Waybar’s config. If you add an external monitor later, workspaces can be per-monitor; the same Waybar config typically works, with workspaces showing for the active monitor or all (depending on Waybar/Hyprland version).

### Autostart

Your Hyprland config already starts Waybar:

```conf
exec-once = waybar
```

That’s correct. No extra Hyprland settings are required for Waybar beyond having it in `exec-once`.

---

## 5. NixOS Declarative Configuration

### Using Home Manager

With **Home Manager**, you can manage Waybar declaratively so that `config` and `style.css` live in your NixOS repo and are applied on `home-manager switch` (or when NixOS runs the Home Manager activation).

**1. Enable the Waybar program module and point it at your config/style:**

In a Home Manager module (e.g. next to your Hyprland config), add something like:

```nix
# In modules/home/hyprland/waybar.nix or inside modules/home/hyprland/default.nix

{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;  # optional: Waybar as a user service
    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        position = "top";
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{name}";
          "on-click" = "activate";
          sort = 1;
        };
        "hyprland/window" = {
          format = "{}";
          "max-length" = 50;
        };
        clock = {
          format = "{:%I:%M %p}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 1;
        };
        battery = {
          format = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          interval = 10;
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          "format-muted" = "muted";
        };
        network = {
          "format-wifi" = "{essid} ({signalStrength}%)";
          "format-ethernet" = "{ifname}";
          interval = 5;
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 14px;
      }
      window#waybar {
        background-color: rgba(46, 52, 64, 0.95);
        color: #eceff4;
      }
      #workspaces button.active {
        background-color: #4c566a;
        color: #eceff4;
        border-bottom: 3px solid #88c0d0;
      }
      #clock {
        padding: 0 12px;
        margin: 0 4px;
      }
    '';
  };
}
```

**2. Wire the module:**

If you created `waybar.nix`, in `modules/home/hyprland/default.nix` add:

```nix
imports = [ ./waybar.nix ];
```

Or paste the `programs.waybar` block directly into `default.nix`.

**3. Rebuild and apply**

```bash
# If using standalone Home Manager
home-manager switch --flake /path/to/your/nixos-config#xoviax

# If Home Manager is used from NixOS (your setup)
sudo nixos-rebuild switch --flake /path/to/your/nixos-config#zafkiel
```

**4. Restart Waybar** (see section 7) so the new config is picked up.

### File placement

- With `programs.waybar.enable = true` and `settings`/`style`, Home Manager generates the JSON config and CSS and symlinks them into `~/.config/waybar/`. You do **not** need to copy files into the Nix store by hand.
- To keep large CSS or config readable, you can move the style into a separate file and use `lib.readFile` in Nix, e.g. `style = builtins.readFile ./waybar-style.css;`.

---

## 6. ThinkPad T480 Specifics

### Dual battery

The T480 has two batteries (internal + external). Linux often exposes them as `BAT0` and `BAT1`. Waybar’s `battery` module by default shows a single aggregate or the first battery, depending on the implementation.

- To show **all** batteries or a **combined** view, check Waybar’s `battery` module options for your version (e.g. `bat` to select a battery or “all”).
- Example (if your Waybar supports it):

```json
"battery": {
  "bat": "BAT0",
  "format": "{capacity}% {icon}"
}
```

You can try `"bat": "BAT"` or consult the docs for “multiple batteries” or “bat” to get combined/dual display.

### Hardware quirks

- **Backlight:** Your setup uses `brightnessctl`; Waybar doesn’t need to drive brightness unless you add a custom module/script that calls `brightnessctl`. No T480-specific Waybar change required.
- **Power:** TLP and charge thresholds are already in your NixOS config; Waybar only displays battery state/capacity, so no extra NixOS changes for Waybar.

---

## 7. Reloading Waybar

After changing `config` or `style.css`, Waybar must be restarted to pick up changes.

### Kill and let Hyprland restart it (recommended)

If Waybar was started with `exec-once = waybar`, you can kill it; Hyprland will **not** auto-restart it. So you need to start it again yourself:

```bash
pkill waybar
waybar &
```

Or start it in the background and detach:

```bash
pkill waybar; nohup waybar > /tmp/waybar.log 2>&1 &
```

### Using your launch script

Your Hyprland config binds a key to:

```conf
bind = $mainMod, R, exec, ~/.config/waybar/scripts/launch.sh
```

If `launch.sh` restarts Waybar (e.g. `pkill waybar; waybar &`), press **Super+R** (or your `$mainMod`+R) to reload Waybar after editing config or style.

### After NixOS/Home Manager changes

1. Rebuild: `sudo nixos-rebuild switch --flake .#zafkiel` (or `home-manager switch` if standalone).
2. Then restart Waybar (e.g. `pkill waybar; waybar &` or Super+R).

Waybar does not hot-reload config or CSS; a process restart is always required.

---

## Quick reference

| Goal                     | Where / What |
|--------------------------|--------------|
| Config file location     | `~/.config/waybar/config` (or declarative via Home Manager) |
| Style file               | `~/.config/waybar/style.css` |
| 12-hour clock            | In `config`: `"format": "{:%I:%M %p}"` for the `clock` module |
| Active workspace style   | In `style.css`: `#workspaces button.active { ... }` |
| Hyprland workspaces      | Module `hyprland/workspaces` in `config` |
| Hyprland window title    | Module `hyprland/window` in `config` |
| Declarative (NixOS)      | `programs.waybar` in Home Manager with `settings` and `style` |
| Reload after edit        | `pkill waybar; waybar &` or your `launch.sh` (e.g. Super+R) |

For a full list of modules and options, see the [Waybar wiki](https://github.com/Alexays/Waybar/wiki/Configuration) and [Module list](https://github.com/Alexays/Waybar/wiki/Module:-Workspaces).
