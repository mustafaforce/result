drop policy if exists "Approved apps visible to all" on public.seat_applications;
create policy "Approved apps visible to all"
on public.seat_applications
for select
to authenticated
using (status = 'approved');
