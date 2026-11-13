# GemStore — Laboratorul 3

Continuarea aplicației din `PAM/lab2/gemstore`. În lab3 sunt păstrate structura și stilul interfeței realizate pentru lab2: Home cu categorii, banner, Feature Products, NEW COLLECTION, Recommended, Top Collection și pagina de detalii cu galerie, selecții și secțiuni extensibile. Codul original din lab2 rămâne în folderul său.

Listele `mockProducts`, `recommendedProducts` și recenziile demonstrative au fost înlocuite cu modelele citite din `lab v1.json`. Datele pentru bannere și colecții provin, de asemenea, din acest fișier.

## Pornire

Din directorul `PAM/lab3`:

```sh
flutter pub get
flutter run -d chrome
```

Pentru Android, pornește un emulator sau conectează telefonul cu USB debugging și rulează `flutter run`. Dispozitive disponibile: `flutter devices`.

## Cerințe implementate

| Cerință | Implementare |
| --- | --- |
| Package de state management | `flutter_bloc`, `CatalogCubit` și `BlocBuilder` |
| Date JSON locale, încărcate asincron | Asset declarat în pubspec, `rootBundle.loadString`, `Future<Catalog>`, `async/await` |
| Loading | Indicator în timpul citirii catalogului |
| Success | Home și catalogul cu 8 produse |
| Empty | Catalog gol, căutare fără rezultate sau lipsa favoritelor |
| Error | Capturarea erorilor de citire/parsare și buton Retry |
| Căutare | După nume, fără diferență între litere mari și mici |
| Filtrare | Toate, selecția principală, recomandate, produse similare; opțiune Favorites only |
| Sortare | Implicită, preț crescător/descrescător și nume A–Z |
| Favorite | Adăugare/eliminare din card și detalii; listă filtrată de favorite |
| Navigare la detalii | Din Home, catalog și lista Similar Product |
| Componente reutilizabile | Card vertical/orizontal, imagine cu fallback, buton favorite, bannere, categorii, panou Empty/Error |
| Arhitectură modulară | Modele, repository, Cubit, ecrane și widgeturi |

## Cum se folosește

- Pagina Home păstrează secțiunile din lab2.
- Butonul din stânga sus sau Browse all products deschide catalogul cu căutare, filtre și sortare.
- Show all deschide catalogul pentru grupul corespunzător.
- Inima din dreapta sus deschide favoritele.
- Inima dintr-un card sau de pe pagina produsului modifică aceeași stare Cubit.
- Pull-to-refresh și Reload recitesc JSON-ul. La reîncărcarea reușită, filtrele și favoritele curente sunt păstrate.
- Sportwear Set are date complete: galerie, culori, mărimi (S și M indisponibile), descriere, evaluări și recenzii.
- Add To Cart adaugă produsul și variantele selectate într-un coș simplu în memorie și afișează confirmarea cu numărul de articole. Nu există checkout.

JSON-ul nu asociază produsele cu Women/Men/Accessories/Beauty. Acestea sunt păstrate ca elemente vizuale pe Home; filtrarea funcțională folosește grupurile reale ale sursei. Nu sunt inventate categorii sau recenzii pentru produsele care au numai informații de bază.

Favoritele și coșul sunt păstrate în memoria sesiunii și se resetează la repornirea aplicației. Datele sunt locale; imaginile necesită internet și au un substituent dacă descărcarea eșuează.

## Organizarea codului

```text
lib/
  main.dart                       # punct de intrare
  app.dart                        # temă și BlocProvider global
  models/catalog.dart             # modele și conversie JSON
  models/product.dart             # export pentru widgeturile preluate din lab2
  data/catalog_repository.dart    # citire asincronă asset și parsare JSON
  cubit/catalog_cubit.dart         # Loading/Success/Empty/Error și operații
  screens/home_screen.dart        # Home adaptat din lab2
  screens/catalog_screen.dart     # căutare, filtre, sortare, favorite
  screens/product_detail.dart     # detalii adaptate din lab2
  widgets/product_card.dart       # cardurile din lab2 și imagine reutilizabilă
  widgets/favorite_button.dart    # favorite prin Cubit
  widgets/collection_banner.dart  # banner reutilizabil extras din Home
  widgets/store_categories.dart   # categoriile vizuale din lab2
  widgets/status_panel.dart       # Empty / Error cu acțiune
```

## Explicație pentru prezentare

`BlocProvider` creează o instanță `CatalogCubit` deasupra `MaterialApp`, disponibilă pe toate rutele. La pornire, `load()` emite Loading și așteaptă repository-ul. Acesta citește assetul JSON și construiește modele tipizate. Cubit emite Success, Empty sau Error; `BlocBuilder` actualizează interfața.

Căutarea, filtrarea și sortarea se aplică împreună asupra catalogului, fără modificarea listei originale. Favoritele folosesc ID-urile produselor și se sincronizează între ecrane. Colecțiile stării sunt nemodificabile. Cererile de încărcare simultane sunt ignorate.

Imaginea selectată, culoarea, mărimea și deschiderea secțiunilor de detalii rămân stare locală de interfață prin `setState`. Datele partajate sunt în Cubit. Coșul minimal este păstrat în Cubit și se confirmă prin SnackBar.

## Verificare

```sh
flutter analyze
flutter test --concurrency=1 --no-enable-impeller
flutter build web
```

Testele verifică JSON-ul real, încărcarea/stările Cubit, combinarea filtrelor, sortarea, favoritele, navigarea, mărimile indisponibile, adăugarea în coș și layoutul pe un ecran de 320 px.

Pentru demonstrație: deschide Show all, caută `crop`, sortează după preț, adaugă o favorită și verifică lista Favorites. Deschide Sportwear Set pentru galerie și recenzii. Caută un nume inexistent pentru Empty. Loading este scurt deoarece JSON-ul este local. Pentru Error există un test cu JSON invalid; în demonstrație poate fi modificat temporar JSON-ul, urmat de repornirea aplicației, apoi restaurat.
