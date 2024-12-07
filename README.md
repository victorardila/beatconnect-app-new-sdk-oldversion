# Nuevo SDK de BeatConnect Versión `MVP(Producto Minimo Viable)`

Aplicación inicial de BeatConnect, una red social que conecta usuarios con gustos musicales similares para explorar establecimientos nocturnos. Incluye un módulo básico de ubicación para encontrar sitios en el área metropolitana. Versión MVP diseñada para validación de concepto.

<p align="center">
  <img src="https://github.com/user-attachments/assets/33d03376-f4b0-4655-a650-2d0aed790f76" alt="logo" width="500"/>
</p>

## Stack de Tecologia

<p align="center">
  <img src="https://github.com/user-attachments/assets/270667a7-40ad-4267-9d33-478aca7e2bbf" alt="flutter firebase" width="500"/>
</p>

## Primeros pasos

Este proyecto es un punto de partida para una aplicación de Flutter.

Algunos recursos para comenzar si este es su primer proyecto de Flutter:

- [Laboratorio: escriba su primera aplicación de Flutter](https://docs.flutter.dev/get-started/codelab)
- [Receta: ejemplos útiles de Flutter](https://docs.flutter.dev/cookbook)

Para obtener ayuda para comenzar con el desarrollo de Flutter, consulte la
[documentación en línea](https://docs.flutter.dev/), que ofrece tutoriales,
ejemplos, orientación sobre desarrollo móvil y una referencia completa de API.

## Cambios realizados en el proyecto

Se realizaron las siguientes modificaciones para mejorar la estructura y limpieza del repositorio:

### `Eliminación de archivos innecesarios`

Se eliminaron los siguientes archivos y carpetas, ya que no eran necesarios para el correcto funcionamiento del proyecto en Flutter, Estos archivos estan a nivel raiz de proyecto lo cual noe estaba bien:

- **`gradle/:`** Carpeta relacionada con el sistema de compilación de Gradle. No es requerida en la raíz del proyecto Flutter.
- **`flutter_launcher_icons.yaml:`** Archivo de configuración para personalizar los íconos de la aplicación. Este archivo debe
ser usado solo cuando sea necesario y no forma parte de los archivos esenciales del proyecto.
- **`flutter_native_splash.yaml:`** Archivo de configuración para personalizar la pantalla de carga (splash screen). Similar al anterior, no es esencial si no está en uso.
- **`settings.gradle:`** Archivo de configuración para Gradle que no aplica a la estructura estándar de un proyecto Flutter.
- **`build.gradle:`** Otro archivo relacionado con Gradle, que no debería estar en la raíz de un proyecto Flutter.
- **`gradlew:`** Script utilizado por Gradle Wrapper. No es necesario en este contexto.

## `Motivo de los cambios`

Estos archivos y carpetas fueron eliminados para:

- Mantener una estructura limpia y organizada: La presencia de estos elementos podría generar confusión, ya que no son parte de la configuración estándar de Flutter.
- Evitar conflictos innecesarios: Al simplificar el contenido del repositorio, se reduce el riesgo de errores o malentendidos durante el desarrollo y la colaboración.

## Estructura del repositorio corregida y migrada

Después de los cambios, la estructura del repositorio es más clara y se ajusta al estándar de proyectos Flutter:

```text
/
├── android/
├── assets/
├── ios/
├── lib/
├── macos/
├── test/
├── web/
├── windows/
├── .gitattributes
├── .gitignore
├── analysis_options.yaml
├── pubspect.yaml
├── README.md
```

## Estructura del repositorio antiguo

Estructura del proyecto poco clara y no funcional:

```text
/
├── .metadata
├── analysis_options.yaml
├── android/
├── assets/
├── build.gradle
├── flutter_launcher_icons.yaml
├── flutter_native_splash.yaml
├── gradle
├── gradlew
├── gradlew.bat
├── ios/
├── lib/
├── macos/
├── test/
├── web/
├── windows/
├── .gitattributes
├── .gitignore
├── analysis_options.yaml
├── pubspect.yaml
├── README.md
├── settings.gradle
```

## Dependencias adicionales para correr el proyecto

Para garantizar que la aplicación funcione correctamente en sistemas Linux, fue necesario instalar la dependencia win32. Esto se realiza ejecutando el siguiente comando en el terminal:

```bash
flutter pub add win32
```

## Actualizacion de API (para este caso de la API 33 a la 34)

### *`Elimina cachés previos`*

A veces, los cachés dañados pueden causar problemas durante una actualización. Para limpiar el caché, ejecuta:

```bash
flutter clean
flutter pub cache repair
```

### *`Actualizar SDK a la ultima version`*

El primer comando comentado es para establecer el canal estable para actualizar el SDK. En otras palabras se escogera la version del sdk mas reciente y mas estables.

```bash
# flutter channel stable
flutter upgrade --force
```

### *`Limpiar el proyecto de android del proyecto de flutter y recrearla con la nueva version del SDK`*

SE realiza una limpieza del proyecto que consiste en una eliminacion y recreacion del proyecto android.

```bash
# Eliminar carpeta de proyecto android
rm -rf android
# Recrear la carpeta android
flutter create .
```

### *`Actualizar e instalar dependencias nuevamente post a la actualizacion del SDK`*

Para saber si hay paquetes desactualizados del proyecto primero debe ejecutar este comando para saber si hay actualizaciones de los paquetes para la nueva API, esto se hará cone ste comando:

```sh
flutter pub outdated
```

#### *IMPORTANTE(RECOMENDADO)*

Este paso se hará solo si hay paquetes desactualizados que el proyecto necesite actualizar para funcionar:

```sh
flutter pub upgrade --major-versions
```

Para instalar dependencias del proyecto de flutter lo puede realizar con el siguiente comando.

```sh
flutter pub get
```

## `Correr el proyecto (Normal)`

Ejecuta el siguiente comando para correr la aplicacion de forma normal:

```sh
flutter run
```

### `Correr el proyecto (Manejo de errores)`

Para manejar los logs de errores por consola y saber si se esta generando algun punto de inflexión en el proyecto:

```sh
flutter run --verbose
```

### Resultados

Con el comando siguiente comando podra observar los resultados de la actualizacion de la API.

```sh
flutter doctor -v
```

![SDK Actualizado](https://github.com/user-attachments/assets/6e5d8481-7625-4af6-8b34-edf08a7a0167)
