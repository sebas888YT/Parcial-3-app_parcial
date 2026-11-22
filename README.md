<div align="center">

# ReelUp — App parcial

Aplicación Flutter para autenticación con Firebase y un feed vertical de videos.

**Autor: Sebastián Herrera**

</div>

## Funcionalidades

- Registro con nombre, correo y contraseña; el nombre se guarda en Firebase Authentication.
- Inicio de sesión con correo y contraseña, Google y Facebook.
- Rutas `/login`, `/registro` y `/feed` protegidas según el estado de sesión.
- Feed de cuatro videos verticales con reproducción automática, pausa al tocar y controles de interacción.
- Cierre de sesión mostrando el nombre o correo del usuario.

## Ejecutar

Requiere Flutter y Dart compatibles con las versiones declaradas en `pubspec.yaml`.

```powershell
flutter pub get
flutter run
```

La aplicación está conectada al proyecto Firebase `parcial-6115a`. Habilita correo/contraseña, Google y Facebook en **Firebase Authentication → Sign-in method**.

## Evidencias

Se agregarán capturas o un video corto que demuestre registro, los tres métodos de inicio de sesión y el feed. Antes de publicarlos, hay que asegurarse de que no muestren contraseñas, códigos de verificación, correos privados ni rutas locales.

## Videos

Los cuatro clips se transmiten desde Pexels y requieren conexión a Internet. Cada video muestra un enlace a su fuente:

- [Video Pexels 6292467](https://www.pexels.com/download/video/6292467/)
- [Video Pexels 7273908](https://www.pexels.com/download/video/7273908/)
- [Video Pexels 12902487](https://www.pexels.com/download/video/12902487/)
- [Video Pexels 7583538](https://www.pexels.com/download/video/7583538/)

Los enlaces directos utilizados están en [`videos/links.txt`](videos/links.txt). La carpeta conserva `.gitkeep` y el TXT, mientras que los archivos de video locales se excluyen mediante `.gitignore`.


## Validación

```powershell
flutter analyze
flutter test
```
