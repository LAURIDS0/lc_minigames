// This file mocks the FiveM NUI functionality for browser testing

// Mock for GetParentResourceName function
window.GetParentResourceName = function() {
    return 'lc_minigames';
};

// Create a mock for the fetch API that would normally communicate with FiveM
window.postNUIMessage = function(data) {
    console.log('NUI message sent to game:', data);
    
    // Display result on screen for testing
    if (data.type === 'wheelGameCompleted') {
        const resultElement = document.getElementById('game-result');
        if (resultElement) {
            resultElement.textContent = data.data.success 
                ? '✅ Success! Wheel removed successfully.' 
                : '❌ Failed! Could not remove the wheel.';
            resultElement.style.color = data.data.success ? '#4CAF50' : '#ff6347';
        }
    }
};

// Mock the NUI event system for browser testing
window.dispatchNuiEvent = function(action, data) {
    // Create a custom event that simulates a message from the game
    const event = new CustomEvent('message', {
        detail: {
            data: {
                action: action,
                ...data
            }
        }
    });
    
    // Override the 'data' property for event.data access
    Object.defineProperty(event, 'data', {
        get: function() {
            return this.detail.data;
        }
    });
    
    // Dispatch the event to the window
    window.dispatchEvent(event);
};
