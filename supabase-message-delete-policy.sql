alter table public.shift_messages enable row level security;

drop policy if exists "shift_messages_delete" on public.shift_messages;
create policy "shift_messages_delete"
on public.shift_messages
for delete
using (true);

drop policy if exists "shift_messages_select" on public.shift_messages;
create policy "shift_messages_select"
on public.shift_messages
for select
using (true);

drop policy if exists "shift_messages_insert" on public.shift_messages;
create policy "shift_messages_insert"
on public.shift_messages
for insert
with check (true);

drop policy if exists "shift_messages_update" on public.shift_messages;
create policy "shift_messages_update"
on public.shift_messages
for update
using (true)
with check (true);
