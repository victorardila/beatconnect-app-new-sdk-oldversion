# Nuevo SDK de BeatConnect Versión anterior

Un nuevo proyecto de Flutter.

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

Se eliminaron los siguientes archivos y carpetas, ya que no eran necesarios para el correcto funcionamiento del proyecto en Flutter:

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

## Estructura del repositorio actual

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
