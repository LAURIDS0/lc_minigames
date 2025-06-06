Config = {}

-- Wheel Removal Minigame Configuration
Config.WheelRemoval = {
    Difficulty = {
        Easy = {
            Clicks = 4,          -- Reduceret fra 5 til 3 for at gøre det lettere
            TimeLimit = 10,      -- Time limit in seconds
            ErrorTolerance = 4   -- Number of errors allowed before failing
        },
        Medium = {
            Clicks = 5,          -- Ændret fra 8 til 5 for at matche antal hjulbolte i UI
            TimeLimit = 8,
            ErrorTolerance = 3
        },
        Hard = {
            Clicks = 5,         -- Ændret fra 12 til 10 (2 runder med alle 5 bolte)
            TimeLimit = 6,
            ErrorTolerance = 1
        }
    },
    DefaultDifficulty = "Medium",
    -- Success and failure callbacks can be customized in the script
}
