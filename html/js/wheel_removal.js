// Wheel removal minigame logic

let gameConfig = {
    timeLimit: 10,
    clicksRequired: 5,
    errorTolerance: 2
};

let gameState = {
    active: false,
    timer: null,
    timeLeft: 0,
    clicksDone: 0,
    errorCount: 0,
    currentBolt: null,
    correctTool: null,
    selectedTool: null,
    boltSequence: []
};

// Start the wheel removal minigame
function startWheelRemovalGame(config) {
    // Initialize game with config
    gameConfig.timeLimit = config.timeLimit || 10;
    gameConfig.clicksRequired = config.clicksRequired || 5;
    gameConfig.errorTolerance = config.errorTolerance || 2;
    
    resetGame();
    setupGame();
    startGameTimer();
}

// Reset the game state
function resetGame() {
    clearInterval(gameState.timer);
    
    gameState = {
        active: true,
        timer: null,
        timeLeft: gameConfig.timeLimit,
        clicksDone: 0,
        errorCount: 0,
        currentBolt: null,
        correctTool: null,
        selectedTool: null,
        boltSequence: generateBoltSequence()
    };
    
    // Reset UI
    document.getElementById('time-left').textContent = gameState.timeLeft;
    document.getElementById('clicks-done').textContent = gameState.clicksDone;
    document.getElementById('clicks-required').textContent = gameConfig.clicksRequired;
    document.getElementById('error-count').textContent = gameState.errorCount;
    document.getElementById('error-limit').textContent = gameConfig.errorTolerance;
    
    // Reset bolt visuals
    const bolts = document.querySelectorAll('.bolt');
    bolts.forEach(bolt => {
        bolt.classList.remove('highlight', 'removed');
    });
    
    // Reset tool selection
    const tools = document.querySelectorAll('.tool');
    tools.forEach(tool => {
        tool.classList.remove('selected');
    });
}

// Generate a random sequence of bolts
function generateBoltSequence() {
    const boltCount = 5; // Number of bolts on the wheel
    const sequence = [];
    
    // Create an array with bolt indices
    const boltIndices = Array.from({length: boltCount}, (_, i) => i + 1);
    
    // Generate sequence with the required number of clicks
    for (let i = 0; i < gameConfig.clicksRequired; i++) {
        // If we've used all bolts, refill the array (simulate multiple rounds)
        if (boltIndices.length === 0) {
            for (let j = 1; j <= boltCount; j++) {
                boltIndices.push(j);
            }
        }
        
        // Pick a random bolt from the available ones
        const randomIndex = Math.floor(Math.random() * boltIndices.length);
        const boltIndex = boltIndices.splice(randomIndex, 1)[0];
        
        // Randomly select the correct tool (wrench or impact)
        const tool = Math.random() > 0.5 ? 'wrench' : 'impact';
        
        sequence.push({
            bolt: boltIndex,
            tool: tool
        });
    }
    
    return sequence;
}

// Set up the game event listeners
function setupGame() {
    // Add event listeners to tools
    const tools = document.querySelectorAll('.tool');
    tools.forEach(tool => {
        tool.addEventListener('click', function() {
            if (!gameState.active) return;
            
            // Deselect all tools
            tools.forEach(t => t.classList.remove('selected'));
            
            // Select this tool
            this.classList.add('selected');
            gameState.selectedTool = this.getAttribute('data-tool');
        });
    });
    
    // Add event listeners to bolts
    const bolts = document.querySelectorAll('.bolt');
    bolts.forEach((bolt, index) => {
        bolt.addEventListener('click', function() {
            if (!gameState.active) return;
            
            // Check if this is the highlighted bolt
            const boltNumber = parseInt(this.className.match(/bolt-(\d+)/)[1]);
            
            if (boltNumber === gameState.currentBolt) {
                // Check if the correct tool is selected
                if (gameState.selectedTool === gameState.correctTool) {
                    // Success - bolt removed correctly
                    this.classList.remove('highlight');
                    this.classList.add('removed');
                    
                    // Increment click count
                    gameState.clicksDone++;
                    document.getElementById('clicks-done').textContent = gameState.clicksDone;
                    
                    // Check if all bolts are removed
                    if (gameState.clicksDone >= gameConfig.clicksRequired) {
                        gameCompleted(true);
                    } else {
                        // Continue to next bolt
                        highlightNextBolt();
                    }
                } else {
                    // Wrong tool selected
                    gameState.errorCount++;
                    document.getElementById('error-count').textContent = gameState.errorCount;
                    
                    // Check if too many errors
                    if (gameState.errorCount > gameConfig.errorTolerance) {
                        gameCompleted(false);
                    }
                }
            }
        });
    });
        bolt.addEventListener('click', function() {
            if (!gameState.active) return;
            
            // Check if this is the current bolt to remove
            if (this.classList.contains('highlight')) {
                // Check if the correct tool is selected
                if (gameState.selectedTool === gameState.correctTool) {
                    // Success - bolt removed
                    this.classList.remove('highlight');
                    this.classList.add('removed');
                    
                    gameState.clicksDone++;
                    document.getElementById('clicks-done').textContent = gameState.clicksDone;
                    
                    // Check if game is completed
                    if (gameState.clicksDone >= gameConfig.clicksRequired) {
                        gameCompleted(true);
                    } else {
                        // Continue to next bolt
                        highlightNextBolt();
                    }
                } else {
                    // Wrong tool selected - count as error
                    gameState.errorCount++;
                    document.getElementById('error-count').textContent = gameState.errorCount;
                    
                    this.classList.add('failure-animation');
                    setTimeout(() => {
                        this.classList.remove('failure-animation');
                    }, 500);
                    
                    // Check if too many errors
                    if (gameState.errorCount > gameConfig.errorTolerance) {
                        gameCompleted(false);
                    }
                }
            }
        });
    });
    
    // Start with the first bolt
    highlightNextBolt();
}

// Highlight the next bolt in the sequence
function highlightNextBolt() {
    // Remove highlight from current bolt if exists
    if (gameState.currentBolt) {
        document.querySelector(`.bolt-${gameState.currentBolt}`).classList.remove('highlight');
    }
    
    // Get next bolt info from sequence
    const nextBoltInfo = gameState.boltSequence[gameState.clicksDone];
    
    // Set current bolt and correct tool
    gameState.currentBolt = nextBoltInfo.bolt;
    gameState.correctTool = nextBoltInfo.tool;
    
    // Highlight the bolt
    document.querySelector(`.bolt-${gameState.currentBolt}`).classList.add('highlight');
    
    // Update instructions to guide the player
    document.getElementById('instructions').textContent = 
        `Use the ${gameState.correctTool === 'wrench' ? 'Wrench' : 'Impact Driver'} on the highlighted bolt.`;
}

// Start the game timer
function startGameTimer() {
    gameState.timer = setInterval(() => {
        gameState.timeLeft--;
        document.getElementById('time-left').textContent = gameState.timeLeft;
        
        if (gameState.timeLeft <= 0) {
            gameCompleted(false);
        }
    }, 1000);
}

// End the game
function gameCompleted(success) {
    clearInterval(gameState.timer);
    gameState.active = false;
    
    // Show result message
    document.getElementById('instructions').textContent = 
        success ? 'Wheel successfully removed!' : 'Failed to remove the wheel!';
    
    // Apply animation
    document.getElementById('wheel-image').classList.add(
        success ? 'success-animation' : 'failure-animation'
    );
    
    // Send result back to client
    setTimeout(() => {
        postNUIMessage({
            type: 'wheelGameCompleted',
            data: { success: success }
        });
        
        // Hide the game
        document.getElementById('minigames-container').style.display = 'none';
        document.getElementById('wheel-removal-game').style.display = 'none';
        
        // Remove animations
        document.getElementById('wheel-image').classList.remove(
            'success-animation', 'failure-animation'
        );
    }, 2000);
}
