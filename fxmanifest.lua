fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'LC_Minigames'
version '1.0.0'
author 'LC Development'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html'
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory'
}