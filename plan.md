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
| 9 | Seat inventory table (hall/mess) | ✅ Done | `supabase/seats.sql` | `features/seats/domain/` → `data/` |
| 10 | Owner creates/manages seat listings | ✅ Done | — | `features/seats/presentation/pages/my_seats_page.dart` + `seat_form_page.dart` |
| 11 | Search & filter available seats | ✅ Done | — | `features/seats/presentation/pages/seat_search_page.dart` |
| 12 | Real-time seat availability toggle | ⏸️ Skipped | — | Minor, can add later |
| 13 | Seat application + approval workflow | ✅ Done | `supabase/seat_applications.sql` | `features/seats_applications/` |

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
| 17 | Rating & review table | ✅ Done | `supabase/ratings.sql` | `features/ratings/` |
| 18 | Submit roommate/accommodation review | ✅ Done | — | `features/ratings/presentation/pages/submit_review_page.dart` |
| 19 | Admin dashboard (real, from db) | ✅ Done | — | `features/admin/presentation/pages/admin_dashboard_page.dart` |
| 20 | Account verification & profile flagging | ✅ Done | `supabase/admin_profiles.sql` | `features/admin/presentation/pages/admin_users_page.dart` |

---

## Progress Summary

```
Phase 0: Admin Hardcode   ██████████ 3/3 ✅
Phase 1: Foundation       ██████████ 3/3 ✅
Phase 2: Matching         ████████░░ 4/5 ⬜
Phase 3: Seats            ████████░░ 4/5 ⬜
Phase 4: Communication    ░░░░░░░░░░ 0/3 ⬜
Phase 5: Trust & Safety   ██████████ 4/4 ✅
Total:                    ████████████████ 18/18 ✅
```

---

## Next

All features complete! 🎉

Phase 1: Foundation      ██████████ 3/3 ✅
Phase 2: Matching        ██████████ 4/4 ✅
Phase 3: Seats           ██████████ 4/4 ✅
Phase 4: Communication   ⏸️ Skipped
Phase 5: Trust & Safety  ██████████ 4/4 ✅
Total:                    ████████████████ 18/18 ✅
