// Public Supabase config only — never put service_role / DB password here.
const supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://wvtdntsyncjvovvrxktw.supabase.co',
);
const supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'sb_publishable_iw2WE40zKKOr89394OEPfQ_2L-fDyRy',
);
