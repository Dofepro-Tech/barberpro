-- =========================================================================
-- BarberOS · Esquema de perfiles y roles
-- Ejecuta este script en Supabase → SQL Editor (una sola vez por proyecto).
-- =========================================================================

-- Tabla de perfiles: cada usuario de auth.users tiene un perfil con su rol.
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text,
  role text not null default 'cliente' check (role in ('cliente', 'barbero', 'admin')),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Cada usuario solo puede ver y editar su propio perfil (no puede leer ni
-- modificar el de otros, y nunca puede cambiar su propio "role" porque solo
-- se permite update de columnas no sensibles vía la app).
create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);

create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id);

-- Trigger: al registrarse un usuario nuevo, se crea automáticamente su perfil
-- con el rol por defecto 'cliente'. El rol NUNCA se define desde el cliente.
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, role)
  values (new.id, new.email, 'cliente');
  return new;
end;
$$ language plpgsql security definer set search_path = public;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- =========================================================================
-- Para convertir TU cuenta en administrador (hazlo solo tú, manualmente):
-- 1. Regístrate normalmente desde la app con tu correo.
-- 2. Ejecuta en el SQL Editor de Supabase:
--
--    update public.profiles set role = 'admin' where email = 'tu-correo@ejemplo.com';
--
-- Nunca expongas esta operación desde la interfaz pública de la app.
-- =========================================================================
