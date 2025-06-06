Config = {}

-- General Settings
Config.Debug = true -- Set to true to enable debug mode

-- 3D Wheel UI Settings
Config.WheelUI = {
    Command = "wheelui", -- Command to open the wheel UI
    DefaultWheelModel = "prop_wheel_01", -- Default wheel model to display
    WheelModels = {
        "prop_wheel_01",
        "prop_wheel_02",
        "prop_wheel_03",
        "prop_wheel_04",
        "prop_wheel_05"
    }
}

-- Wheel game settings
Config.WheelGame = {
    UI = {
        Scale = 1.0,
        WheelModels = {
            "prop_wheel_01",
            "prop_wheel_02"
        },
        Colors = {
            Text = {255, 255, 255, 200},
            Highlight = {50, 150, 255, 200}
        }
    },
    Difficulty = {
        Easy = {
            BoltsCount = 4,
            SkillCheckDifficulty = "easy"
        },
        Medium = {
            BoltsCount = 5,
            SkillCheckDifficulty = "medium"
        },
        Hard = {
            BoltsCount = 6,
            SkillCheckDifficulty = "hard"
        }
    }
}

