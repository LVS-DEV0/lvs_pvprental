fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'lvs-developemnt'

client_scripts {
    'bridge/client.lua',
    'client/main.lua'
}

server_scripts {
    'bridge/server.lua',
    'server/main.lua'
}

ui_page 'html/index.html'
files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/*.png',
    'locales/*.json'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

ox_libs {
    'locale'
}
