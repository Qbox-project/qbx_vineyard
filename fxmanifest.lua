fx_version 'cerulean'
game 'gta5'

description 'https://github.com/Qbox-project/qbx-vineyard'
version '1.1.0'

shared_scripts {
    '@qbx-core/import.lua',
    '@ox_lib/init.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

server_scripts {
    'server.lua'
}

client_scripts {
    'client.lua'
}

modules {
	'qbx-core:core',
}

lua54 'yes'
