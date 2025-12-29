# Interrapidisimo - Prueba Técnica

Aplicación iOS desarrollada en SwiftUI para la gestión de usuarios, localidades, sincronización de esquemas de base de datos y captura de fotos.

## Requisitos

- Xcode 16.1 o superior
- iOS 18.0+ (Deployment target: iOS 26.1)

## Cómo Correr el Proyecto

1. **Clonar el repositorio**
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd "Prueba tecnica interrapidisimo"
   ```

2. **Abrir el proyecto en Xcode**
   ```bash
   cd Interrapidisimo
   open Interrapidisimo.xcodeproj
   ```

3. **Seleccionar el simulador o dispositivo**
   - En Xcode, selecciona un simulador de iPhone (iOS 18.0+) o conecta un dispositivo físico
   - Recomendado: iPhone 15 Pro o superior

4. **Ejecutar la aplicación**
   - Presiona `Cmd + R` o haz clic en el botón Play
   - La aplicación se compilará e iniciará automáticamente

## Decisiones de Arquitectura

### Arquitectura General: Clean Architecture

El proyecto implementa **Clean Architecture** con separación clara de responsabilidades en tres capas principales:

#### 1. **Domain (Dominio)**
- **Responsabilidad**: Contiene la lógica de negocio pura e independiente de frameworks
- **Componentes**:
  - `Models`: Entidades del dominio (User, Photo, Locality, SchemaTable, AuthResponse, VersionControl)
  - `UseCases`: Casos de uso que orquestan la lógica de negocio
    - `LoginUseCase`: Autenticación de usuarios
    - `GetLocalitiesUseCase`: Obtención de localidades
    - `SyncSchemaUseCase`: Sincronización de esquemas de BD
    - `GetPhotosUseCase`: Recuperación de fotos
    - `SavePhotoUseCase`: Guardado de fotos
    - `CheckVersionUseCase`: Control de versiones

#### 2. **Data (Datos)**
- **Responsabilidad**: Implementación de acceso a datos (API y Base de datos)
- **Componentes**:
  - `ApiClient`: Cliente HTTP genérico para comunicación con APIs REST
  - `Database`: Cliente SQLite para persistencia local
  - `Repositories`: Implementación del patrón Repository
  - `Services`: Servicios específicos para diferentes endpoints (Auth, Locality, Schema, Version)

#### 3. **Presentation (Presentación)**
- **Responsabilidad**: UI y manejo de estados de la vista
- **Patrón**: MVVM (Model-View-ViewModel)
- **Componentes**:
  - Views: Vistas SwiftUI (LoginView, HomeView, LocalitiesView, PhotosView, TablesView)
  - ViewModels: Lógica de presentación y manejo de estados
  - UIComponents: Componentes reutilizables (LoadingView, ErrorView, EmptyStateView, PrimaryButton)

#### 4. **Core (Núcleo)**
- **Responsabilidad**: Utilidades y configuraciones compartidas
- **Componentes**:
  - `Configuration`: Constantes de configuración (URLs, endpoints, feature flags)
  - `Extensions`: Extensiones de tipos nativos (Bundle, View)

### Ventajas de esta Arquitectura

- **Testabilidad**: Cada capa puede probarse independientemente
- **Mantenibilidad**: Código organizado y fácil de entender
- **Escalabilidad**: Fácil agregar nuevas funcionalidades sin afectar otras capas
- **Independencia de frameworks**: La lógica de negocio no depende de SwiftUI o UIKit
- **Principios SOLID**: Respeta los principios de diseño orientado a objetos

## Decisiones de Red

### Cliente HTTP Personalizado

Se implementó un **ApiClient genérico** basado en `URLSession` nativo de iOS:

```swift
protocol ApiClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
}
```

#### Características:
- **Async/Await**: Utiliza la concurrencia moderna de Swift para llamadas asincrónicas
- **Genéricos**: Soporte para cualquier modelo `Decodable`
- **Manejo de errores**: Tipos de error personalizados (`NetworkError`)
- **Configuración centralizada**: Endpoints definidos en `Configuration.swift`

#### Endpoints Implementados:
- `POST /api/Seguridad/AuthenticaUsuarioApp`: Autenticación
- `GET /api/ParametrosFramework/ConsultarParametrosFramework/VPStoreAppControl`: Control de versiones
- `GET /api/SincronizadorDatos/ObtenerEsquema/true`: Sincronización de esquemas -- Fallo en la respuesta: 401
- `GET /api/ParametrosFramework/ObtenerLocalidadesRecogidas`: Obtención de localidades -- Fallo en la respuesta: 401

#### Feature Flags:
```swift
enum Flags {
    static let useMockSchema = true
    static let useMockLocalities = true
}
```
Permite alternar entre servicios reales y mock para facilitar el desarrollo y testing.

## Decisiones de Base de Datos

### SQLite3

Se eligió **SQLite3** nativa de iOS para la persistencia local:

#### Justificación:
- **Ligera**: No requiere dependencias externas
- **Nativa**: Integrada en iOS SDK
- **Performante**: Excelente rendimiento para operaciones CRUD
- **SQL estándar**: Sintaxis familiar y bien documentada
- **Portabilidad**: Base de datos en un solo archivo

#### Implementación:

**Cliente Singleton**: `SQLiteClient.shared`

**Ubicación de la BD**:
```
~/Library/Application Support/Interrapidisimo/interrapidisimo.db
```

#### Tablas Creadas:

1. **users**
   ```sql
   CREATE TABLE IF NOT EXISTS users (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       usuario TEXT NOT NULL,
       identificacion TEXT NOT NULL,
       nombre TEXT NOT NULL,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

2. **schema_tables**
   ```sql
   CREATE TABLE IF NOT EXISTS schema_tables (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       table_name TEXT NOT NULL,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

3. **photos**
   ```sql
   CREATE TABLE IF NOT EXISTS photos (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT NOT NULL UNIQUE,
       image_data BLOB NOT NULL,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

#### Características:
- **Auto-creación**: Las tablas se crean automáticamente al abrir la BD
- **Tipos de datos**: Soporte para INTEGER, TEXT, BLOB, TIMESTAMP
- **Transacciones**: Operaciones atómicas para integridad de datos
- **Consultas tipadas**: Wrapper seguro que retorna `[[String: Any]]`

## Supuestos

1. **Versión de la aplicación**: Se asumió una versión inicial `100.0.0` para el control de versiones

2. **Feature Flags activados**:
   - `useMockSchema = true`: Usa servicios mock para esquemas
   - `useMockLocalities = true`: Usa servicios mock para localidades
   - Esto permite desarrollo y pruebas sin depender completamente de la API

3. **Permisos**: Se requiere permiso de cámara para captura de fotos (configurado en Info.plist)

4. **Orientación de pantalla**: La aplicación está optimizada para orientación vertical (Portrait)

5. **Dispositivos soportados**: iPhone y iPad (Universal)

6. **Persistencia**:
   - Usuarios autenticados se guardan localmente
   - Fotos se almacenan como BLOB en SQLite
   - El esquema de BD se sincroniza al iniciar la app

7. **Sin autenticación persistente**: No se implementó persistencia de sesión (el usuario debe iniciar sesión cada vez que abre la app)

8. **Conectividad**: Se asume conexión a internet para login y sincronización inicial

## Librerías

### Librerías Nativas de iOS (No requieren instalación)

El proyecto **NO utiliza dependencias externas**. Todas las funcionalidades están implementadas usando frameworks nativos de iOS:

1. **SwiftUI**: Framework de UI declarativa
   - Usado para todas las vistas de la aplicación
   - Componentes modernos y reactivos

2. **Foundation**: Framework base de Swift
   - URLSession para networking
   - Data, String, Date y tipos básicos

3. **SQLite3**: Base de datos embebida
   - Importado como `import SQLite3`
   - Cliente personalizado implementado

4. **Combine**: Framework de programación reactiva
   - Para binding de datos en ViewModels
   - Observación de cambios con `@Published`

5. **PhotosUI**: Selector de fotos del sistema
   - `ImagePicker` para selección de imágenes
   - Acceso a la galería de fotos

### Ventajas de No Usar Dependencias Externas

- Sin gestores de paquetes (CocoaPods, SPM)
- Sin conflictos de versiones
- Menor tamaño de la aplicación
- Mejor rendimiento
- Mayor seguridad (no hay código de terceros)
- Compilación más rápida

## Estructura del Proyecto

```
Interrapidisimo/
├── Interrapidisimo/
│   ├── Core/
│   │   ├── Enviroment/
│   │   │   └── Configuration.swift
│   │   └── Extensions/
│   │       ├── Bundle+Extensions.swift
│   │       └── View+Extensions.swift
│   ├── Data/
│   │   ├── ApiClient/
│   │   │   ├── ApiClient.swift
│   │   │   ├── Endpoint.swift
│   │   │   ├── InterrapidisimoApiClient.swift
│   │   │   └── NetworkError.swift
│   │   ├── Database/
│   │   │   ├── DatabaseError.swift
│   │   │   └── SQLiteClient.swift
│   │   ├── Repositories/
│   │   │   ├── AuthRepository.swift
│   │   │   ├── PhotoRepositoryProtocol.swift
│   │   │   └── SchemaRepository.swift
│   │   └── Services/
│   │       ├── AuthService.swift
│   │       ├── InterrapidisimoAPI.swift
│   │       ├── LocalityService.swift
│   │       ├── LocalityServiceProtocol.swift
│   │       ├── MockLocalityService.swift
│   │       ├── MockSchemaService.swift
│   │       ├── SchemaService.swift
│   │       ├── SchemaServiceProtocol.swift
│   │       └── VersionService.swift
│   ├── Domain/
│   │   ├── Models/
│   │   │   ├── AuthResponse.swift
│   │   │   ├── Locality.swift
│   │   │   ├── Photo.swift
│   │   │   ├── SchemaTable.swift
│   │   │   ├── User.swift
│   │   │   └── VersionControl.swift
│   │   └── UseCases/
│   │       ├── CheckVersionUseCase.swift
│   │       ├── GetLocalitiesUseCase.swift
│   │       ├── GetPhotosUseCase.swift
│   │       ├── LoginUseCase.swift
│   │       ├── SavePhotoUseCase.swift
│   │       └── SyncSchemaUseCase.swift
│   ├── Presentation/
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   └── HomeViewModel.swift
│   │   ├── Launch/
│   │   │   ├── LaunchView.swift
│   │   │   └── LaunchViewModel.swift
│   │   ├── Localities/
│   │   │   ├── LocalitiesView.swift
│   │   │   └── LocalitiesViewModel.swift
│   │   ├── Login/
│   │   │   ├── LoginView.swift
│   │   │   └── LoginViewModel.swift
│   │   ├── Photos/
│   │   │   ├── ImagePicker.swift
│   │   │   ├── PhotoDetailView.swift
│   │   │   ├── PhotosView.swift
│   │   │   └── PhotosViewModel.swift
│   │   ├── Tables/
│   │   │   ├── TablesView.swift
│   │   │   └── TablesViewModel.swift
│   │   └── UIComponents/
│   │       ├── EmptyStateView.swift
│   │       ├── ErrorView.swift
│   │       ├── LoadingView.swift
│   │       └── PrimaryButton.swift
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── InterrapidisimoApp.swift
└── Interrapidisimo.xcodeproj/
```

## Pasos de Prueba

### 1. Prueba de Launch Screen

**Objetivo**: Verificar la pantalla inicial y la sincronización automática

**Pasos**:
1. Abrir la aplicación
2. Observar la pantalla de lanzamiento con el logo
3. La app verificará automáticamente la versión y sincronizará el esquema de BD
4. Navega automáticamente a la pantalla de login

**Resultado esperado**:
- Se muestra la vista de lanzamiento
- Las tablas de BD se crean correctamente
- Redirección automática al login

### 2. Prueba de Autenticación

**Objetivo**: Validar el flujo de login

**Pasos**:
1. En la pantalla de login
2. Presionar el botón "Iniciar Sesión"
3. Esperar la respuesta del servidor

**Resultado esperado**:
- Se muestra un indicador de carga
- Si las credenciales son correctas, se navega a la pantalla Home
- El usuario se guarda en la tabla `users` de SQLite
- Si las credenciales son incorrectas, se muestra un mensaje de error

### 3. Prueba de Navegación Home

**Objetivo**: Verificar las opciones disponibles en el menú principal

**Pasos**:
1. Después de iniciar sesión exitosamente, observar el Home
2. Verificar que se muestran 3 opciones:
   - **Ver Localidades**
   - **Ver Tablas de BD**
   - **Tomar Fotos**

**Resultado esperado**:
- Se muestran las tres cards de navegación
- Cada card tiene un título y un icono correspondiente
- Al presionar cada card, navega a la pantalla correspondiente

### 4. Prueba de Localidades

**Objetivo**: Validar la obtención y visualización de localidades

**Pasos**:
1. Desde el Home, presionar "Ver Localidades"
2. Observar la lista de localidades
3. Verificar que se muestran código y nombre

**Resultado esperado**:
- Se muestra un loader mientras carga
- Se despliega una lista con las localidades (mock o desde API según feature flag)
- Cada item muestra: código de localidad y nombre
- Si no hay datos, se muestra un mensaje de estado vacío

### 5. Prueba de Tablas de BD

**Objetivo**: Verificar la visualización de las tablas sincronizadas

**Pasos**:
1. Desde el Home, presionar "Ver Tablas de BD"
2. Observar la lista de tablas

**Resultado esperado**:
- Se muestra la lista de tablas almacenadas en `schema_tables`
- Cada item muestra el nombre de la tabla
- Si no hay tablas sincronizadas, se muestra un estado vacío

### 6. Prueba de Captura de Fotos

**Objetivo**: Validar la captura y persistencia de fotos

**Pasos**:
1. Desde el Home, presionar "Tomar Fotos"
2. Presionar el botón "Agregar Foto"
3. Conceder permiso de cámara si es solicitado
4. Seleccionar una foto de la galería o tomar una nueva
5. Ingresar un nombre para la foto
6. Presionar "Guardar"
7. Verificar que la foto aparece en la lista

**Resultado esperado**:
- Se abre el selector de fotos del sistema
- La foto seleccionada se muestra en una vista previa
- Al guardar, la foto se almacena como BLOB en la tabla `photos`
- La lista de fotos se actualiza mostrando la nueva foto
- Si hay error (ej: nombre duplicado), se muestra un mensaje de error

### 7. Prueba de Visualización de Foto

**Objetivo**: Verificar la vista detallada de una foto guardada

**Pasos**:
1. En la pantalla de Fotos, seleccionar una foto de la lista
2. Observar la vista de detalle

**Resultado esperado**:
- Se muestra la foto en tamaño completo
- Se muestra el nombre de la foto
- Se muestra la fecha de creación

### 8. Prueba de Base de Datos

**Objetivo**: Verificar la persistencia de datos

**Pasos**:
1. Iniciar sesión con un usuario
2. Guardar varias fotos
3. Cerrar completamente la aplicación (force quit)
4. Volver a abrir la aplicación
5. Iniciar sesión nuevamente

**Resultado esperado**:
- El usuario guardado previamente está en la BD
- Las tablas sincronizadas persisten
- Las fotos guardadas se mantienen después de cerrar la app
- Los datos se recuperan correctamente de SQLite

### 9. Prueba de UI/UX

**Objetivo**: Verificar la experiencia de usuario

**Aspectos a evaluar**:
- **Loading states**: Se muestran indicadores de carga durante operaciones asincrónicas
- **Empty states**: Mensajes claros cuando no hay datos
- **Error states**: Mensajes de error descriptivos
- **Navegación**: Botones de "Volver" funcionan correctamente


## API Endpoints

Base URL: `https://apitesting.interrapidisimo.co`

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/apicontrollerpruebas/api/ParametrosFramework/ConsultarParametrosFramework/VPStoreAppControl` | GET | Control de versiones |
| `/FtEntregaElectronica/MultiCanales/ApiSeguridadPruebas/api/Seguridad/AuthenticaUsuarioApp` | POST | Autenticación |
| `/apicontrollerpruebas/api/SincronizadorDatos/ObtenerEsquema/true` | GET | Sincronización de esquemas |
| `/apicontrollerpruebas/api/ParametrosFramework/ObtenerLocalidadesRecogidas` | GET | Obtener localidades |

Nota: En los ultimos dos enpoints se obtuvo como codigo de respuesta 401 por lo que no fue posible obtener la informacion de los endpoints. Sin embargo por la arquitectura de la aplicacion fue posible implementar mocks de las respuestas de los endpoints sin alterar toda la aplicacion y de esta manera en el momento que se puedan usar los endpoints. los cambios que se deban hacer serian minimos.  




