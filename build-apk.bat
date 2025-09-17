@echo off
echo Construyendo HeartWise APK...

echo Limpiando proyecto...
flutter clean

echo Obteniendo dependencias...
flutter pub get

echo Construyendo APK de release...
flutter build apk --release

echo Copiando APK con nombre personalizado...
copy "build\app\outputs\flutter-apk\app-release.apk" "build\app\outputs\flutter-apk\heartwise-installer-v1.0.0-release.apk"

echo.
echo ✓ APK construido exitosamente:
echo   - Archivo original: build\app\outputs\flutter-apk\app-release.apk
echo   - Archivo renombrado: build\app\outputs\flutter-apk\heartwise-installer-v1.0.0-release.apk
echo.
echo ¡Build completado!
pause