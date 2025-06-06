// Variables for Three.js
let scene, camera, renderer, controls, wheelModel;
let currentWheelModel = 'prop_wheel_01';
let debugMode = true;

// Debug logging function
function debugLog(message) {
    if (debugMode) {
        console.log('[DEBUG] ' + message);
        document.getElementById('debug-info').textContent = message;
        document.getElementById('debug-info').style.display = 'block';
    }
}

// Initialize the 3D scene
function initThreeJS() {
    debugLog('Initializing Three.js scene');
    try {
        // Create scene
        scene = new THREE.Scene();
        scene.background = new THREE.Color(0x222222);

        // Create camera
        camera = new THREE.PerspectiveCamera(75, window.innerWidth / (window.innerHeight * 0.9), 0.1, 1000);
        camera.position.z = 5;

        // Create renderer
        renderer = new THREE.WebGLRenderer({ antialias: true });
        renderer.setSize(window.innerWidth, window.innerHeight * 0.9);
        document.getElementById('wheel-3d-view').appendChild(renderer.domElement);

        // Add orbit controls
        controls = new THREE.OrbitControls(camera, renderer.domElement);
        controls.enableDamping = true;
        controls.dampingFactor = 0.25;
        controls.enableZoom = true;

        // Add lights
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
        scene.add(ambientLight);

        const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
        directionalLight.position.set(5, 5, 5);
        scene.add(directionalLight);

        // Create a placeholder wheel (cylinder)
        createPlaceholderWheel();

        // Start animation loop
        animate();
        
        debugLog('Three.js scene initialized successfully');
    } catch (error) {
        debugLog('Error initializing Three.js: ' + error.message);
    }
}

// Create a placeholder wheel (will be replaced with a real 3D model in a production environment)
function createPlaceholderWheel() {
    debugLog('Creating placeholder wheel');
    try {
        // Remove existing wheel if any
        if (wheelModel) {
            scene.remove(wheelModel);
        }

        // Create a group for the wheel
        wheelModel = new THREE.Group();

        // Create the main wheel body (cylinder)
        const wheelGeometry = new THREE.CylinderGeometry(2, 2, 0.5, 32);
        const wheelMaterial = new THREE.MeshStandardMaterial({ 
            color: 0x333333,
            roughness: 0.7,
            metalness: 0.8
        });
        const wheelBody = new THREE.Mesh(wheelGeometry, wheelMaterial);
        wheelBody.rotation.x = Math.PI / 2; // Rotate to face front
        wheelModel.add(wheelBody);

        // Create the hub cap
        const hubCapGeometry = new THREE.CylinderGeometry(1, 1, 0.1, 32);
        const hubCapMaterial = new THREE.MeshStandardMaterial({ 
            color: 0xC0C0C0,
            roughness: 0.2,
            metalness: 1.0
        });
        const hubCap = new THREE.Mesh(hubCapGeometry, hubCapMaterial);
        hubCap.position.y = 0.3;
        hubCap.rotation.x = Math.PI / 2;
        wheelModel.add(hubCap);

        // Create spokes
        const numSpokes = 5;
        for (let i = 0; i < numSpokes; i++) {
            const spokeGeometry = new THREE.BoxGeometry(0.2, 0.1, 1.8);
            const spokeMaterial = new THREE.MeshStandardMaterial({ 
                color: 0xC0C0C0,
                roughness: 0.3,
                metalness: 0.9
            });
            const spoke = new THREE.Mesh(spokeGeometry, spokeMaterial);
            spoke.position.y = 0.25;
            spoke.rotation.z = (i / numSpokes) * Math.PI * 2;
            hubCap.add(spoke);
        }

        // Add to scene
        scene.add(wheelModel);
        debugLog('Placeholder wheel created successfully');
    } catch (error) {
        debugLog('Error creating placeholder wheel: ' + error.message);
    }
}

// Animation loop
function animate() {
    requestAnimationFrame(animate);
    if (controls) controls.update();
    if (renderer && scene && camera) renderer.render(scene, camera);
}

// Handle window resize
function onWindowResize() {
    if (!camera || !renderer) return;
    
    camera.aspect = window.innerWidth / (window.innerHeight * 0.9);
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight * 0.9);
    debugLog('Window resized');
}

// Toggle UI visibility
function toggleUI(show, wheelModelName) {
    debugLog('Toggling UI: ' + (show ? 'show' : 'hide'));
    
    const container = document.getElementById('wheel-container');
    if (show) {
        container.classList.add('visible');
        if (wheelModelName) {
            currentWheelModel = wheelModelName;
            debugLog('Setting wheel model: ' + wheelModelName);
            // In a real implementation, you would load the specific wheel model here
        }
    } else {
        container.classList.remove('visible');
    }
}

// Set up event listeners
document.addEventListener('DOMContentLoaded', function() {
    debugLog('DOM loaded, setting up UI');
    
    // Initialize Three.js scene
    initThreeJS();

    // Add event listeners
    window.addEventListener('resize', onWindowResize);

    // Close button
    document.getElementById('close-btn').addEventListener('click', function() {
        debugLog('Close button clicked');
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        }).catch(error => debugLog('Error sending closeUI: ' + error));
    });

    // Save/complete button
    document.getElementById('save-btn').addEventListener('click', function() {
        debugLog('Save button clicked');
        fetch(`https://${GetParentResourceName()}/completeAction`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                wheelModel: currentWheelModel
            })
        }).catch(error => debugLog('Error sending completeAction: ' + error));
    });
    
    debugLog('UI setup complete');
});

// Message handler for communication with client script
window.addEventListener('message', function(event) {
    const data = event.data;
    debugLog('Received message: ' + JSON.stringify(data));

    if (data.action === 'toggleUI') {
        toggleUI(data.show, data.wheelModel);
        if (data.forceDisplay) {
            document.getElementById('wheel-container').style.display = 'block';
            document.getElementById('wheel-container').classList.add('visible');
            debugLog('Force displaying UI');
        }
    } else if (data.action === 'testConnection') {
        debugLog('Test connection received: ' + data.message);
    }
});

// Function to capture keyboard events
document.onkeyup = function(data) {
    if (data.key === 'Escape') {
        debugLog('Escape key pressed');
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        }).catch(error => debugLog('Error sending closeUI: ' + error));
    }
};

// Let's make sure we're visible
debugLog('Script loaded. Waiting for NUI messages...');
