# Seminarski rad iz kursa: Verifikacija softvera  

## Autor  
- Ime i prezime: **Dimitrije Marković**  
- Broj indeksa: **1022/24**  
- Kontakt: **dimitrijedidamarkovic@gmail.com**  

---

## Opis projekta  
Projekat koji je analiziran: **Online Shopping System**  
- Link do izvornog koda: [GitHub Repository](https://github.com/saad0510/online-shopping-system)  
- Grana: `main`  
- Commit hash: `1934f74`  

### Kratak opis  
**Online Shopping System** je **C++ konzolna aplikacija** koja implementira jednostavan sistem za online kupovinu korišćenjem principa objektno-orijentisanog programiranja. Projekat se sastoji iz dva glavna dela:  

1. **Networking layer** – omogućava komunikaciju između klijenta i servera korišćenjem Winsock2 biblioteke (Windows API za socket i threading).  
2. **Management layer** – koristi mrežni sloj za implementaciju funkcionalnosti aplikacije za online kupovinu.  

Glavne funkcionalnosti uključuju:  
- Registraciju i prijavu korisnika.  
- Kupovinu proizvoda uz prikaz računa i mogućnost izmene porudžbine.  
- Podnošenje i rešavanje žalbi.  
- Različite privilegije za kupce, zaposlene i administratore (popusti, upravljanje nalozima, pregled inventara, automatske i manuelne porudžbine).  

---

## Korišćeni alati za analizu  

U okviru ovog seminarskog rada korišćeni su sledeći alati:  

---

### 1. **Clang-Tidy (statička analiza)**  
Clang-Tidy je alat za **statičku analizu C++ koda**. Omogućava otkrivanje potencijalnih problema pre samog izvršavanja programa, kao što su:  
- Neinicijalizovane promenljive.  
- Potencijalni memory leak-ovi.  
- Pogrešno korišćenje pokazivača.  

U okviru projekta Clang-Tidy je korišćen za analizu **Server** i **Client** direktorijuma, sa ciljem da se otkriju greške i da se kôd unapredi u skladu sa modernim C++ praksama.  

#### Instalacija (Windows)  
1. Preuzeti LLVM paket sa zvanične stranice: [https://releases.llvm.org](https://releases.llvm.org).  
2. Tokom instalacije obavezno uključiti **Clang Tools**.  
3. Dodati putanju do `clang-tidy.exe` u sistemsku promenljivu **PATH**.  
4. (Opcionalno) instalirati [Pandoc](https://pandoc.org/installing.html) radi konverzije `.txt` izveštaja u HTML.  

#### Korišćenje  
U projektu je dostupna skripta `run_clang_tidy.bat` koja automatizuje pokretanje alata. Skripta:  
- Rekurzivno analizira sve `.cpp` i `.h` fajlove u folderima **Server** i **Client**.  
- Generiše tekstualni izveštaj `clang_tidy_report.txt`.  
- Konvertuje izveštaj u HTML format (`clang_tidy_report.html`) pomoću **Pandoc** alata.  

Pokretanje analize:  
```bash
run_clang_tidy.bat
```

### 2. **Cppcheck (statička analiza)**  
Cppcheck je alat za **statičku analizu C/C++ koda**. Fokusira se na otkrivanje logičkih grešaka koje kompajler često ne prijavljuje, kao što su:  
- Neinicijalizovani članovi i promenljive.  
- Potencijalna prekoračenja bafera.  
- Neiskorišćene promenljive i mrtav kod.  
- Problemi sa stilom i kompleksnošću koda.  

#### Instalacija (Windows)  
1. Preuzeti binarni paket sa zvanične stranice: [https://cppcheck.sourceforge.io](https://cppcheck.sourceforge.io).  
2. Raspakovati arhivu i dodati folder sa `cppcheck.exe` u **PATH**.  
3. (Opcionalno) instalirati **Cppcheck GUI** ili koristiti eksterne alate za konverziju XML izveštaja u HTML (npr. `cppcheck-htmlreport`).  

#### Korišćenje  
U projektu postoji skripta `run_cppcheck.bat` koja automatski pokreće analizu:  
- Analiziraju se direktorijumi **Server** i **Client**.  
- Koristi se standard **C++17** i opcije:  
  - `--enable=all` – uključuje sve provere.  
  - `--inconclusive` – prikazuje i potencijalne probleme.  
  - `--force` – omogućava proveru i u složenijim projektima.  
- Rezultat se snima u XML fajl `cppcheck_results.xml`.  

Pokretanje analize:  
```bash
run_cppcheck.bat
```

### 3. **Doxygen (generisanje dokumentacije)**  
Doxygen je alat koji omogućava **automatsko generisanje dokumentacije** iz komentara unutar izvornog koda.  
Dokumentacija može biti generisana u **HTML** i **LaTeX/PDF** formatu i sadrži:  
- Spisak klasa, funkcija i metoda.  
- Hijerarhiju nasleđivanja.  
- Dijagrame poziva (uz Graphviz).  

#### Instalacija (Windows)  
1. Preuzeti instalacioni fajl sa zvanične stranice: [https://www.doxygen.nl/download.html](https://www.doxygen.nl/download.html).  
2. Instalirati Doxygen (GUI + CLI).  
3. (Opcionalno) preuzeti i instalirati **Graphviz** sa [https://graphviz.org/download/](https://graphviz.org/download/) za generisanje dijagrama klasa i poziva.  
4. Dodati `doxygen.exe` i `dot.exe` (iz Graphviz-a) u **PATH**.  

#### Konfiguracija  
1. Generisati osnovni konfiguracioni fajl komandom:  
   ```bash
   doxygen -g Doxyfile
   ```
#### Pokretanje  
Nakon podešavanja `Doxyfile`, alat se pokreće komandom:  
```bash
doxygen Doxyfile
```
### 4. **Dr. Memory (dinamička analiza memorije)**  
**Dr. Memory** je alat za analiziranje problema sa memorijom na Windows-u: curenja (`LEAK`), korišćenje neinicijalizovane memorije, invalidne pristupe (`INVALID read/write`), korišćenje nakon oslobađanja (`use-after-free`), dvostruko oslobađanje, itd.

#### Instalacija (Windows)
1. Preuzeti poslednju verziju sa: https://drmemory.org (ZIP/installer).
2. Raspakovati i dodati `…\DrMemory\bin` (ili `bin64` za 64-bit) u **PATH** (System Environment Variables).

#### Struktura logova
Na nivou repozitorijuma čuvamo:
- `ClientLogs/` i `ServerLogs/` — **samo**:
  - `results.txt` – kompletan Dr. Memory izlaz,
  - `potential_errors.txt` – filtrirane sumnjive linije (ERROR/LEAK/INVALID…).

#### Pokretanje iz **Git Bash** (Windows)
> U nastavku su komande koje možemo **direktno** pokrenuti iz Git Bash-a.  

**Server:**
```bash
# 1) Kreiraj folder za logove
mkdir ServerLogs

# 2) Pokreni Dr. Memory nad serverom i snimi kompletan izlaz
drmemory.exe -- ./serverProgram.exe 1> ServerLogs/results.txt 2>&1
```

**Client:**
```bash
# 1) Kreiraj folder za logove
mkdir ClientLogs

# 2) Pokreni Dr. Memory nad klijentom i snimi kompletan izlaz
drmemory.exe -- ./clientrProgram.exe 1> ClientLogs/results.txt 2>&1
```
### 5. **Very Sleepy Profiler (profilisanje performansi)**  
**Very Sleepy** je lagani **sampling** profiler za Windows koji meri potrošnju CPU-a i prikazuje koje funkcije najviše doprinose vremenu izvršavanja. Idealan je za C/C++ aplikacije (sa PDB simbolima), ali se može koristiti i za druge exe-ove na Windows-u.

#### Instalacija (Windows)
1. Preuzmi poslednji release sa GitHub-a: `VerySleepy.exe` (portabilan; nije potrebna instalacija).
2. (Opcionalno) Instaliraj **QCachegrind** (Windows port) ako želiš vizuelnu analizu `.callgrind` fajlova:
   - QCachegrind (Windows) → instalacija i pokretanje `qcachegrind.exe`.

> Napomena: Very Sleepy **profiliše jedan proces po instanci** (prati sve **thread-ove** tog procesa), **ne prati automatski child procese**. Za klijent i server radi analizu **odvojeno**.

---

#### Korišćenje (GUI – pokretanje exe-a)
1. Pokreni `VerySleepy.exe`.  
2. **File → New Profile** → izaberi `clientProgram.exe` ili `serverProgram.exe`.  
3. Pokreni **workload** (login, kupovina, slanje zahteva, itd.) i pusti da traje **30–120 s** (dovoljno uzoraka).  
4. Klikni **Stop Profiling** → sačuvaj rezultat (`.vsp`) ili eksportuj kao **Callgrind** (vidi dole).  
5. Ponovi postupak za drugi exe (npr. klijent → server).

#### Korišćenje (GUI – attach na već pokrenut proces)
1. Pokreni aplikaciju (klijent ili server) kako bi već radila.  
2. U Very Sleepy: **File → Attach to Process** → izaberi proces po imenu ili PID-u → **Attach**.  
3. Pusti workload, zatim **Stop Profiling** i sačuvaj izveštaj.

---

#### Eksport rezultata i vizualizacija (Callgrind + QCachegrind)
- U Very Sleepy: **File → Export → Callgrind** → npr. `client_callgrind.out`, `server_callgrind.out`.  
- Analiza u **QCachegrind**:
  - Otvori `qcachegrind.exe` → **File → Open** → izaberi `.out` fajl.
  - Pogledi: **Flat Profile** (top funkcije po Self/Inclusive time), **Call Tree**, **Call Graph**.

---

#### Preporučena metodologija (za tvoj projekat)
- Profiliši **odvojeno**:
  - `serverProgram.exe` → workload: prihvat konekcija, obrada zahteva, slanje odgovora.
  - `clientProgram.exe` → workload: login, pretraga, kupovina/checkout.
- Snimi po jedan **.vsp** i/ili **.callgrind** fajl za svaki.  
- Za konzistentnost, koristi istu dužinu profilisanja i isti scenario na oba.

---

#### (Opcionalno) CLI varijanta
Neka izdanja dolaze i sa `verysleepy_cli.exe`. Ako ga imaš u paketu:
```bash
# Primer (Git Bash / CMD)
verysleepy_cli.exe --exe "C:\putanja\do\clientProgram.exe" --args "" --out "client_profile.vsp"
verysleepy_cli.exe --exe "C:\putanja\do\serverProgram.exe" --args "" --out "server_profile.vsp"
```
