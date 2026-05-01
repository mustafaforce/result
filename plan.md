# Roomix — Implementation Plan

## Structure

Each feature follows this workflow:
1. **SQL migration** — write to `supabase/` (schema, RLS, triggers, seed data)
2. **Code** — clean architecture: `domain/ → data/ → presentation/`
3. **Mark complete** — update this file
4. **Wait** — user command triggers next feature

> ✅ = Done | ⬜ = Pending | 🔄 = In Progress

---

## Phase 0: Admin Hardcode 🔄

| # | Feature | Status | SQL File | Clean Architecture |
|---|---------|--------|----------|-------------------|
| — | Admin constants (email/pass) + check | ✅ Done | — | `core/constants/admin.dart` |
| — | Admin dashboard placeholder page | ✅ Done | — | `features/admin/presentation/pages/admin_dashboard_page.dart` |
| — | Admin routing logic (login redirect + init route) | ✅ Done | — | `app/app.dart`, `app/router/app_router.dart`, `features/auth/presentation/pages/login_page.dart` |

- Hardcoded admin: `adminHall@gmail.com` / `12345678`
- Auth check after login → route to admin dashboard vs student home
- Placeholder admin dashboard page

---

## Phase 1: Foundation ✅

| # | Feature | Status | SQL | Domain | Data | Presentation |
|---|---------|--------|-----|--------|------|-------------|
| 1 | Auth (login/signup/logout) | ✅ Done | — | `auth/domain/` | `auth/data/` | `auth/presentation/` |
| 2 | Profile CRUD | ✅ Done | `profile_page_schema.sql` | `profile/domain/` | `profile/data//` | `profile/presentation/` |
| 3 | Lifestyle pref selection | ✅ Done | in `user_preferences` table | in `UserProfile` entity | in `UserProfileModel` | `lifestyle_section.dart` |

---

## Phase 2: Roommate Matching ⬜

| # | Feature | Status | SQL File | Clean Architecture |
|---|---------|--------|----------|-------------------|
| 4 | Matching preferences table | ✅ Done | `supabase/matching_preferences.sql` | `features/matching/domain/` → `data/` |
| 5 | Compatibility scoring algorithm | ✅ Done | — | `features/matching/domain/services/compatibility_scorer.dart` |
| 6 | Ranked roommate suggestions list | ✅ Done | — | `features/matching/presentation/pages/match_results_page.dart` |
| 7 | Send roommate request + approval | ✅ Done | `supabase/roommate_requests.sql` | `features/requests/` |
| 8 | Notifications for request events | ⬜ | `supabase/notifications.sql` | `features/notifications/` |

---

## Phase 3: Mess Seats ⬜

| # | Feature | Status | SQL File | Clean Architecture |
|---|---------|--------|----------|-------------------|
| 9 | Seat inventory table (hall/mess) | ⬜ | `supabase/seats.sql` | — |
| 10 | Owner creates/manages seat listings | ⬜ | — | `features/seats/` |
| 11 | Search & filter available seats | ⬜ | — | `features/seats/presentation/pages/seat_search_page.dart` |
| 12 | Real-time seat availability toggle | ⬜ | — | in seat inventory |
| 13 | Seat application + approval workflow | ⬜ | `supabase/seat_applications.sql` | `features/seats/` |

---

## Phase 4: Communication ⬜

| # | Feature | Status | SQL File | Clean Architecture |
|---|---------|--------|----------|-------------------|
| 14 | Conversations table | ⬜ | `supabase/messages.sql` | — |
| 15 | In-app messaging (realtime) | ⬜ | — | `features/chat/` |
| 16 | Message read/unread status | ⬜ | — | in chat |

---

## Phase 5: Trust & Safety ⬜

| # | Feature | Status | SQL File | Clean Architecture |
|---|---------|--------|----------|-------------------|
| 17 | Rating & review table | ⬜ | `supabase/ratings.sql` | `features/ratings/` |
| 18 | Submit roommate/accommodation review | ⬜ | — | `features/ratings/` |
| 19 | Admin dashboard (real, from db) | ⬜ | `supabase/admin.sql` | `features/admin/` |
| 20 | Account verification & profile flagging | ⬜ | — | `features/admin/` |

---

## Progress Summary

```
Phase 0: Admin Hardcode   ██████████ 3/3 ✅
Phase 1: Foundation       ██████████ 3/3 ✅
Phase 2: Matching         ████████░░ 4/5 ⬜
Phase 3: Seats            ░░░░░░░░░░ 0/5 ⬜
Phase 4: Communication    ░░░░░░░░░░ 0/3 ⬜
Phase 5: Trust & Safety   ░░░░░░░░░░ 0/4 ⬜
Total:                    ███████░░░ 10/21 ✅
```

---

## Next

Current feature: **#8 — Notifications for request events**
Command: `start feature 8` to begin.
