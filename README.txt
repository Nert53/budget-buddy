----- Návod pro zprovoznění softwaru Budget Buddy -----

V tomto návodu je popsán postup, jak zprovoznit již přeložený software na 2
platformách - Windows a Android. Nejedná se tedy o postup jak daný software
ze zdrojového kódu sestavit a přeložit.
Soubory nutné ke spuštění se nechází v adresáři '\bin'.

--- Platforma Windows ---
1.  Jako referenční prostředí je použit Windows 10 Pro jako je uvedeno na
    stránkách katedry informatiky. Je nutné ještě nainstalovat nejnovější běhové
    knihovny Microsoft Visual C++ (dostupné na tomto odkaze learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist).
2.  Ostatní potřebné soubory se nachází v adresáři '\windows'.
3.  Stačí spustit soubor s názvem 'personal_finance.exe', který otevře aplikaci.

--- Platforma Android ---
1.  Verze Android je nutná alespoň 5.0 a vyšší.
2.  Soubor 'app-release.apk' se nachází v adresáři '\android'.
3.  Před samotnou instalací je nutné provést změnu v nastavení mobilního
    telefonu, jelikož se nejedná o distribuci skrz obchod Play Store. 
    V 'nastavení -> aplikace -> přístup ke speciálním aplikacím -> instalace neznámých apliakcí'
    je nutné povolit zdroj, ze kterého se bude aplikace instalovat (obvykle se 
    jedná o aplikaci typu průzkumník souborů).
4.  Na různých nádstavbách podle výrobce se postup může mírně lišit.
5.  Poté už stačí soubor 'app-release.apk' otevří a projít instalačním procesem.