create table if not exists public.matching_preferences (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  study_habit text not null default 'moderate' check (study_habit in ('quiet', 'moderate', 'social')),
  guest_frequency text not null default 'occasional' check (guest_frequency in ('never', 'occasional', 'frequent')),
  noise_tolerance smallint not null default 3 check (noise_tolerance between 1 and 5),
  sleep_time text not null default 'flexible' check (sleep_time in ('early_bird', 'flexible', 'night_owl')),
  sharing_preference text not null default 'flexible' check (sharing_preference in ('private', 'okay_shared', 'flexible')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_matching_preferences_updated_at on public.matching_preferences;
create trigger set_matching_preferences_updated_at
before update on public.matching_preferences
for each row
execute function public.set_updated_at();

--- Extend handle_new_user to create default matching_preferences
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', ''))
  on conflict (id) do nothing;

  insert into public.user_preferences (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  insert into public.matching_preferences (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

alter table public.matching_preferences enable row level security;

drop policy if exists "Users can read matching_preferences" on public.matching_preferences;
create policy "Users can read matching_preferences"
on public.matching_preferences
for select
to authenticated
using (true);

drop policy if exists "Users can insert own matching_preferences" on public.matching_preferences;
create policy "Users can insert own matching_preferences"
on public.matching_preferences
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update own matching_preferences" on public.matching_preferences;
create policy "Users can update own matching_preferences"
on public.matching_preferences
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
