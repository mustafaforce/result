create table if not exists public.seats (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  description text,
  hall_name text not null,
  seat_number text,
  location text,
  monthly_fee numeric(10,2),
  is_available boolean not null default true,
  facilities text[] default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_seats_updated_at on public.seats;
create trigger set_seats_updated_at
before update on public.seats
for each row
execute function public.set_updated_at();

alter table public.seats enable row level security;

drop policy if exists "Anyone can view seats" on public.seats;
create policy "Anyone can view seats"
on public.seats
for select
to authenticated
using (true);

drop policy if exists "Owners can insert seats" on public.seats;
create policy "Owners can insert seats"
on public.seats
for insert
to authenticated
with check (auth.uid() = owner_id);

drop policy if exists "Owners can update own seats" on public.seats;
create policy "Owners can update own seats"
on public.seats
for update
to authenticated
using (auth.uid() = owner_id)
with check (auth.uid() = owner_id);

drop policy if exists "Owners can delete own seats" on public.seats;
create policy "Owners can delete own seats"
on public.seats
for delete
to authenticated
using (auth.uid() = owner_id);
