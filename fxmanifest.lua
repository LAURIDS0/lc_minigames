fx_version 'cerulean'
game 'gta5'

description 'LC Minigames - Including Wheel Removal Game'
author 'Your Name'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/main.lua',
    'client/wheel_removal.lua',
}

server_scripts {
    'server/main.lua',
}

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/script.js',
    'html/js/wheel_removal.js',
    'html/img/*.png',
}
