# 📐 MOUSet: Clean-Room Functional Specification & Protocol Architecture

> **Project:** MOUSet (MOUSE + SET)  
> **Classification:** Clean-Room Independent Reimplementation  
> **Purpose:** Universal Interoperability Protocol for Mobile-to-Desktop Remote Input

---

## 1. Executive Summary & Interoperability Rationale

MOUSet is an independent, clean-room software architecture developed strictly for interoperability between mobile web user agents (iOS Safari, Android Chrome) and modern desktop computing platforms (Linux Wayland/X11, macOS Darwin, Windows NT).

This specification serves as the formal functional definition of the communication protocols, state management models, and hardware-interaction abstraction layers employed by MOUSet.

---

## 2. Clean-Room Methodology Statement

To ensure complete legal and copyright compliance under international intellectual property frameworks (including 17 U.S.C. § 1201(f) and Directive 2009/24/EC Article 6):

1. **Independent Creation:** MOUSet was authored completely from scratch as an original implementation based strictly on observable functional requirements and standard open Web APIs.
2. **Zero Contamination:** This repository contains:
   - **No proprietary binary dumps** (`.exe`, `.dll`, `.so`, `.ipa`, `.apk`).
   - **No decompiled source code** or intermediate disassembler databases (`.idb`, `.i64`, `.gpr`).
   - **No copyrighted graphics, icons, fonts, or sound assets** belonging to third-party commercial software.
   - **No anti-circumvention tools, DRM bypasses, or license validation overrides**.
3. **Open Standards Utilization:** The entire system communicates exclusively via open W3C and IETF standards:
   - RFC 6455 (WebSocket Protocol)
   - W3C Touch Events Level 2
   - W3C Web Speech API
   - HTML5 Canvas 2D Context

---

## 3. Protocol Specification

### 3.1 Session Lifecycle & Room Routing
Communication between controllers (Remotes) and workstations (Hosts) is isolated using a 4-digit alphanumeric Room PIN over a persistent bidirectional WebSocket tunnel.

- **Endpoint:** `ws://<host>:<port>/?role=<role>&room=<PIN>`
- **Query Parameters:**
  - `role`: `"host"` (workstation receiving input) or `"remote"` (mobile touch controller).
  - `room`: Uppercase 4-digit token identifying the active pairing channel.

### 3.2 Action Payloads (JSON Schema)

All control messages transmitted across the WebSocket channel use utf-8 encoded JSON objects formatted according to the following actions:

| Action Identifier | Payload Fields | Description |
| :--- | :--- | :--- |
| `MOUSE_MOVE` | `{ action: "MOUSE_MOVE", dx: number, dy: number }` | Relative 2D cursor displacement vectors. |
| `MOUSE_CLICK` | `{ action: "MOUSE_CLICK", button: "left" \| "right" }` | Primary or secondary mouse button actuation. |
| `MOUSE_SCROLL` | `{ action: "MOUSE_SCROLL", dy: number }` | Normalized wheel scroll steps with sub-pixel accumulation. |
| `SLIDE_NEXT` | `{ action: "SLIDE_NEXT" }` | Advance presentation slide (Keyboard Right Arrow). |
| `SLIDE_PREV` | `{ action: "SLIDE_PREV" }` | Previous presentation slide (Keyboard Left Arrow). |
| `SLIDE_START` | `{ action: "SLIDE_START" }` | Launch presentation mode (Key F5). |
| `SLIDE_EXIT` | `{ action: "SLIDE_EXIT" }` | Terminate presentation / exit modal (Key Escape). |
| `TYPE_TEXT` | `{ action: "TYPE_TEXT", text: string }` | Streamed text string for keyboard / voice dictation input. |
| `KEY_BACKSPACE` | `{ action: "KEY_BACKSPACE" }` | Delete preceding character. |
| `KEY_ENTER` | `{ action: "KEY_ENTER" }` | Send carriage return / newline event. |
| `SET_VOLUME` | `{ action: "SET_VOLUME", value: number }` | Set workstation master volume level (0 to 100). |
| `GET_VOLUME` | `{ action: "GET_VOLUME" }` | Query current workstation master volume level. |

---

## 4. Hardware & Operating System Abstraction Layer

MOUSet abstracts operating system differences through isolated, native dispatchers:

```
┌─────────────────────────────────────────────────────────────┐
│                 Mobile Web Remote (PWA)                     │
│  - Radial Dot Matrix Canvas (60 FPS)                        │
│  - Multi-touch Gestures (1-finger move, 2-finger scroll)     │
│  - Web Speech Voice Dictation                               │
└──────────────────────────────┬──────────────────────────────┘
                               │ WebSocket (JSON)
┌──────────────────────────────▼──────────────────────────────┐
│                  MOUSet Dispatcher Server                   │
│                                                             │
│   ┌───────────────────┬───────────────────┬─────────────┐   │
│   │   Linux Dispatch  │  macOS Dispatch   │ Win Dispatch│   │
│   │ - evdev / ydotool │ - AppleScript     │ - nut.js /  │   │
│   │ - wl-copy / wl-clp│ - CoreGraphics    │   Win32 API │   │
│   │ - wpctl / pactl   │ - osascript vol   │ - System vol│   │
│   └───────────────────┴───────────────────┴─────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

1. **Linux (Wayland & X11):**
   - User-space `/dev/uinput` emission via isolated `ydotoold` daemon.
   - Wayland non-blocking clipboard coordination via `wl-copy`.
   - Audio control through PipeWire (`wpctl`) and PulseAudio (`pactl`).
2. **macOS (Darwin):**
   - System Events keystroke and key code synthesis via AppleScript.
   - Master volume interrogation and assignment via `osascript`.
3. **Windows (Win32):**
   - Win32 Virtual-Key API and synthetic mouse event injection.

---

## 5. Repository Cleanliness & Hygiene Verification

To preserve strict clean-room isolation, the project repository is monitored under the following integrity constraints:
- Automatic exclusion of compiled binaries, static libraries, and object files.
- Zero inclusion of decompilation dumps, symbol tables, or reverse-engineering workspace files.
- Bring-Your-Own-Device model: No proprietary operating system components or licenses are bundled or redistributed.
