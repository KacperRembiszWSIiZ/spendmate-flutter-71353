# SpendMate

SpendMate to prosta aplikacja mobilna we Flutterze do zapisywania i analizowania codziennych wydatków. Aplikacja działa lokalnie, bez logowania, backendu i Firebase.

## Technologie

- Flutter
- Dart
- Provider / ChangeNotifier
- SQLite przez `sqflite`
- `image_picker`
- `fl_chart`
- `intl`
- `uuid`

## Najważniejsze funkcje

- dodawanie wydatków z nazwą, kwotą, kategorią i datą
- wybór kategorii wydatku
- opcjonalne dodawanie zdjęcia paragonu z galerii
- historia wydatków
- szczegóły wydatku
- usuwanie wydatków
- statystyki miesięczne
- wykres wydatków według kategorii
- formatowanie kwot w PLN
- polski format dat

## Dane lokalne

Dane wydatków są zapisywane lokalnie w bazie SQLite (`spendmate.db`). Aplikacja nie korzysta z backendu ani z usług chmurowych.

Zdjęcia paragonów są kopiowane do lokalnego folderu aplikacji jako pliki. W bazie SQLite zapisywana jest tylko ścieżka do zdjęcia.

## Uruchomienie

Projekt używa Fluttera przez FVM. Zalecana wersja znajduje się w pliku `.fvmrc`.

```bash
fvm flutter pub get
fvm flutter run
```

Jeżeli masz skonfigurowany globalny alias Fluttera z FVM:

```bash
flutter pub get
flutter run
```
