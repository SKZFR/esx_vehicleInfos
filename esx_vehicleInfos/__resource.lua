resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'esx_vehicleInfos - by SKZ'

version '1.0.0'

dependency 'es_extended'

server_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'locales/en.lua',
	'config.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}