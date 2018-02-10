
'ppm_dlc_teleprot_delay','3'

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

return true to allow, even if the cvar is set to 0

return false to block, even if the cvar is set to 1

arguments: the player

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
