# Browser Test Guide for LC Minigames

Denne vejledning hjælper dig med at teste og udvikle dine FiveM minigames direkte i din browser, før du implementerer dem på din server.

## Hvordan man tester i browser

1. Åbn `html/browsertest.html` i din browser
2. Brug kontrolpanelet nederst på siden til at:
   - Vælge sværhedsgrad (Easy, Medium, Hard)
   - Starte et nyt spil
   - Nulstille spillet hvis nødvendigt

## Fordele ved browser-test

- **Hurtig udvikling**: Undgå at skulle genstarte din FiveM server for hver ændring
- **Lettere debugging**: Se fejl direkte i browser-konsollen (F12)
- **Reel-time ændringer**: Rediger CSS og JavaScript og se ændringerne med det samme

## Sådan fungerer det

Browser-testsystemet indeholder:

1. **browsertest.html** - En speciel version af dit UI til test i browseren
2. **browser-mock.js** - Simulerer FiveM NUI-funktionalitet
3. **browser-test.js** - Implementerer testkontroller til at starte/nulstille spillet

## Sådan implementerer du ændringer på din FiveM server

Efter du har testet og forbedret dit minigame i browseren:

1. Kopier relevante ændringer fra wheel_removal.js til din FiveM server
2. Opdater CSS styles efter behov
3. Test på din FiveM server med kommandoen `/testwheelgame`

## Brug i andre projekter

Du kan nemt tilpasse denne browser-testløsning til andre FiveM UI-projekter ved at:

1. Oprette en lignende browsertest.html fil
2. Tilpasse browser-mock.js til dit projekts behov
3. Implementere kontrolpanel funktionalitet specifik til dit projekt

## Fejlfinding

Hvis dit spil ikke fungerer korrekt i browseren:

1. Åbn browser-konsollen (F12) for at se eventuelle JavaScript fejl
2. Kontroller, at alle afhængigheder indlæses korrekt
3. Verificer, at mock-funktionerne i browser-mock.js passer til de funktioner, dit spil forventer

God fornøjelse med udviklingen af dine minigames!
