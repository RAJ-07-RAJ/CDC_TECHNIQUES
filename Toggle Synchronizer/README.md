
# Toggle Synchronizer (Clock Domain Crossing)

## Overview

This repository contains a simple implementation of a **Toggle Synchronizer**, a common technique used in **Clock Domain Crossing (CDC)** to safely transfer pulse events between two asynchronous clock domains.

In digital systems, signals often need to move from one clock domain to another. A simple **2-flip-flop synchronizer** works well for level signals but may **miss short pulses**. The toggle synchronizer solves this by converting a pulse into a **state change (toggle)**, allowing the destination domain to reliably detect the event.

This project demonstrates:

* Source domain toggle generation
* Multi-stage synchronizer in the destination domain
* Edge detection to regenerate the pulse
* Simulation to verify the behavior

---

## Architecture

The design consists of three main parts.

### 1. Source Domain (clkA)

A pulse arriving in the source clock domain toggles a flip-flop.

```
pulse_in ──► toggle flip-flop
              (0→1 or 1→0)
```

Each pulse changes the state of the toggle signal.

---

### 2. Synchronizer Chain (clkB)

The toggle signal crosses the clock boundary through multiple flip-flops.

```
toggle → B1 → B2 → B3
```

These flip-flops reduce metastability risk and safely bring the signal into the destination clock domain.

---

### 3. Edge Detection

The destination detects the change in toggle state.

```
pulse_out = B2 XOR B3
```

This generates a **single-cycle pulse in the destination clock domain**.

---

## File Structure

```
├── toggle_src.v          # Source domain toggle generator
├── toggle_dest.v         # Destination domain synchronizer + edge detector
├── toggle_synchronizer.v # Top module
├── tb_toggle_sync.v      # Testbench
└── README.md
```

---

## Simulation Behavior

Example signal flow:

```
Source Domain (clkA)
pulse_in
   │
   ▼
toggle
   │
   ▼

Destination Domain (clkB)
B1 → B2 → B3
        │
        ▼
     pulse_out
```

Each source pulse results in **one pulse in the destination domain**.

---

## Running the Simulation

Using a typical Verilog simulator (ModelSim, Icarus, etc.):

Example with **Icarus Verilog**:

```
iverilog toggle_src.v toggle_dest.v toggle_synchronizer.v tb_toggle_sync.v
vvp a.out
```

Open the waveform in GTKWave if needed.

---

## Important Notes

### Why not just use a 2-FF synchronizer?

A simple synchronizer may **miss short pulses** when crossing clock domains.

### Toggle Synchronizer Advantage

By converting pulses to **state transitions**, the destination can detect changes even if the pulse width is small.

### Limitation

Toggle synchronizers cannot support **very high event rates**. If events arrive too quickly, transitions may be missed.

For high-throughput CDC transfers, designers typically use:

* Handshake synchronizers
* Asynchronous FIFOs

---

## Learning Objective

This project was created as part of learning **Clock Domain Crossing techniques in RTL design**, including:

* Pulse synchronization challenges
* Toggle-based event transfer
* Multi-stage synchronizers
* CDC simulation analysis

