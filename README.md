# Night Owl

A tiny browser-only proof of concept for a Mac desktop companion: at 10pm, a soft round owl climbs onto the Dock, slumps into the best seat in the house, and breathes so slowly it makes the whole desktop feel ready for bed. It is deliberately just a visual moment—no accounts, settings, or backend.

## Run it

```sh
npm install
npm run dev
```

Open the local URL Vite prints. The scene starts in deep sleep when the local time is 10pm or later; otherwise, use the **It's 10pm** control to demonstrate it instantly.

## Run it as a native macOS app

```sh
npm run mac:run
```

This builds and opens a native **Night Owl.app**. Its Dock tile is an AppKit canvas, redrawn at 20fps with a visibly breathing owl and rising, fading Zs—rather than swapping static images. A native Control Center opens with the app: use it to toggle the live Dock owl between wide-eyed daytime and sleepy nighttime, or translate a Japanese/English line with Shisa. The app stays alive in the Dock until it is quit. If an earlier copy is already running, quit it first so macOS launches the freshly built app.

## Shisa translation

The small Shisa panel translates one Japanese line into English. Add `SHISA_API_KEY=...` to a local `.env` file (copy `.env.example`); it is handled only by `/api/translate`, never sent to browser JavaScript. Restart `npm run dev` after adding it.
