# CDC Methods — Clock Domain Crossing Synchronization Techniques

> A structured series documenting CDC synchronization techniques with real-world analogies, synthesizable SystemVerilog, SVA assertions, and SDC constraints — written as part of my RTL design learning journey.

---

## What is CDC and why does it matter?

In any real chip, multiple clocks run at different frequencies. When a signal travels from one clock domain to another without proper handling, it can arrive at an unpredictable time — causing the receiving flip-flop to enter **metastability**: an undefined state that is neither logic 0 nor logic 1.

This is not a simulation artifact. It is a **silicon failure**.

CDC synchronization is the set of techniques used to safely transfer signals across these boundaries. Getting it wrong leads to functional failures that are nearly impossible to debug post-silicon.

---

## Series Overview

Each technique covered here includes:
- A real-world analogy to build intuition fast
- Synthesizable SystemVerilog implementation
- Simulation waveforms and testbench
- SVA assertions for formal verification
- SDC constraints for timing closure
- When to use it vs. alternatives

---

## Techniques Covered

### 1. 2-FF Synchronizer
> *Like a relay runner who catches the baton only after it is fully handed over — never mid-air.*

The simplest and most widely used CDC primitive. Two back-to-back flip-flops clocked by the destination domain give metastability time to resolve before the signal is used. Works for **single-bit, slowly changing signals**.

- **Use when:** Control signals, enable lines, single-bit flags
- **Key risk:** Does not work for buses or fast-toggling signals
- **MTBF:** Improves exponentially with each added stage

---

### 2. 3-FF Synchronizer
> *The relay runner asks a teammate to double-check before passing the baton to the anchor leg.*

An extension of the 2-FF synchronizer with one extra stage for higher-frequency designs or stricter MTBF requirements. Common in high-speed SerDes and DDR interfaces.

- **Use when:** Destination clock > 500 MHz or metastability budget is tight
- **Key risk:** Adds one extra clock cycle of latency

---

### 3. Pulse Synchronizer
> *A camera flash — fast, brief, and must be "seen" by the other domain before it fades.*

Transfers a single-cycle pulse across clock domains. Since the pulse may be shorter than the destination clock period, it cannot be directly synchronized — it must first be stretched or converted to an edge.

- **Use when:** One-shot events, interrupt signals, single-cycle triggers
- **Key risk:** Pulse width must exceed destination clock period at the receiver

---

### 4. Toggle Synchronizer
> *Raising a flag instead of shouting — the signal holds its state until the other side notices.*

The source toggles a signal on each event. The destination synchronizes the toggle and detects the edge. Avoids the pulse-width problem entirely because the toggled signal is static between events.

- **Use when:** Periodic events, counters crossing domains, handshake-free single-bit transfers
- **Key risk:** Only one event in-flight at a time; back-to-back pulses must be spaced apart

---

### 5. Handshake Synchronizer
> *Two diplomats who only speak after confirming the other is listening — req, ack, done.*

A full request-acknowledge protocol. The source asserts `req`, waits for `ack` from the destination before de-asserting, then waits for `ack` to go low before the next transfer. Guaranteed delivery with zero data loss.

- **Use when:** Low-frequency control transfers, when missing a transaction is unacceptable
- **Key risk:** High latency (4+ clock cycles per transfer); not suitable for high-throughput data

---

### 6. MUX Synchronizer
> *A traffic cop who freezes all lanes before letting a new car through — no mid-switch collisions.*

Used to safely switch between multiple clock domains or data sources. The select signal is synchronized before the MUX switches, ensuring glitch-free output.

- **Use when:** Clock switching circuits, multi-source data selection
- **Key risk:** Output must be stable during the switching window; requires careful timing analysis

---


### 7. Dual-Clock FIFO with Gray-Code Pointers *(already documented separately)*
> *A post office that only delivers one letter at a time — with labels so neither clerk misreads the count.*

The standard solution for high-throughput multi-bit data transfer between clock domains. Read and write pointers are Gray-coded before crossing to ensure only one bit changes per cycle, eliminating multi-bit metastability. Full/empty flags are derived from synchronized pointer comparisons.

- **Use when:** Streaming data, AXI interfaces, high-bandwidth CDC paths
- **Repo:** [https://github.com/RAJ-07-RAJ/FIFO_ASYNC)

---

## Technique Comparison at a Glance

| Technique | Signal Type | Latency | Throughput | Safe for Buses? |
|---|---|---|---|---|
| 2-FF Synchronizer | Single-bit, slow | 2 cycles | High | No |
| 3-FF Synchronizer | Single-bit, fast clocks | 3 cycles | High | No |
| Pulse Synchronizer | Single-cycle pulse | 2–3 cycles | Medium | No |
| Toggle Synchronizer | Single-bit event | 2–3 cycles | Low | No |
| Handshake Synchronizer | Single-bit control | 4+ cycles | Very Low | No |
| MUX Synchronizer | Clock select / mux sel | 2–3 cycles | N/A | No |
| Dual-Clock FIFO | Multi-bit, streaming | Variable | Very High | Yes |

---

## Tools & Environment

| Tool | Purpose |
|---|---|
| Vivado 2023.x | Synthesis and implementation (Artix-7 target) |
| ModelSim / QuestaSim | RTL simulation and waveform analysis |
| GTKWave | Waveform viewing |
| Questa Formal | SVA formal verification |

---
