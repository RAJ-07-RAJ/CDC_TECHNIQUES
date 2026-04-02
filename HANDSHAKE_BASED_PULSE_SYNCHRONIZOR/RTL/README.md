
# Handshake Based Pulse Synchronizer

## 1. Problem Statement

When a **pulse signal generated in one clock domain** crosses to another clock domain, a simple **2-flip-flop synchronizer may miss the pulse** if the pulse width is smaller than the destination clock period.

This creates a **loss of events**, which is unacceptable in reliable digital systems.

To guarantee that **every pulse is captured**, a **handshake-based pulse synchronizer** is used.

---

# 2. Basic Idea

The source domain **holds the request signal until the destination acknowledges it**.

This ensures that the pulse remains active long enough for the destination clock domain to capture it.

The communication occurs using a **request–acknowledge handshake protocol**.

---

# 3. Architecture Overview

The architecture consists of two clock domains:

### Source Clock Domain (CLK A)

Components:

* Input pulse logic
* MUX logic
* Flip-flops FA1, FA2, FA3

Responsibilities:

* Capture the input pulse
* Hold the request until acknowledgement arrives
* Prevent new pulses during busy condition

---

### Destination Clock Domain (CLK B)

Components:

* Synchronization flip-flops FB1, FB2, FB3
* Output logic

Responsibilities:

* Safely synchronize the request signal
* Generate a clean pulse in the destination domain
* Send acknowledgment back to source domain

---

# 4. Signal Flow

### Step 1 — Pulse Generation

A pulse **SINPUT** is generated in the source domain.

The MUX logic forwards the pulse to flip-flop **FA1** when the system is not busy.

---

### Step 2 — Request Latching

Flip-flop **FA1** latches the request signal.

This signal represents a **pending event to be transferred** to the destination domain.

---

### Step 3 — Crossing the Clock Domain

The request signal passes through a chain of synchronizing flip-flops:

```
FA1 → FB1 → FB2 → FB3
```

These flip-flops are clocked by **CLK B**.

This multi-stage synchronization reduces **metastability probability**.

---

### Step 4 — Pulse Generation

At the destination domain, **edge detection logic** generates the synchronized output pulse.

This produces:

```
SYNC_OUT
```

which is a clean single-cycle pulse in the **CLK B domain**.

---

### Step 5 — Acknowledge Feedback

The synchronized signal is sent back to the source domain through:

```
FB3 → FA2 → FA3
```

This forms the **acknowledgment path**.

---

### Step 6 — Busy Signal Generation

The **BUSY** signal is generated in the source domain using feedback logic.

BUSY indicates that a pulse transfer is currently in progress.

While BUSY is high:

* new input pulses are blocked
* the system waits for acknowledgment

---

# 5. Why BUSY is Required

Without BUSY:

* Multiple pulses could be generated before the previous transfer finishes.
* This would cause **pulse overlap and data loss**.

BUSY ensures:

```
one pulse transfer at a time
```

which guarantees **reliable communication**.

---

# 6. Key Advantages

✔ Guarantees **no pulse loss**

✔ Safe **clock domain crossing**

✔ Handles **very short pulses**

✔ Works with **asynchronous clocks**

---

# 7. Limitations

✖ Higher latency compared to simple synchronizers

✖ Only one transfer allowed at a time

✖ Not suitable for high-throughput data transfer

---

# 8. Typical Use Cases

Handshake based pulse synchronizers are used in:

* interrupt signals
* control events
* command triggers
* status updates between clock domains

---

# 9. Key Design Rule

The source domain must **not generate a new pulse while BUSY is high**.

This ensures the handshake protocol remains valid.

