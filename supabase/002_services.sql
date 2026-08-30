-- =========================================================================
-- BarberOS · Catálogo de servicios
-- Ejecuta este script en Supabase → SQL Editor (después de schema.sql).
-- =========================================================================

-- Helper reutilizable: ¿el usuario autenticado actual es admin?
create or replace function public.is_admin()
returns boolean as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$ language sql security definer stable set search_path = public;

create table if not exists public.services (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  descripcion text,
  precio numeric(10, 2) not null check (precio >= 0),
  duracion_minutos int not null check (duracion_minutos > 0),
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.services enable row level security;

-- Cualquier usuario autenticado puede ver los servicios activos.
create policy "services_select_active" on public.services
  for select using (activo = true or public.is_admin());

-- Solo los administradores pueden crear, editar o borrar servicios.
create policy "services_insert_admin" on public.services
  for insert with check (public.is_admin());

create policy "services_update_admin" on public.services
  for update using (public.is_admin());

create policy "services_delete_admin" on public.services
  for delete using (public.is_admin());

-- Datos de ejemplo (opcional, bórralos si no los quieres)
insert into public.services (nombre, descripcion, precio, duracion_minutos) values
  ('Corte clásico', 'Corte de cabello tradicional con tijera y máquina.', 350, 30),
  ('Corte + Barba', 'Corte de cabello y arreglo de barba completo.', 550, 45),
  ('Afeitado premium', 'Afeitado tradicional con navaja y toalla caliente.', 400, 30)
on conflict do nothing;
