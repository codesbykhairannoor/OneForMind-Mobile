# 📱 ONEFORMIND: SUPER-DETAILED MOBILE AGENT BLUEPRINT (v1.3)

> **FOR FUTURE AI AGENTS:** This is the ONLY source of truth for building the OneForMind Mobile Ecosystem. 
> Do not guess. Follow these schemas exactly. 
> This file is in `.gitignore` to protect sensitive keys.

---

## 1. 🏗️ CORE ARCHITECTURE & SYSTEM RULES

- **API Base URL**: `https://oneformind.com/api/v1`
- **Response Format**: 
  ```json
  { "status": "success", "message": "...", "data": { ... } }
  // OR
  { "status": "error", "message": "...", "errors": { "field": ["detail"] } }
  ```
- **Language Support**: Header `Accept-Language: id` or `en`. All responses and validation errors are translated.
- **Timezone**: All dates in `YYYY-MM-DD`. Timestamps in ISO 8601.

---

## 2. 🔐 SECRETS & CLOUD INFRASTRUCTURE

### Database & Persistence
- **PostgreSQL (Supabase)**: 
  - Host: `aws-1-ap-south-1.pooler.supabase.com` | Port: `6543`
  - User: `postgres.esahuobozjxkyjvpxslu` | Pass: `Khairanaja09`
- **Redis (Upstash)**: 
  - Host: `tls://crucial-antelope-25210.upstash.io` | Pass: `AWJ6AAIncDExZTdiMzVlNWY3NGY0MzAxYTFkNDFkNWUwODE1MTBlMnAxMjUyMTA`

### Storage & Media
- **Cloudinary**: `cloudinary://624599644654139:LKqurOOCvbkA4VsMxI5JLN-mpXk@dxbgpakk1`
- **Rule**: When uploading images from Mobile, use a `multipart/form-data` POST request.

### AI & Intelligence
- **Gemini AI**: `AIzaSyDwbBVAG55_BeA22m2Ywl1Qf6Rw9uanX-U`
- **Internal API**: Use `/api/v1/coach` for interactive AI chats.

---

## 3. 🌐 API ENDPOINT SPECIFICATIONS

### A. Authentication (Sanctum Token)
- **POST `/register`**: Payload `{ "name": "...", "email": "...", "password": "...", "password_confirmation": "..." }`
- **POST `/login`**: Payload `{ "email": "...", "password": "...", "device_name": "..." }` (Returns Sanctum Bearer Token).
- **POST `/logout`**: Clears the current token on the server.
- **POST `/forgot-password`**: Standard Laravel Fortify/Breeze endpoint.
- **GET `/user`**: Returns full user object including `tier` (explorer, architect, quantum).
- **Token Handling**: If an endpoint returns `401 Unauthorized`, the Flutter app MUST intercept it, clear local storage, and redirect to the Login screen.

### B. Profile & Settings
- **GET `/profile`**: Retrieve user settings.
- **PUT `/profile`**: Update name, email, etc.
- **PUT `/profile/password`**: Change password.

### C. Finance (Budget & Clarity)
- **GET `/finance`**: Summary and recent transactions.
  - *Pagination*: Returns `links` and `meta` (Laravel standard `?page=1&limit=15`) if lists are long.
- **POST `/finance/transaction`**: Required fields: `finance_category_id`, `amount`, `type`, `date`.

### D. Habits (Atomic System)
- **GET `/habits?date=YYYY-MM-DD`**: Returns habits with `is_completed` (log check) and `streak`.
- **POST `/habits/{id}/log`**: Toggle completion for a specific date.

### E. Planner (Intentional Planning)
- **GET `/planner?date=YYYY-MM-DD`**: Returns tasks ordered by `start_time`.
- **POST `/planner/task`**: Payload `{ "title": "...", "date": "...", "start_time": "HH:MM", "priority": "low|medium|high" }`

### F. Job Tracker (Career Pipeline)
- **GET `/jobs`**: Returns list of applied jobs (Paginated).
- **GET `/jobs/stats`**: Summary statistics (count by status).
- **POST `/jobs`**: Payload `{ "title": "...", "company": "...", "status": "wishlist|applied|interview|offer|rejected|accepted", "salary": "..." }`
- **PATCH `/jobs/{id}`**: Update job details or status.
- **DELETE `/jobs/{id}`**: Remove a job entry.
- **GET `/jobs/titles`**: Returns list of unique job titles used by the user (for autocomplete).

### G. Goal Tracker (Manifestation System)
- **GET `/goals`**: Returns list of goals with current progress.
- **GET `/goals/stats`**: Global progress stats (avg progress, total milestones).
- **POST `/goals`**: Payload `{ "title": "...", "type": "daily|weekly|monthly|yearly", "priority": "vital|important|optional", "milestones": [...] }`
- **GET `/goals/{id}`**: Returns single goal with its milestones.
- **PATCH `/goals/{id}`**: Update goal details.
- **DELETE `/goals/{id}`**: Delete goal.
- **Milestones**:
  - **POST `/goals/{goal_id}/milestones`**: Add a new step.
  - **PATCH `/goals/{goal_id}/milestones/{id}`**: Update step title/date.
  - **POST `/goals/{goal_id}/milestones/{id}/toggle`**: Mark step as complete/incomplete.
  - **DELETE `/goals/{goal_id}/milestones/{id}`**: Remove a step.

---

## 4. 🎨 DESIGN & AESTHETIC STANDARDS (THE "ONEFORMIND FEEL")

To maintain the premium "Neural OS" aesthetic on mobile, follow these pixel-perfect rules:

### A. Typography Engineering
- **Headlines (H1/H2)**:
  - Font: `Plus Jakarta Sans` or `Inter` (Fallback).
  - Weight: `900` (Black).
  - Letter Spacing: `-0.03em`.
  - Line Height: `1.05`.
- **Sub-headers**: Slate-500, Weight `500`, Opacity `80%`.
- **Micro-Badges**: Rounded-full, uppercase, `text-[10px]`, `tracking-[0.2em]`.

### B. Layout & Spacing
- **Corner Radius**: High variance. Use `rounded-[2.5rem]` for main containers/cards.
- **Backgrounds**: Use `slate-50` for pages and `white` for cards to create depth.
- **Ambient Glows**: Use `bg-indigo-500/10` with `blur-3xl` for a futuristic feel.

### C. Premium UI Patterns
- **Glassmorphism**: Use `backdrop-blur-md` with `bg-white/60` for navigation bars and overlays.
- **Custom Shadows**:
  - Soft Glow: `shadow-[0_10px_40px_rgba(79,70,229,0.15)]`
  - Deep Elevation: `shadow-[0_20px_50px_rgba(0,0,0,0.05)]`
- **Floating Elements**: Use icons inside `animate-float` containers for a dynamic UI.

### D. Animations (Micro-Interactions)
- **Float**: `0%, 100% { transform: translateY(0); } 50% { transform: translateY(10px); }`
- **Interactions**: All button taps should have a subtle `scale-95` press effect.

---

## 5. 🗄️ DATABASE SCHEMA (SUPABASE)

The database is hosted on Supabase (PostgreSQL). Core tables and their structures:

#### `users`
- `id`, `name`, `email`, `password`, `premium_until`, `plan_type` (explorer/architect), `settings` (JSONB)

#### `finance_transactions`
- `id`, `user_id`, `amount`, `category_id`, `transaction_date`, `notes`, `type` (expense/income)

#### `habits`
- `id`, `user_id`, `name`, `icon`, `color`, `target_per_month`, `order`

#### `habit_logs`
- `id`, `habit_id`, `log_date`, `completed` (boolean)

#### `planner_tasks`
- `id`, `user_id`, `title`, `due_date`, `priority`, `is_completed`, `notes`

#### `jobs` (Job Tracker)
- `id`, `user_id`, `company`, `title`, `location`, `applied_at`, `salary`, `status` (enum: wishlist, applied, interview, offer, rejected, accepted), `notes`
- *Note: In UI, 'wishlist' is displayed as 'Dilamar' and 'applied' as 'Sedang Ditinjau'.*

#### `goals` (Manifestation System)
- `id`, `user_id`, `title`, `type`, `status`, `priority`, `color`, `start_date`, `end_date`, `reward`, `cover_image_path`

#### `goal_milestones`
- `id`, `goal_id`, `title`, `order`, `completed` (boolean), `target_date`

---

## 6. 🧠 BACKEND LOGIC & DATA FLOW
- **Controllers**: Located in `app/Http/Controllers/`.
  - `Api/V1/`: Dedicated versioned endpoints for the mobile app. Uses Sanctum `auth:sanctum` middleware.
  - `JobController`: Manages the Job Tracker. Uses bulk updates for status and ordering.
- **Models**: Located in `app/Models/`.
  - `Job`: Uses an enum for `status`. *Critically*, the status mapping in the UI is decoupled from the DB string for brand feel.
- **Translations**: Located in `lang/partials/`.
  - Mobile agents MUST merge these partials manually or ensure the API returns already-translated strings.
- **Premium Tiers**:
  - `explorer`: Free tier.
  - `architect`: Premium monthly.
  - `quantum`: Premium yearly/lifetime.
  - Check logic: `$user->is_premium` or `$user->plan_type`.

---

## 6. 📲 MOBILE INTEGRATION GUIDE (TIPS & TRICKS)

### Push Notifications (FCM)
- Use **Firebase Cloud Messaging**.
- To link Device Token to User: Create an endpoint `POST /api/v1/notifications/token` (Upcoming).

### Biometric Auth (FaceID/Fingerprint)
- Once the user logs in via email/password, store the `Sanctum Token` in the mobile's **Secure Storage** (Keychain/Keystore).
- On app launch, use Biometrics to unlock access to that stored token.

### PWA / TWA Check (UI Optimization)
In `AuthenticatedLayout.vue` or your Mobile App UI, use this detection:
```javascript
const isStandalone = window.matchMedia('(display-mode: standalone)').matches || window.navigator.standalone;
// If true -> Show Bottom Navigation Bar
// If false -> Use Hamburger Menu (Web Feel)
```

### Deep Linking
- Scheme: `oneformind://`
- Host: `oneformind.com`
- Usage: `oneformind://finance/add` should open the transaction input screen directly.

---

## 7. 🚀 FLUTTER SPECIFIC ARCHITECTURE (FOR 1 MILLION USERS)

To ensure the Flutter app is hyper-fast, scalable, and maintains the premium feel, strictly adhere to these stack choices:

### A. Stack & Core Packages
- **State Management**: **Riverpod** (`flutter_riverpod`). It is compile-safe, highly scalable, and prevents widget tree rebuilds better than Provider or GetX.
- **Routing**: **GoRouter** (`go_router`). Essential for handling the Deep Linking (`oneformind://`) mentioned earlier and standardizing navigation.
- **HTTP Client**: **Dio** (`dio`). Use Interceptors heavily:
  - Inject the `Authorization: Bearer <token>` in every request.
  - Inject `Accept-Language: id` based on local app state.
  - Intercept `401` errors to trigger a global logout event.
- **Localization**: **Easy Localization** (`easy_localization`). Map the existing `id.json` and `en.json` (and partials) directly to the app assets.
- **Local Database (Speed Secret)**: **Isar** (`isar`). Do not rely solely on API calls. Cache Habits, Planner Tasks, and Finance summaries locally using Isar so the app opens instantly offline, then sync in the background.

### B. Folder Structure (Feature-First)
Do NOT use Layer-First (MVC). Use **Feature-First / Clean Architecture** to keep the codebase maintainable as we hit 1M users.
```text
lib/
 ┣ core/ (api_client, theme, utils, error_handling)
 ┣ features/
 ┃ ┣ auth/ (data, domain, presentation)
 ┃ ┣ finance/ (data, domain, presentation)
 ┃ ┣ habits/ (data, domain, presentation)
 ┃ ┣ planner/ (data, domain, presentation)
 ┃ ┗ jobs/ (data, domain, presentation)
 ┗ main.dart
```

### C. Asset & Secret Management
- **Environment Variables**: Use `flutter_dotenv`. Create a `.env` file for the API Base URL and any public keys. **Never hardcode secrets in `lib/`.**
- **Fonts (Zero Latency)**: Do NOT use `google_fonts` network fetching in production. Download the `.ttf` files for **Plus Jakarta Sans** and **Inter**, place them in `assets/fonts/`, and declare them in `pubspec.yaml`. This guarantees instant text rendering on app launch.

---

## 8. 🌌 STRATEGIC DIRECTIVE
This project is a **Unified Life OS**. Every module must talk to each other. 
- Finance affects Goals. 
- Habits affect Planner. 
- AI (Gemini) analyzes all for cross-synergy.

**Mobile implementation should prioritize performance and a "Native" feel while reusing the existing REST API.**

> [!IMPORTANT]
> Always check `routes/api.php` for the latest endpoint mappings before implementing new mobile features.

---
*Generated by Antigravity AI - v1.5 - 2026-04-25*
