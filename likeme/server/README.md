# LikeMe API

The Reels API stores its metadata in Prisma/SQLite and video files under
`server/uploads/reels`. The upload directory is deliberately excluded from Git.

## Run locally

1. Copy `.env.example` to `.env`.
2. Install packages with `npm install`.
3. Create the database with `npx prisma migrate dev --name reels`.
4. Create the local demo model with `npm run db:seed`.
5. Start the service with `npm run dev`.

Android emulators use the default API URL, `http://10.0.2.2:3000`. For an iOS
simulator, desktop build, or physical device, provide the address when launching
Flutter, for example:

```text
flutter run --dart-define=REELS_API_URL=http://192.168.1.20:3000
```

The app sends `APP_USER_ID` as a temporary development header. Replace this
with verified session authentication before deployment. For hosted media, replace
the local multer storage in `src/index.js` with an object-storage adapter and
keep only the resulting CDN URL in the `Reel` record.
