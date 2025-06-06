// Main script for handling general minigame functionality

// Event listener for messages from the client script
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === "startWheelRemovalGame") {
        document.getElementById('minigames-container').style.display = 'block';
        document.getElementById('wheel-removal-game').style.display = 'block';
        startWheelRemovalGame(data);
    }
});

// Function to send data back to the client script
function postNUIMessage(data) {
    // Only try to use FiveM fetch when running in FiveM
    if (typeof GetParentResourceName === 'function' && !window.inBrowserTest) {
        fetch(`https://${GetParentResourceName()}/` + data.type, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data.data || {})
        });
    } else {
        // In browser testing environment, this is handled by browser-mock.js
        console.log('NUI Message (Browser Test):', data);
    }
}

// Close NUI when ESC is pressed
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeAllGames();
    }
});

// Close all games and reset UI
function closeAllGames() {
    document.getElementById('minigames-container').style.display = 'none';
    document.getElementById('wheel-removal-game').style.display = 'none';
    
    // Send message to client that games were closed
    postNUIMessage({
        type: 'wheelGameCompleted',
        data: { success: false }
    });
}
