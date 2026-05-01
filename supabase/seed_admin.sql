-- Run this in Supabase SQL Editor (Project → SQL Editor)
-- Creates the demo admin user for Roomix

-- Safe: only inserts if email doesn't already exist
do $$
begin
  if not exists (select 1 from auth.users where email = 'adminHall@gmail.com') then
    insert into auth.users (
      instance_id,
      id,
      aud,
      role,
      email,
      encrypted_password,
      email_confirmed_at,
      raw_app_meta_data,
      raw_user_meta_data,
      created_at,
      updated_at,
      confirmation_token,
      email_change,
      email_change_token_new,
      recovery_token
    ) values (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(),
      'authenticated',
      'authenticated',
      'adminHall@gmail.com',
      crypt('12345678', gen_salt('bf')),
      now(),
      '{"provider":"email","providers":["email"]}',
      '{"full_name":"Hall Admin"}',
      now(),
      now(),
      '', '', '', ''
    );
  end if;
end $$;
