fx_version 'cerulean'
game 'gta5'

description 'QBX_Vineyard'
repository 'https://github.com/Qbox-project/qbx_vineyard'
version '1.1.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

server_scripts {
    'server.lua'
}

client_scripts {
    'client.lua'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'