-- Admin can view all seat applications.
drop policy if exists "Admin can view all apps" on public.seat_applications;
create policy "Admin can view all apps"
on public.seat_applications
for select
to authenticated
using (auth.email() = 'adminHall@gmail.com');

-- Admin can update (approve/reject) any seat application.
drop policy if exists "Admin can update any app" on public.seat_applications;
create policy "Admin can update any app"
on public.seat_applications
for update
to authenticated
using (auth.email() = 'adminHall@gmail.com')
with check (auth.email() = 'adminHall@gmail.com');

-- Enforce: a user can hold at most one active (pending or approved) application at a time.
drop index if exists public.unique_active_application_per_user;
create unique index unique_active_application_per_user
on public.seat_applications (applicant_id)
where status in ('pending', 'approved');
