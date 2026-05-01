alter table public.seats
add column if not exists capacity integer not null default 2
check (capacity >= 1);
