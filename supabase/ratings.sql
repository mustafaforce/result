create table if not exists public.ratings (
  id uuid primary key default gen_random_uuid(),
  reviewer_id uuid not null references public.profiles(id) on delete cascade,
  reviewee_id uuid not null references public.profiles(id) on delete cascade,
  rating smallint not null check (rating between 1 and 5),
  review_text text,
  created_at timestamptz not null default now(),
  unique(reviewer_id, reviewee_id)
);

alter table public.ratings enable row level security;

drop policy if exists "Anyone can view ratings" on public.ratings;
create policy "Anyone can view ratings"
on public.ratings
for select
to authenticated
using (true);

drop policy if exists "Users can insert own ratings" on public.ratings;
create policy "Users can insert own ratings"
on public.ratings
for insert
to authenticated
with check (auth.uid() = reviewer_id);
