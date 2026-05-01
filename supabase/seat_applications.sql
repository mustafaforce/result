create table if not exists public.seat_applications (
  id uuid primary key default gen_random_uuid(),
  seat_id uuid not null references public.seats(id) on delete cascade,
  applicant_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(seat_id, applicant_id)
);

drop trigger if exists set_seat_applications_updated_at on public.seat_applications;
create trigger set_seat_applications_updated_at
before update on public.seat_applications
for each row
execute function public.set_updated_at();

alter table public.seat_applications enable row level security;

drop policy if exists "Applicants can view own apps" on public.seat_applications;
create policy "Applicants can view own apps"
on public.seat_applications
for select
to authenticated
using (auth.uid() = applicant_id);

drop policy if exists "Owners can view apps for their seats" on public.seat_applications;
create policy "Owners can view apps for their seats"
on public.seat_applications
for select
to authenticated
using (exists (
  select 1 from public.seats where seats.id = seat_id and seats.owner_id = auth.uid()
));

drop policy if exists "Students can apply" on public.seat_applications;
create policy "Students can apply"
on public.seat_applications
for insert
to authenticated
with check (auth.uid() = applicant_id);

drop policy if exists "Owners can update apps for their seats" on public.seat_applications;
create policy "Owners can update apps for their seats"
on public.seat_applications
for update
to authenticated
using (exists (
  select 1 from public.seats where seats.id = seat_id and seats.owner_id = auth.uid()
))
with check (exists (
  select 1 from public.seats where seats.id = seat_id and seats.owner_id = auth.uid()
));
