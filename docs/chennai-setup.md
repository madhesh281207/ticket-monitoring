# Chennai Doomsday IMAX setup

This configuration monitors BookMyShow for Avengers: Doomsday at PVR Palazzo,
The Nexus Vijaya Mall, Chennai, on the target release date of 17 December 2026.
It filters for IMAX and checks every five minutes.

## Requirements

- Windows 10/11
- Node.js 22 or newer
- The ntfy app on your phone

## Setup (one-command Windows launch)

1. Install Node.js 22 or newer from https://nodejs.org/.
2. Install the ntfy app on your phone.
3. Open PowerShell in the repository folder and run:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\\scripts\\start-chennai-monitor.ps1
   ```
4. The script creates `.env` with a randomly generated private ntfy topic if needed, displays the topic, and pauses so you can subscribe to it in the ntfy app. It then installs dependencies, runs one check, and starts continuous monitoring.
5. Keep the PC awake and the terminal open. Stop monitoring with Ctrl+C.

The script never overwrites an existing `.env`. The topic is stored locally in `.env`, which is excluded by `.gitignore`. Keep the topic private.

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
