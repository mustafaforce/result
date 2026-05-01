alter table public.profiles
add column if not exists is_verified boolean not null default false;

alter table public.profiles
add column if not exists is_flagged boolean not null default false;

drop policy if exists "Admin can update profiles" on public.profiles;
create policy "Admin can update profiles"
on public.profiles
for update
to authenticated
using (auth.email() = 'adminHall@gmail.com')
with check (auth.email() = 'adminHall@gmail.com');
