# Chennai Doomsday IMAX setup

This configuration monitors BookMyShow for Avengers: Doomsday at PVR Palazzo,
The Nexus Vijaya Mall, Chennai, on the target release date of 17 December 2026.
It filters for IMAX and checks every five minutes.

## Requirements

- Windows 10/11
- Node.js 22 or newer
- The ntfy app on your phone

## Setup

1. Copy `.env.chennai.example` to `.env`:
   ```powershell
   Copy-Item .env.chennai.example .env
   ```
2. Open `.env` and replace `NTFY_TOPIC` with a long, random, private topic name.
3. Install ntfy on your phone and subscribe to that exact topic. Keep the topic private.
4. In this repository folder, run:
   ```powershell
   npm install
   npm run check
   ```
5. If the check completes, start continuous monitoring:
   ```powershell
   npm start
   ```
6. Keep the PC awake and the terminal open. Stop monitoring with Ctrl+C.

The local status page is http://localhost:4733/ and the health endpoint is
http://localhost:4733/healthz.

## Important notes

- The first check may report no showtimes because bookings are not yet published.
- An HTTP 403 or provider/network error is not proof that bookings are closed.
- District is not enabled because the exact Doomsday movie content ID has not
  been verified. The District cinema page identifier beginning with CD is not
  the movie content ID.
- The monitor checks publicly available showtimes only. It does not buy tickets,
  hold seats, or bypass booking queues.
- A residential home connection is preferable; cinema providers may block
  requests from cloud/datacenter IPs.
- The PC must remain on and connected for monitoring to continue.
