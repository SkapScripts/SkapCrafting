fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author 'Skap'
description 'Crafting System for QBCore'
version '1.0.0'
repository ''

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua',
    '@ox_lib/init.lua'
}

server_scripts {
    '@qb-core/server/main.lua',
    'server/webhooks.lua',         
    'server/server.lua'
}

client_scripts {
    'client/client.lua'
}