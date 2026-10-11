-- Run this once in Supabase: SQL Editor > New query > paste > Run.
create table if not exists links (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  id text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);
create table if not exists meta (
  user_id uuid primary key default auth.uid() references auth.users on delete cascade,
  cols jsonb not null default '[]',
  updated_at timestamptz not null default now()
);
alter table links enable row level security;
alter table meta enable row level security;
create policy "own links" on links for all
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "own meta" on meta for all
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
