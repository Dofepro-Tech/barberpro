# 💈 BarberOS

Aplicación móvil (Flutter) para la gestión de barberías: acceso de usuarios, tema oscuro premium con acentos dorados y autenticación en tiempo real mediante **Supabase**.

> Proyecto parte del portafolio de [dofepro.do](https://dofepro.do).

## ✨ Características

- Inicio de sesión y registro de usuarios con **Supabase Auth**.
- Persistencia de sesión: la app recuerda al usuario autenticado (`AuthGate`).
- Tema "Modo Oscuro Premium" (negro + dorado) construido con Material 3.
- Validación de formularios (correo y contraseña) y manejo de errores.
- Arquitectura organizada por capas: `screens/`, `services/`, `theme/`, `widgets/`.
- Soporte multiplataforma (Android, iOS, Web, Windows, macOS, Linux) gracias a Flutter.

## 🧱 Tech Stack

| Capa            | Tecnología           |
|-----------------|----------------------|
| Frontend        | Flutter 3.x / Dart 3 |
| Backend / Auth  | Supabase (Postgres + Auth) |
| Gestión de config | flutter_dotenv     |

## 📂 Estructura del proyecto

```
lib/
├── main.dart              # Bootstrap: carga .env, inicializa Supabase, define rutas
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── home_screen.dart
├── services/
│   └── auth_service.dart  # Wrapper de las llamadas de autenticación de Supabase
├── theme/
│   └── app_theme.dart     # Paleta de colores y ThemeData
└── widgets/
    └── social_button.dart
```

## 🚀 Cómo ejecutar el proyecto

### 1. Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x
- Una cuenta gratuita en [Supabase](https://supabase.com)

### 2. Clonar e instalar dependencias

```bash
git clone https://github.com/<tu-usuario>/barberpro.git
cd barberpro
flutter pub get
```

### 3. Configurar variables de entorno

Copia el archivo de ejemplo y coloca tus propias credenciales de Supabase (Project Settings → API):

```bash
cp .env.example .env
```

```
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key
```

> ⚠️ El archivo `.env` está en `.gitignore` y nunca debe subirse al repositorio.

### 4. Ejecutar la app

```bash
flutter run
```

## 🔒 Seguridad

- Las credenciales de Supabase se cargan desde variables de entorno (`.env`), nunca están hardcodeadas en el código fuente.
- El acceso a los datos debe protegerse con **Row Level Security (RLS)** en Supabase.

## 🗺️ Roadmap

- [ ] Gestión de citas (calendario y turnos)
- [ ] Perfil de barbero y catálogo de servicios
- [ ] Notificaciones push
- [ ] Soporte multi-idioma (ES/EN)

## 📄 Licencia

MIT — libre para uso personal y educativo.
