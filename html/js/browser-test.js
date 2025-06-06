// Controls for browser testing of the wheel removal minigame

// Configuration based on the server's config.lua
const browserConfig = {
    Difficulty: {
        Easy: {
            Clicks: 4,
            TimeLimit: 10,
            ErrorTolerance: 4
        },
        Medium: {
            Clicks: 5,
            TimeLimit: 8,
            ErrorTolerance: 3
        },
        Hard: {
            Clicks: 5,
            TimeLimit: 6,
            ErrorTolerance: 1
        }
    },
    DefaultDifficulty: "Medium"
};

// Event listeners for browser testing controls
document.addEventListener('DOMContentLoaded', function() {
    const startGameBtn = document.getElementById('start-game');
    const resetGameBtn = document.getElementById('reset-game');
    const difficultySelect = document.getElementById('difficulty-select');
    
    // Start game button
    startGameBtn.addEventListener('click', function() {
        const difficulty = difficultySelect.value;
        const diffSettings = browserConfig.Difficulty[difficulty];
        
        // Clear previous result
        document.getElementById('game-result').textContent = '';
        
        // Dispatch NUI event to start the game
        dispatchNuiEvent('startWheelRemovalGame', {
            timeLimit: diffSettings.TimeLimit,
            clicksRequired: diffSettings.Clicks,
            errorTolerance: diffSettings.ErrorTolerance
        });
    });
    
    // Reset game button (for debugging)
    resetGameBtn.addEventListener('click', function() {
        location.reload();
    });
    
    // Initialize with default settings on page load
    const defaultDiff = browserConfig.DefaultDifficulty;
    difficultySelect.value = defaultDiff;
    
    // Auto-start the game on load (optional - can be commented out)
    // setTimeout(() => startGameBtn.click(), 500);
});
