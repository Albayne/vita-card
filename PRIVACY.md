# VitaCard Privacy

VitaCard's core principle: records are owned by the patient, not the facility. This document explains exactly what that means in practice.

## What data is collected

- **Phone number** (optional). Entered once during onboarding, sent only to Firebase Auth to verify a one-time SMS code. VitaCard's own code never writes this number to Hive or Firestore — it exists only inside the Firebase Auth SDK's verification flow. A student can skip phone entry entirely and continue with an anonymous Firebase Auth session instead.
- Nothing else. No name, no student ID, no email is ever requested.

## What data is stored locally (on-device only)

Everything that makes VitaCard useful lives in an encrypted Hive database on the device:

- STI/HIV test logs (tests included, result, date)
- Mood logs (score, stressors, date)
- Quitrr day logs (clean/slip, triggers, craving intensity)
- Health fund goals and wallet selections
- Mental health booking records

Every Hive box holding this data is opened with an AES-256 cipher whose key is generated on first launch and stored exclusively in `flutter_secure_storage`. The key is never transmitted, logged, or backed up. **Mood logs in particular never leave the device under any circumstance** — there is no sync path for them at all. If a student loses their phone, they lose their mood history; this is an accepted tradeoff for guaranteed privacy.

## What data is stored on the server (Firebase)

Firestore holds exactly three kinds of document, and nothing else:

1. **Counsellor slot availability** (`/counsellor_slots/{slotId}`) — date, time, format, and (once booked) the anonymous MH token that booked it. No name, phone number, or student ID.
2. **Peer support posts** (`/peer_posts/{postId}`) — post content and a randomly assigned two-character code. Deliberately disconnected from every other token in the app.
3. **FCM device tokens** (`/device_tokens/{uid}`) — a push-notification token keyed by a random Firebase Auth UID, used only to deliver server-pushed reminders to the device. This UID is not a phone number, name, or student ID — it's a random identifier Firebase Auth generates, including for anonymous sign-ins.

No personal health data — no STI result, no mood entry, no streak, no fund balance — is ever written to Firestore. No analytics or crash-reporting SDK is integrated.

## How anonymous tokens are generated

On first launch, VitaCard generates two tokens:

- **Health Wallet ID** (`ZW·XXXX·X`) — used for STI/HIV logs, fund tracking, and records.
- **Mental Health Token** (`MH·XXXX·X`) — used only for anonymous counselling bookings.

Each token is a SHA-256 hash of a random UUID, a secure-random local seed, and the current timestamp, formatted to 5 characters. None of the source values (the UUID, the seed, the timestamp) are ever stored — only the final formatted token is kept, in `flutter_secure_storage`. The token is never transmitted to any server except as a pseudonymous reference (e.g. `bookedByToken` on a counsellor slot) — it is never paired with a phone number, name, or any other identifying value.

## How encryption works

- **At rest (Hive):** AES-256 via `HiveAesCipher`, keyed by a 256-bit key generated on-device and stored in `flutter_secure_storage`.
- **Record-level (where used):** AES-256-CBC with a random IV per encryption operation, via the `encrypt` package — so encrypting the same plaintext twice never produces the same ciphertext.
- **In transit:** All Firebase SDK calls use TLS by default. Since no personal health data is ever sent to Firebase, this mainly protects the pseudonymous tokens and push registration described above.

## How to delete all data

VitaCard stores nothing in the cloud that identifies a student, so deleting a device is enough to erase a student's footprint:

1. Open Android Settings → Apps → VitaCard → Storage → **Clear data**. This wipes both the encrypted Hive database and the `flutter_secure_storage` keychain (including both anonymous tokens and the encryption key) in one step.
2. If a counsellor slot was booked, it remains referenced only by the now-deleted MH token in Firestore — with no way to link it back to the student.
3. If a peer post was made, it remains referenced only by its random two-character code — also unlinkable.
