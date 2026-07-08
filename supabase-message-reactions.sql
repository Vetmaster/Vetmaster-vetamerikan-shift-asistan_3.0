create table if not exists public.shift_message_reactions (
  id text primary key,
  message_id text not null,
  username text not null,
  reaction text not null default 'heart',
  created_at timestamptz not null default now()
);

alter table public.shift_message_reactions enable row level security;

drop policy if exists "shift_message_reactions_select" on public.shift_message_reactions;
create policy "shift_message_reactions_select"
on public.shift_message_reactions
for select
using (true);

drop policy if exists "shift_message_reactions_insert" on public.shift_message_reactions;
create policy "shift_message_reactions_insert"
on public.shift_message_reactions
for insert
with check (true);

drop policy if exists "shift_message_reactions_delete" on public.shift_message_reactions;
create policy "shift_message_reactions_delete"
on public.shift_message_reactions
for delete
using (true);

drop policy if exists "shift_message_reactions_update" on public.shift_message_reactions;
create policy "shift_message_reactions_update"
on public.shift_message_reactions
for update
using (true)
with check (true);
