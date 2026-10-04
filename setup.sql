-- 41 Green Drive Expenses: run this once in Supabase → SQL Editor → New query → Run.

-- 1) One table holds everything (bills, payments, settings, history). Each row belongs to a signed-in user.
create table if not exists public.docs (
  owner      uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  path       text        not null,
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (owner, path)
);

-- 2) Only the signed-in owner can see or change their rows.
alter table public.docs enable row level security;
drop policy if exists "owner reads"   on public.docs;
drop policy if exists "owner writes"  on public.docs;
drop policy if exists "owner updates" on public.docs;
drop policy if exists "owner deletes" on public.docs;
create policy "owner reads"   on public.docs for select using (owner = auth.uid());
create policy "owner writes"  on public.docs for insert with check (owner = auth.uid());
create policy "owner updates" on public.docs for update using (owner = auth.uid()) with check (owner = auth.uid());
create policy "owner deletes" on public.docs for delete using (owner = auth.uid());

-- 3) Live updates (so a change on your phone shows up on your computer right away).
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;

-- 4) Private storage for bill photos and PDFs. Files live under a folder named after your user id.
insert into storage.buckets (id, name, public) values ('bills', 'bills', false)
on conflict (id) do nothing;
drop policy if exists "bills owner read"   on storage.objects;
drop policy if exists "bills owner write"  on storage.objects;
drop policy if exists "bills owner update" on storage.objects;
drop policy if exists "bills owner delete" on storage.objects;
create policy "bills owner read"   on storage.objects for select using (bucket_id = 'bills' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "bills owner write"  on storage.objects for insert with check (bucket_id = 'bills' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "bills owner update" on storage.objects for update using (bucket_id = 'bills' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "bills owner delete" on storage.objects for delete using (bucket_id = 'bills' and (storage.foldername(name))[1] = auth.uid()::text);
