# LC Minigames - FiveM Wheel Removal Minigame

Dette repository indeholder et wheel removal minigame til FiveM, der kan bruges i mekaniker jobs eller andre lignende scenarier.

## Funktioner

- Interaktivt hjul-afmontering minigame
- Tre sværhedsgrader (let, medium, svær)
- Kan integreres i ethvert mekaniker-job script
- Understøtter browser-test til nem udvikling

## Installation

1. Kopier `lc_minigames` mappen til din servers `resources` mappe
2. Tilføj `ensure lc_minigames` til din server.cfg
3. Genstart din server

## Brug i scripts

Du kan kalde minigamet fra ethvert client script med følgende kode:

```lua
exports['lc_minigames']:StartWheelRemovalGame("Medium", function(success)
    if success then
        -- Kode der skal køres ved succes
        TriggerEvent('QBCore:Notify', 'Du fjernede hjulet!', 'success')
    else
        -- Kode der skal køres ved fejl
        TriggerEvent('QBCore:Notify', 'Du kunne ikke fjerne hjulet!', 'error')
    end
end)
```

## Test kommando

Du kan teste minigamet med kommandoen `/testwheelgame [sværhedsgrad]`. For eksempel:
- `/testwheelgame Easy`
- `/testwheelgame Medium`
- `/testwheelgame Hard`

## Browser Test

For nem udvikling kan du teste og tilpasse minigamet direkte i din browser:

1. Åbn `html/browsertest.html` i din webbrowser
2. Brug kontrolpanelet til at starte og teste spillet

Se [browser-test-guide.md](browser-test-guide.md) for mere information om browser-test.

## Konfiguration

Du kan tilpasse minigamet ved at redigere `config.lua`:

- `Config.WheelRemoval.Difficulty` - Indstillinger for hver sværhedsgrad
  - `Clicks` - Antal klik der kræves for at fjerne hjulet
  - `TimeLimit` - Tidsgrænse i sekunder
  - `ErrorTolerance` - Antal fejl tilladt før spillet fejler

## Tilpasning

- Juster UI ved at redigere `html/css/style.css`
- Ændr spil-logikken i `html/js/wheel_removal.js`
- Tilføj nye sprites/billeder i `html/img/` mappen

## Credits

Udviklet af [Dit Navn]

## License

Dette projekt er licenseret under [Din valgte licens]
