http://steamcommunity.com/sharedfiles/filedetails/?id=107155115

if you get any PPM addons, the animation won't work unless you get CPPM and inject its models

if you get CPPM, turn off cppm's flight by running "cppm_allowfly 1" into the server console

|

|

"ppm_dlc_dmg_mod","1" enable/disable damage modifiers,

"ppm_dlc_dmg_hvh","1" for non ponies damaging non ponies

"ppm_dlc_dmg_evh","1.125" for earth ponies damaging non ponies

"ppm_dlc_dmg_uvh","0.875" for pegasi and unicorns damaging non ponies

"ppm_dlc_dmg_hve","0.875" for non ponies damaging earth ponies

"ppm_dlc_dmg_eve","1" for earth ponies damaging earth ponies

"ppm_dlc_dmg_uve","0.75" for pegasi and unicorns damaging earth ponies

"ppm_dlc_dmg_hvu","1.125" for non ponies damaging pegasi and unicorns

"ppm_dlc_dmg_evu","1.25" for earth ponies damaging pegasi and unicorns

"ppm_dlc_dmg_uvu","1" for pegasi and unicorns damaging pegasi and unicorns

|

|

'ppm_dlc_teleport_delay','3'

how many seconds does a player have to wait after they teleport before they can teleport again?

|

'ppm_dlc_teleport_distance','100',

how many meters can you go when teleporting?

|

'ppm_dlc_fall_immunity','3',

how many seconds after teleporting or droping out of flight is a player immune to fall damage?(run ppm_dlc_refresh after changing)

|

|

these convars decide the default behavior of certain actions

'ppm_dlc_concmd_allow','1'

if set to 1, updating your pony type via concommand will work unless the corresponding hook returns false

otherwise it won't work unless the hook returns true

|

'ppm_dlc_choice_allow','1'

if set to 1, alicorns can specify what ability they want unless the corresponding hook returns false

otherwise it won't work unless the hook returns true

|

'ppm_dlc_teleport_allow','1'

if set to 1, unicorns teleportation will work unless the corresponding hook returns false

otherwise it won't work unless the hook returns true

|

'ppm_dlc_flight_allow','1'

if set to 1, pegasus flight will work unless the corresponding hook returns false

otherwise it won't work unless the hook returns true

|

|

return a boolean on these hooks to overide what the corresponding convar says

|

'ppm_dlc_concmd_allow' can players update their ponytype with a console command?

arguments: the player

return true to allow, even if the cvar is set to 0

return false to block, even if the cvar is set to 1

|

'ppm_dlc_choice_allow','1' can alicorns can specify what ability they want?

arguments: the player, number (1=earth,2=pegasus,3=unicorn)

return true to allow, even if the cvar is set to 0

return false to block, even if the cvar is set to 1

|

'ppm_dlc_teleport_allow','1' can unicorns teleport?

arguments: the player

return true to allow, even if the cvar is set to 0

return false to block, even if the cvar is set to 1

|

'ppm_dlc_flight_allow','1' can pegasi fly?

arguments: the player

return true to allow, even if the cvar is set to 0

return false to block, even if the cvar is set to 1

|

|

concommands

ppm_dlc_refresh,

refreshes the addons's code

need to be a superadmin or the server console

|

ppm_dlc_update

refreshes your pony type based on what whether you have wings and or a horn

if an alicorn provides a number argument, they may be able to specify what type of pony to become.
