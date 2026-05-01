create table if not exists public.roommate_requests (
  id uuid primary key default gen_random_uuid(),
  from_user_id uuid not null references public.profiles(id) on delete cascade,
  to_user_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'accepted', 'rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(from_user_id, to_user_id)
);

drop trigger if exists set_roommate_requests_updated_at on public.roommate_requests;
create trigger set_roommate_requests_updated_at
before update on public.roommate_requests
for each row
execute function public.set_updated_at();

alter table public.roommate_requests enable row level security;

drop policy if exists "Users can read own requests" on public.roommate_requests;
create policy "Users can read own requests"
on public.roommate_requests
for select
to authenticated
using (auth.uid() = from_user_id or auth.uid() = to_user_id);

drop policy if exists "Users can send requests" on public.roommate_requests;
create policy "Users can send requests"
on public.roommate_requests
for insert
to authenticated
with check (auth.uid() = from_user_id);

drop policy if exists "Users can update own received requests" on public.roommate_requests;
create policy "Users can update own received requests"
on public.roommate_requests
for update
to authenticated
using (auth.uid() = to_user_id)
with check (auth.uid() = to_user_id);
