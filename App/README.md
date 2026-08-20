# ParqueoSeguroApp

## 1. Framework multiplataforma seleccionado

Para el desarrollo de ParqueoSeguroApp se seleccionó **Flutter**, utilizando el lenguaje **Dart**.

Flutter fue elegido porque permite desarrollar aplicaciones multiplataforma utilizando una sola base de código. Además, proporciona herramientas para crear interfaces móviles, realizar pruebas en dispositivos virtuales y utilizar recarga en caliente durante el desarrollo.

Para este proyecto, Flutter permite desarrollar la aplicación móvil Android y comunicarse mediante solicitudes HTTP con el backend desarrollado en Python y Flask.

La versión utilizada durante la configuración del proyecto fue:

* Flutter 3.44.9
* Dart 3.12.2
* DevTools 2.57.0

## 2. Descripción de ParqueoSeguroApp

ParqueoSeguroApp es una aplicación móvil para la gestión de parqueaderos y reservas de espacios de estacionamiento.

La aplicación permite al usuario:

* Registrarse.
* Iniciar sesión.
* Autenticarse mediante JWT.
* Registrar vehículos.
* Consultar sus vehículos.
* Editar vehículos.
* Eliminar vehículos.
* Consultar parqueaderos.
* Consultar las zonas de estacionamiento.
* Identificar zonas disponibles y ocupadas.
* Seleccionar un vehículo para realizar una reserva.
* Seleccionar fecha y horario.
* Realizar reservas.
* Consultar sus reservas.
* Cancelar reservas.
* Liberar una zona cuando una reserva es cancelada.

La información de la aplicación se almacena en una base de datos MySQL y el acceso a los datos se realiza mediante una API desarrollada con Flask.

## 3. Tecnologías utilizadas

### Aplicación móvil

* Flutter
* Dart
* Android Studio
* Android SDK
* Android Emulator
* Visual Studio Code

### Backend

* Python
* Flask
* Flask-SQLAlchemy
* Flask-JWT-Extended
* Flask-CORS
* Flask-Caching
* bcrypt

### Base de datos

* MySQL
* XAMPP
* phpMyAdmin

### Pruebas y administración

* Postman
* Git
* GitHub

## 4. Configuración del entorno de desarrollo

El proyecto fue desarrollado en Windows 11 Pro de 64 bits.

Flutter fue instalado en:

```text
C:\src\flutter
```

El Android SDK utilizado se encuentra en:

```text
C:\Users\User\AppData\Local\Android\Sdk
```

La aplicación se desarrolló utilizando Visual Studio Code como editor y Android Studio para la configuración del SDK y del emulador Android.

## 5. Verificación de Flutter

Después de instalar Flutter se verificó la configuración del entorno utilizando:

```powershell
flutter --version
```

También se utilizó el comando de diagnóstico:

```powershell
flutter doctor -v
```

Este comando permitió comprobar la instalación de Flutter, Dart, Android Studio, Android SDK y las herramientas necesarias para ejecutar la aplicación.

Para comprobar los dispositivos disponibles se utilizó:

```powershell
flutter devices
```

El dispositivo virtual utilizado durante las pruebas fue:

```text
emulator-5554
```

correspondiente al emulador Android configurado para el proyecto.

## 6. Configuración de Android Studio y Android SDK

Android Studio se utilizó para instalar y administrar las herramientas necesarias para ejecutar la aplicación Flutter en Android.

El Android SDK se configuró en:

```text
C:\Users\User\AppData\Local\Android\Sdk
```

Entre las herramientas utilizadas se encuentran:

* Android SDK Platform-Tools
* Android SDK Build-Tools
* Android SDK Platform
* Android Emulator

El dispositivo virtual utilizado para las pruebas corresponde a Android 17, API 37.

Para verificar que Flutter reconoce correctamente el dispositivo se ejecuta:

```powershell
flutter devices
```

## 7. Configuración del emulador

Se configuró un dispositivo virtual Android para realizar las pruebas de ParqueoSeguroApp.

El emulador utilizado fue:

```text
emulator-5554
```

La elección de un dispositivo virtual permitió desarrollar y probar la aplicación sin depender de un teléfono físico y facilitó la ejecución repetida de pruebas durante el desarrollo.

En caso de presentarse problemas con el arranque del emulador, se utilizó la opción **Cold Boot Now** desde Android Studio para realizar un arranque completo del dispositivo virtual.

## 8. Creación y configuración del proyecto Flutter

El proyecto Flutter se creó dentro de la carpeta principal del proyecto ParqueoSeguroApp.

La estructura utilizada separa la aplicación móvil del backend:

```text
ParqueoSeguroApp/
├── App/
│   ├── android/
│   ├── ios/
│   ├── lib/
│   ├── pubspec.yaml
│   └── ...
├── models/
├── routes/
├── app.py
├── config.py
├── extensions.py
├── requirements.txt
└── README.md
```

La aplicación Flutter se encuentra en la carpeta `App`.

Para crear un proyecto Flutter se utilizó:

```powershell
flutter create --project-name parqueo_seguro_app .
```

Para instalar las dependencias del proyecto:

```powershell
flutter pub get
```

Para analizar el proyecto:

```powershell
flutter analyze
```

## 9. Ejecución de la aplicación

Con el emulador iniciado se ejecuta la aplicación mediante:

```powershell
flutter run -d emulator-5554
```

También se puede utilizar:

```powershell
flutter run
```

cuando Flutter detecta automáticamente un dispositivo disponible.

Durante el desarrollo se utilizó la recarga en caliente de Flutter para visualizar cambios en la interfaz sin tener que reiniciar completamente la aplicación.

## 10. Estructura de la aplicación móvil

La aplicación Flutter se encuentra principalmente dentro de:

```text
App/lib/
```

Entre los archivos principales se encuentran:

```text
main.dart
api_service.dart
```

Las pantallas de la aplicación se encuentran organizadas en:

```text
App/lib/screens/
```

Entre las principales pantallas se encuentran:

```text
inicio_screen.dart
login_screen.dart
registro_screen.dart
home_screen.dart
vehiculos_screen.dart
parqueaderos_screen.dart
zonas_screen.dart
reservas_screen.dart
```

Esta organización permite separar la interfaz de cada funcionalidad de la aplicación.

## 11. Funcionalidad de inicio de sesión y registro

La aplicación permite registrar nuevos usuarios y posteriormente iniciar sesión.

El registro utiliza:

```http
POST /auth/registro
```

El inicio de sesión utiliza:

```http
POST /auth/login
```

Cuando el inicio de sesión es correcto, el backend genera un token JWT que posteriormente se utiliza para acceder a las funcionalidades protegidas.

La autenticación permite identificar al usuario que realiza las operaciones sobre vehículos y reservas.

## 12. Gestión de vehículos

La aplicación permite que cada usuario administre sus vehículos.

Las operaciones implementadas son:

```http
GET /vehiculos/
POST /vehiculos/
PUT /vehiculos/{id}
DELETE /vehiculos/{id}
```

Desde la aplicación se puede agregar un vehículo indicando información como la placa y la marca o modelo.

También es posible editar y eliminar los registros.

Los cambios realizados desde Flutter son almacenados en MySQL mediante el backend.

## 13. Gestión de parqueaderos

La aplicación permite consultar los parqueaderos registrados en la base de datos.

El endpoint utilizado es:

```http
GET /parqueaderos/
```

La información puede incluir:

* Nombre del parqueadero.
* Dirección.
* Capacidad.
* Tarifa por hora.
* Información de ubicación.

Durante las pruebas se utilizó un parqueadero denominado **Centro Quito**, ubicado en la Av. 10 de Agosto, con una capacidad configurada de 50 espacios y una tarifa de $1.50 por hora.

## 14. Zonas de estacionamiento

Las zonas representan las plazas disponibles dentro de un parqueadero.

Las zonas se almacenan en la tabla:

```text
zonas_parqueo
```

Cada zona tiene información como:

* Identificador de zona.
* Parqueadero al que pertenece.
* Código de plaza.
* Estado.

Ejemplo de código de plaza:

```text
A01
```

El estado permite determinar si una zona se encuentra:

```text
Disponible
Ocupado
```

El endpoint utilizado para consultar las zonas es:

```http
GET /zonas/
```

Cuando se realiza correctamente una reserva, la zona correspondiente cambia a estado `Ocupado`.

## 15. Gestión de reservas

La funcionalidad de reservas permite seleccionar una zona disponible y asociarla a un vehículo del usuario.

Para realizar una reserva se utilizan datos como:

* Vehículo.
* Zona.
* Fecha.
* Hora de inicio.
* Hora de finalización.
* Monto total.

El endpoint utilizado es:

```http
POST /reservas/
```

Para consultar las reservas del usuario:

```http
GET /reservas/
```

Para cancelar una reserva se utiliza el endpoint correspondiente a la reserva seleccionada:

```http
DELETE /reservas/{id_reserva}
```

Cuando una reserva es cancelada, la zona vuelve a estar disponible.

## 16. Validación de las reservas

Antes de crear una reserva, el backend comprueba que la zona exista y que se encuentre disponible.

Si la zona ya está ocupada, la reserva no se crea.

Cuando la reserva se registra correctamente, el estado de la zona se actualiza a:

```text
Ocupado
```

Esto evita que una misma plaza pueda ser reservada nuevamente mientras se encuentre ocupada.

## 17. Cálculo de la reserva

El monto total se obtiene considerando la tarifa por hora y la duración seleccionada.

Por ejemplo, para una tarifa de $1.50 por hora y una reserva de 3 horas:

```text
3 × $1.50 = $4.50
```

La aplicación utiliza la hora de inicio y la hora de finalización seleccionadas para determinar la duración de la reserva.

## 18. Backend de ParqueoSeguroApp

El backend se desarrolló con Python y Flask.

Su función es recibir las solicitudes de la aplicación móvil, procesar la información, aplicar las reglas de negocio y comunicarse con MySQL.

El archivo principal es:

```text
app.py
```

Las rutas se encuentran organizadas en:

```text
routes/
```

Los modelos de la base de datos se encuentran en:

```text
models/
```

## 19. Modelos del backend

Los principales modelos implementados son:

```text
models/usuario.py
models/vehiculo.py
models/parqueadero.py
models/zona.py
models/reserva.py
```

Estos modelos representan las entidades principales utilizadas por la aplicación.

## 20. Rutas del backend

Las rutas están organizadas de acuerdo con cada funcionalidad:

```text
routes/auth.py
routes/vehiculo.py
routes/parqueadero.py
routes/zona.py
routes/reserva.py
```

Esta organización permite mantener separadas las operaciones de autenticación, vehículos, parqueaderos, zonas y reservas.

## 21. Configuración del backend Python

Se utiliza un entorno virtual para instalar las dependencias del backend.

Para crear el entorno virtual:

```powershell
python -m venv venv
```

Para activarlo en PowerShell:

```powershell
.\venv\Scripts\Activate.ps1
```

Una vez activado se instalan las dependencias:

```powershell
pip install -r requirements.txt
```

El backend se inicia mediante:

```powershell
python app.py
```

El servidor Flask utiliza el puerto:

```text
5000
```

## 22. Base de datos

ParqueoSeguroApp utiliza MySQL como sistema de gestión de base de datos.

La base de datos utilizada es:

```text
parqueoseguro
```

La administración se realizó mediante XAMPP y phpMyAdmin.

Para trabajar con la base de datos se inicia el servicio MySQL desde XAMPP.

Las principales tablas utilizadas son:

```text
usuarios
vehiculos
parqueaderos
zonas_parqueo
reservas
```

## 23. Relación de los datos

La información se encuentra relacionada de acuerdo con las funcionalidades de la aplicación.

Un usuario puede tener varios vehículos.

Un usuario puede realizar varias reservas.

Una reserva se relaciona con un vehículo y una zona.

Una zona pertenece a un parqueadero.

Esta estructura permite consultar la información correspondiente al usuario autenticado y mantener relacionadas las reservas con los espacios de estacionamiento.

## 24. Comunicación entre Flutter y Flask

La aplicación móvil se comunica con el backend mediante solicitudes HTTP y respuestas en formato JSON.

La comunicación se centraliza en:

```text
App/lib/api_service.dart
```

La URL base utilizada desde el emulador Android es:

```text
http://10.0.2.2:5000
```

Se utiliza `10.0.2.2` porque el emulador Android necesita esta dirección para acceder al servidor que está ejecutándose en el computador anfitrión.

El backend Flask se ejecuta en el computador mediante:

```text
python app.py
```

y Flutter se comunica con él mediante la URL configurada en `ApiService`.

## 25. URL base de la API

La URL base utilizada por la aplicación es:

```text
http://10.0.2.2:5000
```

A partir de esta dirección se construyen las solicitudes a los diferentes endpoints.

Por ejemplo:

```text
http://10.0.2.2:5000/auth/login
http://10.0.2.2:5000/vehiculos/
http://10.0.2.2:5000/parqueaderos/
http://10.0.2.2:5000/zonas/
http://10.0.2.2:5000/reservas/
```

La aplicación utiliza una única URL base para facilitar la comunicación con el backend.

## 26. Variables de entorno y configuración

La configuración del backend utiliza variables de entorno para evitar colocar directamente información sensible dentro del código.

El proyecto utiliza un archivo `.env` para los datos de configuración local.

Los valores relacionados con la conexión a MySQL y las claves utilizadas por la autenticación deben mantenerse fuera del repositorio cuando contienen información real.

La configuración de la aplicación móvil utiliza la dirección del backend correspondiente al entorno de ejecución.

## 27. Autenticación y seguridad

La autenticación se implementó utilizando JWT mediante `Flask-JWT-Extended`.

Después del inicio de sesión, el token recibido se utiliza en las solicitudes que requieren autenticación.

Las solicitudes protegidas utilizan el encabezado:

```text
Authorization: Bearer TOKEN
```

Las contraseñas se protegen mediante `bcrypt` antes de almacenarse en la base de datos.

También se utiliza `Flask-CORS` para permitir la comunicación entre la aplicación Flutter y la API Flask.

## 28. Optimización del backend

Como parte del desarrollo del proyecto se implementó caché utilizando `Flask-Caching`.

La configuración utiliza `SimpleCache` y un tiempo de caché de 60 segundos para las consultas configuradas.

También se trabajó en la organización de los modelos y consultas para evitar consultas innecesarias a la base de datos.

## 29. Prueba de comunicación con la API

La comunicación entre Flutter y el backend se comprobó utilizando los endpoints de la propia API.

Primero se inicia MySQL desde XAMPP.

Después se inicia Flask:

```powershell
python app.py
```

Luego se ejecuta el emulador Android y la aplicación:

```powershell
flutter run -d emulator-5554
```

Desde la aplicación se realizan solicitudes al backend utilizando la URL:

```text
http://10.0.2.2:5000
```

La respuesta recibida por Flutter se procesa y se utiliza para mostrar la información correspondiente en la interfaz.

También se utilizó Postman para comprobar individualmente los endpoints antes de utilizarlos desde Flutter.

## 30. Pruebas realizadas con Postman

Se realizaron pruebas de los principales endpoints:

```text
POST /auth/registro
POST /auth/login
GET /vehiculos/
POST /vehiculos/
PUT /vehiculos/{id}
DELETE /vehiculos/{id}
GET /parqueaderos/
GET /zonas/
POST /reservas/
GET /reservas/
DELETE /reservas/{id_reserva}
```

Las respuestas obtenidas fueron verificadas antes de integrarlas con las pantallas correspondientes de Flutter.

## 31. Verificación de datos en phpMyAdmin

Además de las pruebas realizadas desde Flutter y Postman, se verificaron los datos directamente desde phpMyAdmin.

Se comprobó la existencia de registros en:

```text
usuarios
vehiculos
parqueaderos
zonas_parqueo
reservas
```

También se verificó el cambio de estado de una zona después de realizar una reserva y su liberación después de cancelar la reserva.

## 32. Comandos utilizados durante el desarrollo

### Flutter

```powershell
flutter --version
flutter doctor -v
flutter devices
flutter create --project-name parqueo_seguro_app .
flutter pub get
flutter analyze
flutter run -d emulator-5554
```

### Python y Flask

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py
```

### Git

```powershell
git status
git add .
git commit -m "Actualización del proyecto"
git push
```

## 33. Solución de problemas durante la configuración

Durante la configuración se presentaron algunos problemas relacionados con el emulador y la comunicación entre Flutter y Flask.

Para problemas de inicio del emulador se utilizó la opción **Cold Boot Now** desde Android Studio.

Para problemas de conexión entre Flutter y Flask se verificó que:

1. MySQL estuviera ejecutándose desde XAMPP.
2. Flask estuviera ejecutándose mediante `python app.py`.
3. El backend utilizara el puerto 5000.
4. Flutter utilizara `10.0.2.2` en lugar de `localhost`.
5. El emulador estuviera correctamente iniciado.

Cuando una solicitud devolvía HTML en lugar de JSON, se revisó la dirección del endpoint y la configuración de las rutas del backend.

## 34. Estructura funcional de ParqueoSeguroApp

La aplicación está organizada alrededor de las siguientes funcionalidades:

**Autenticación:** permite registrar usuarios e iniciar sesión.

**Vehículos:** permite agregar, consultar, editar y eliminar vehículos.

**Parqueaderos:** permite consultar los parqueaderos registrados.

**Zonas disponibles:** permite consultar las plazas de cada parqueadero y conocer si están disponibles u ocupadas.

**Reservas:** permite seleccionar un vehículo, una zona, una fecha y un horario para realizar una reserva.

**Mis reservas:** permite consultar las reservas asociadas al usuario autenticado y gestionar su cancelación.

## 35. Flujo de ejecución del proyecto

Para ejecutar todo el sistema correctamente se debe:

1. Iniciar XAMPP.
2. Activar MySQL.
3. Comprobar que exista la base de datos `parqueoseguro`.
4. Activar el entorno virtual de Python.
5. Ejecutar `python app.py`.
6. Iniciar el emulador Android.
7. Verificar el dispositivo con `flutter devices`.
8. Ejecutar `flutter run -d emulator-5554`.
9. Iniciar sesión o registrar un usuario.
10. Probar las funcionalidades de la aplicación.
