# Első beadandó feladat.
- A "Vakcin-áció" keretében kérni kell a hatóságoktól az oltást. Ezt a megfelelő adatok megadásával tudjuk megtenni. A megszaporodott igények szerint nem elég a telefonos igényfelvétel, így egy alkalmazás segíti az ügyfelek igényeinek rögzítését.

- A jelentkezés során meg kell adni a páciens `nevét`, `évszámát` és `telefonszámát`. Ezen alapadatok mellett tudja megjelölni azt, hogy az ingyenes szolgáltatás helyett vállalja a `fizetős felárat` is.  (Például: `Vakci Áci, 1953, 36301234567, igen` )

- A jelentkezők adatokat `fájlban` tároljuk, az `adatfelvételen` túl legyen lehetőségünk az adatokon `módosítani`, `törölni` vagy `teljes listát készíteni`.

- Készítsen C nyelvű programot ami  ezt a feladatot megoldja, a megoldásnak vagy az opsys.inf.elte.hu kiszolgálón, vagy egy hozzá hasonló rendszeren kell futnia. A megoldást a beadási határidőt követő héten be kell mutatni a gyakorlatvezetőnek.

- A forrásállományt vagy állományokat okat itt töltsék fel .c vagy .zip formában.

Beadási határidő: 2021  április 6. 

## Használat
A program indítása után egy parancssor szerű felületet kapunk ahol:
- close: program bezárása és adatok mentése
- list: adatok listázása
- add \<rec\> : új adat felvétele (nincs ellenörzés)
- remove \<id\> : adat törlése
- update \<id\> \<rex\> : adat módisítása (nincs ellenörzés)

## Teszt esetek
- [X] Nincs alapfájl
- [X] van alapfájl
- [X] Üres adattömb mentése
- [X] Felhasználó felvétele
- [X] Egy "nem utolsó" felhasználó törlése
- [X] Egy "utolsó" felhasználó törlése
- [X] Egy felhasználó módosítása
- [X] Üres adattömb listázása
- [X] Adattömb listázása