-- 勤務表自動作成ツール: Supabaseセットアップ用SQL
-- Supabaseダッシュボード > SQL Editor に貼り付けて実行してください。

create table if not exists schedule_state (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table schedule_state enable row level security;

-- このツールはログイン機能を持たないため、anonキーを使う全員に
-- 読み書きを許可します(社内利用など、URLとキーを知る人だけが使う前提)。
create policy "allow anon read" on schedule_state
  for select using (true);

create policy "allow anon upsert" on schedule_state
  for insert with check (true);

create policy "allow anon update" on schedule_state
  for update using (true);

-- Realtime(他デバイスへの即時反映)を有効化
alter publication supabase_realtime add table schedule_state;
