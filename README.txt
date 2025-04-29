----- Návod pro zprovoznění softwaru Budget Buddy -----

V tomto návodu je popsán postup, jak zprovoznit již přeložený software na dvou
platformách - Windows a Android. Nejedná se tedy o postup jak daný software
ze zdrojového kódu sestavit.
Soubory nutné ke spuštění se nachází v adresáři '\bin'.

--- Platforma Windows ---
1.  Jako referenční prostředí je použit Windows 10 Pro jako je uvedeno na
    stránkách katedry informatiky. Je nutné ještě nainstalovat nejnovější běhové
    knihovny Microsoft Visual C++ (dostupné na https://aka.ms/vs/17/release/vc_redist.x64.exe).
2.  Ostatní potřebné soubory se nachází v adresáři '\windows'.
3.  Stačí spustit soubor s názvem 'budget_buddy.exe', který otevře aplikaci.
4.  Responzivitu aplikace je možné vyzkoušet úpravou velikosti okna. Při nastavení
    okna na šířku mobilního telefonu se uživatelské rozhraní přizpůsobí.

--- Platforma Android ---
1.  Verze Android je nutná 5.0 a vyšší.
2.  Před samotnou instalací je nutné provést změnu v nastavení mobilního
    telefonu, jelikož se nejedná o distribuci skrz obchod Play Store. 
    V 'nastavení -> aplikace -> přístup ke speciálním aplikacím -> instalace neznámých aplikací'
    je nutné povolit zdroj, ze kterého se bude aplikace instalovat (obvykle se 
    jedná o aplikaci typu průzkumník souborů). Postup v nastavení se na různých 
    nadstavbách podle výrobce může mírně lišit.
3.  Poté už stačí v adresáři '\android' nainstalovat soubor 'budget_buddy.apk'.
    Na Androidu je celý instalační proces krátký a jednoduchý.