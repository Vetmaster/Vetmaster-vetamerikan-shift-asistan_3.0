create table if not exists public.shift_stories (
  id text primary key,
  patient_name text not null,
  caption text not null default 'Defekasyon görüldü',
  image_data text not null,
  author text,
  created_at timestamptz not null default now()
);

alter table public.shift_stories enable row level security;

drop policy if exists "shift_stories_select_authenticated" on public.shift_stories;
create policy "shift_stories_select_authenticated"
on public.shift_stories
for select
to authenticated
using (true);

drop policy if exists "shift_stories_insert_admin" on public.shift_stories;
create policy "shift_stories_insert_admin"
on public.shift_stories
for insert
to authenticated
with check (
  coalesce(auth.jwt() -> 'user_metadata' ->> 'username', split_part(auth.jwt() ->> 'email', '@', 1)) = 'admin'
);

drop policy if exists "shift_stories_update_admin" on public.shift_stories;
create policy "shift_stories_update_admin"
on public.shift_stories
for update
to authenticated
using (
  coalesce(auth.jwt() -> 'user_metadata' ->> 'username', split_part(auth.jwt() ->> 'email', '@', 1)) = 'admin'
)
with check (
  coalesce(auth.jwt() -> 'user_metadata' ->> 'username', split_part(auth.jwt() ->> 'email', '@', 1)) = 'admin'
);

drop policy if exists "shift_stories_delete_admin" on public.shift_stories;
create policy "shift_stories_delete_admin"
on public.shift_stories
for delete
to authenticated
using (
  coalesce(auth.jwt() -> 'user_metadata' ->> 'username', split_part(auth.jwt() ->> 'email', '@', 1)) = 'admin'
);

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'shift_stories'
  ) then
    alter publication supabase_realtime add table public.shift_stories;
  end if;
end
$$;
