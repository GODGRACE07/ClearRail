# ClearRail

**Transparent, real-time USDT payroll on Tempo — built for the corridors where the biggest payroll platforms still can't pay people the way they need to be paid.**

## The Problem

None of the three largest global payroll platforms — Deel, Remote, and Rippling — natively support USDT payouts. Only one funded competitor, Rise, does. That's a structural gap, because USDT is the dominant, trusted stablecoin in exactly the corridors where cross-border payroll pain is worst: Nigeria, Argentina, Venezuela, and parts of Southeast Asia.

Workers in these regions lose real money and time to the gap:

- The average cost of sending $200 internationally is still 6.49% — virtually unchanged in five years (World Bank).
- A Lagos-based contractor earning $3,000/month loses roughly $195/month to fees and spreads.
- 93% of freelancers surveyed across the US, Brazil, Argentina, Mexico, and UAE want at least part of their income in stablecoins (Zero Hash/Lightspark, 2024); 75% want payment within 24 hours.

Even the one platform built for this — Rise — has a well-documented gap of its own: users report payouts stuck in limbo with slow, unresponsive support and no visibility into what's happening to their money.

## The Solution

ClearRail is a stablecoin payroll rail built on **Tempo** — a payments-first Layer 1 blockchain incubated by Stripe and Paradigm — that lets agencies pay contractors in USDT-class stablecoins, with **real-time, on-chain payout status** so no one has to wait on customer support to know where their money is.

- **Add workers** to a payroll list with their wallet and payout amount.
- **Pay individually or in batch** — one contractor or the whole team in a single transaction.
- **Every status change is an on-chain event** — Pending → Sent — visible to anyone, instantly, with no support ticket required.

This directly answers Rise's most-cited weakness: uncertainty during "money in limbo." Tempo's sub-second finality also means there's barely a limbo window to begin with.

## Why Tempo

Tempo is purpose-built for exactly this use case: stablecoin-native fees (no volatile gas token), sub-second finality, and a payments-first design aimed at global payouts, payroll, and remittances. Building a transparent USDT payroll rail here isn't a stretch to justify — it's a direct fit.

## Who It's For

- **Buyer**: agencies, freelance platforms, and BPOs paying distributed contractors in USDT-preferring corridors.
- **End user**: the individual contractor who receives the payout and can check its status themselves, in real time.

## How It Works

Agency deposits USDT -> adds workers -> triggers payout (single or batch)
|
Each payout emits on-chain events: PayoutStatusChanged, PayoutSent
|
Anyone can verify payout status directly on-chain -- no support ticket needed


## Tech Stack

- **Solidity** smart contract (`Payroll.sol`), built with **Foundry**
- Deployed on **Tempo Testnet (Moderato)**
- Uses Tempo's native **TIP-20** stablecoin standard (tested with pathUSD)
- Fully tested with a mock TIP-20 token (`test/Payroll.t.sol`) — 5/5 tests passing

## Contract

Deployed and verified on Tempo Testnet:

0xb9AdBE24f82F97079C681d38Fa76f605170BB568

[View on Tempo Explorer](https://explore.moderato.tempo.xyz/address/0xb9AdBE24f82F97079C681d38Fa76f605170BB568)

## Status

This is an early-stage hackathon build for Colosseum's Crypto World's Fair (Tempo track). Core payroll mechanics -- single payout, batch payout, and transparent status tracking -- are built, tested, and live on testnet. Next steps: frontend dashboard, off-ramp guidance for target corridors, and real-world validation with agencies and contractors in USDT-dominant regions.

## Running Locally

```bash
git clone https://github.com/GODGRACE07/ClearRail.git
cd ClearRail
forge build
forge test
```

## License

MIT
