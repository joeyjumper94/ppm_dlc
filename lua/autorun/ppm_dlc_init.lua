AddCSLuaFile()
ppm_dlc=ppm_dlc or {}
local FLAGS={FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}
local CONCMD=CreateConVar("ppm_dlc_concmd_allow","1",FLAGS,[[if set to 1, updating your pony type via concommand will work unless hook.Run("ppm_dlc_concmd_allow",ply) returns false
otherwise it won't work unless hook.Run("ppm_dlc_concmd_allow",ply) returns true]]):GetBool()
cvars.AddChangeCallback("ppm_dlc_concmd_allow",function(v,o,n) CONCMD=n!="0" end,"ppm_dlc_concmd_allow")
local CHOICE=CreateConVar("ppm_dlc_choice_allow","1",FLAGS,[[if set to 1, alicorns can specify what ability they want hook.Run("ppm_dlc_choice_allow",ply,type) returns false
otherwise they can't work unless hook.Run("ppm_dlc_choice_allow",ply,type) returns true]]):GetBool()
cvars.AddChangeCallback("ppm_dlc_choice_allow",function(v,o,n) CHOICE=n!="0" end,"ppm_dlc_choice_allow")
local DELAY=CreateConVar("ppm_dlc_teleport_delay","3",FLAGS,[[how many seconds does a player have to wait after they teleport before they can teleport again?]]):GetFloat()
cvars.AddChangeCallback("ppm_dlc_teleport_delay",function(v,o,n) DELAY=tonumber(n) end,"ppm_dlc_teleport_delay")
local MAX_DISTANCE = CreateConVar('ppm_dlc_teleport_distance','1000',FLAGS,'how many hammer units can you go when teleporting?'):GetFloat()
cvars.AddChangeCallback('ppm_dlc_teleport_distance',function(v,o,n) MAX_DISTANCE=tonumber(n) end,'ppm_dlc_teleport_distance')
local Duration = CreateConVar('ppm_dlc_fall_immunity','3',FLAGS,[[how many seconds after teleporting slash droping out of flight is a player immune to fall damage?
run ppm_dlc_refresh after changing]]):GetFloat()
cvars.AddChangeCallback('ppm_dlc_fall_immunity',function(v,o,n) Duration=tonumber(n) end,'ppm_dlc_fall_immunity')
local allow_unicorn=CreateConVar("ppm_dlc_teleport_allow","1",FLAGS,[[if set to 1, unicorns teleportation will unless hook.Run("ppm_dlc_teleport_allow",ply) returns false
otherwise it won't work unless hook.Run("ppm_dlc_teleport_allow",ply) returns true]]):GetBool()
cvars.AddChangeCallback("ppm_dlc_teleport_allow",function(v,o,n) allow_unicorn=n!="0" end,"ppm_dlc_teleport_allow")
local allow_pegasus=CreateConVar("ppm_dlc_flight_allow","1",FLAGS,[[if set to 1, pegasus flight will unless hook.Run("ppm_dlc_flight_allow",ply) returns false
otherwise it won't work unless hook.Run("ppm_dlc_flight_allow",ply) returns true]]):GetBool()
cvars.AddChangeCallback("ppm_dlc_flight_allow",function(v,o,n) allow_pegasus=n!="0" end,"ppm_dlc_flight_allow")
local alicorn_chance=CreateConVar('ppm_dlc_alicorn_chance','0.1',FLAGS,'how what percantage of the time is a pony with wings and a horn designated an alicorn?'):GetFloat()
cvars.AddChangeCallback('ppm_dlc_alicorn_chance',function(v,o,n) alicorn_chance=tonumber(n) end,'ppm_dlc_alicorn_chance')
local DMG_mod=CreateConVar("ppm_dlc_dmg_mod","1",FLAGS,[[enable/disable damage modifiers]]):GetBool()
cvars.AddChangeCallback("ppm_dlc_dmg_mod",function(v,o,n) DMG_mod=n!="0" end,"ppm_dlc_dmg_mod")
local DMG_hvh=CreateConVar("ppm_dlc_dmg_hvh","1",FLAGS,"damage modifier for non ponies damaging non ponies"):GetFloat()	--human on human 
cvars.AddChangeCallback("ppm_dlc_dmg_hvh",function(v,o,n) DMG_hvh=tonumber(n) end,"ppm_dlc_dmg_hvh")
local DMG_evh=CreateConVar("ppm_dlc_dmg_evh","1.125",FLAGS,"damage modifier for earth ponies damaging non ponies"):GetFloat()	--earth pony on human
cvars.AddChangeCallback("ppm_dlc_dmg_evh",function(v,o,n) DMG_evh=tonumber(n) end,"ppm_dlc_dmg_evh")
local DMG_uvh=CreateConVar("ppm_dlc_dmg_uvh","0.875",FLAGS,"damage modifier for pegasi and unicorns damaging non ponies"):GetFloat()	--pegasus or unicorn on human
cvars.AddChangeCallback("ppm_dlc_dmg_uvh",function(v,o,n) DMG_uvh=tonumber(n) end,"ppm_dlc_dmg_uvh")
local DMG_hve=CreateConVar("ppm_dlc_dmg_hve","0.875",FLAGS,"damage modifier for non ponies damaging earth ponies"):GetFloat()	--human on earth pony
cvars.AddChangeCallback("ppm_dlc_dmg_hve",function(v,o,n) DMG_hve=tonumber(n) end,"ppm_dlc_dmg_hve")
local DMG_eve=CreateConVar("ppm_dlc_dmg_eve","1",FLAGS,"damage modifier for earth ponies damaging earth ponies"):GetFloat()	--earth pony on earth pony
cvars.AddChangeCallback("ppm_dlc_dmg_eve",function(v,o,n) DMG_eve=tonumber(n) end,"ppm_dlc_dmg_eve")
local DMG_uve=CreateConVar("ppm_dlc_dmg_uve","0.75",FLAGS,"damage modifier for pegasi and unicorns damaging earth ponies"):GetFloat()	--pegasus or unicorn on earth pony
cvars.AddChangeCallback("ppm_dlc_dmg_uve",function(v,o,n) DMG_uve=tonumber(n) end,"ppm_dlc_dmg_uve")
local DMG_hvu=CreateConVar("ppm_dlc_dmg_hvu","1.125",FLAGS,"damage modifier for non ponies damaging pegasi and unicorns"):GetFloat()	--human on pegasus or unicorn
cvars.AddChangeCallback("ppm_dlc_dmg_hvu",function(v,o,n) DMG_hvu=tonumber(n) end,"ppm_dlc_dmg_hvu")
local DMG_evu=CreateConVar("ppm_dlc_dmg_evu","1.25",FLAGS,"damage modifier for earth ponies damaging pegasi and unicorns"):GetFloat()	--earth pony on pegasus or unicorn
cvars.AddChangeCallback("ppm_dlc_dmg_evu",function(v,o,n) DMG_evu=tonumber(n) end,"ppm_dlc_dmg_evu")
local DMG_uvu=CreateConVar("ppm_dlc_dmg_uvu","1",FLAGS,"damage modifier for pegasi and unicorns damaging pegasi and unicorns"):GetFloat()	--pegasus or unicorn on pegasus or unicorn
cvars.AddChangeCallback("ppm_dlc_dmg_uvu",function(v,o,n) DMG_uvu=tonumber(n) end,"ppm_dlc_dmg_uvu")

--wow, I unwittingly spelled "huehuehue" somewhere in this file, can you find it?

--cvars.AddChangeCallback(<NAME>,function(v,o,n) <VAR>=tonumber(n) end,<NAME>)

local ppm_models={--models associated with ppm
	["models/ewppm/player_default_base.mdl"]=true,
	["models/cppm/player_default_base.mdl"]=true,
	["models/cppm/player_default_base_nj.mdl"]=true,
	["models/cppm/player_default_base_ragdoll.mdl"]=true,
	["models/ppm/player_default_base.mdl"]=true,
	["models/ppm/player_default_base_nj.mdl"]=true,
	["models/ppm/player_default_base_ragdoll.mdl"]=true,
--	["models/ppm/player_mature_base.mdl"]=true,--
	["models/ppm_veh/player_default_base.mdl"]=true,
	["models/ppm_veh/player_default_base_nj.mdl"]=true,
}
--local BODYGROUP_HORN,BODYGROUP_WING=2,3
local earth={--a list of earth pony models
--static
--	["models/creepyloom.mdl"]=true,
--NPC/PM
	["models/kinkybeer_playermodel.mdl"]=true,
	["models/toxicmane_playermodel.mdl"]=true,
	["models/applejack_npc.mdl"]=true,
	["models/applejack_player.mdl"]=true,
	["models/bonbon_npc.mdl"]=true,
	["models/bonbon_player.mdl"]=true,
	["models/octavia_player.mdl"]=true,
	["models/octavia_npc.mdl"]=true,
	["models/pinkiepie_player.mdl"]=true,
	["models/pinkiepie_npc.mdl"]=true,
	["models/roseluck_player.mdl"]=true,
	["models/roseluck_npc.mdl"]=true,
	["models/applepierce_player.mdl"]=true,
	["models/zemospie_player.mdl"]=true,
	["models/lilaflash_player.mdl"]=true,
	["models/applengineer_player.mdl"]=true,
	["models/yarnspinner_player.mdl"]=true,
}
local pegasus={--a list of pegasus models (wings closed by default)
--static
--NPC/PM
	["models/dimonbro_npc.mdl"]=true,
	["models/daringdoo_npc.mdl"]=true,
	["models/daringdoo_player.mdl"]=true,
	["models/derpyhooves_npc.mdl"]=true,
	["models/derpyhooves_player.mdl"]=true,
	["models/fluttershy_npc.mdl"]=true,
	["models/fluttershy_player.mdl"]=true,
	["models/rainbowdash_player.mdl"]=true,
	["models/rainbowdash_npc.mdl"]=true,
	["models/raindrops_player.mdl"]=true,
	["models/raindrops_npc.mdl"]=true,
	["models/spitfire_player.mdl"]=true,
	["models/spitfire_npc.mdl"]=true,
	["models/dashe.mdl"]=true,
	["models/spectrum_the_goddamed_horse_playermodel.mdl"]=true,
	["models/angelhooves_player.mdl"]=true,
	["models/fluttersaint_player.mdl"]=true,
	["models/rainbowgat_player.mdl"]=true,
	["models/colorshy_player.mdl"]=true,
	["models/derpyhooves_dress_player.mdl"]=true,
	["models/googlechrome_player.mdl"]=true,
	["models/midnightblossom_player.mdl"]=true,
	["models/evestormrider_player.mdl"]=true,
}
local pegasus_invert={--a list of pegasus models (wings open by default)
--static
--NPC/PM
	["models/garnet_d_horn_playermodel.mdl"]=true,
	["models/vn_trevor_playermodel.mdl"]=true,
	["models/rainshine_playermodel.mdl"]=true,
	["models/bigmuffintosh_playermodel.mdl"]=true,
	["models/artemis_playermodel.mdl"]=true,
	["models/spectrum_the_goddamed_horse_playermodel.mdl"]=true,
	["models/blueflower_player.mdl"]=true,
	["models/click_player.mdl"]=true,
	["models/mintytwister_player.mdl"]=true,
	["models/rillakim_player.mdl"]=true,
	["models/springflower_player.mdl"]=true,
	["models/springfloweruni_player.mdl"]=true,
	["models/starlightsubscyed_player.mdl"]=true,
	["models/toxicsoul_player.mdl"]=true,
	["models/bluedust_player.mdl"]=true,
	["models/flamerunner_male_player.mdl"]=true,
	["models/flamerunner_player.mdl"]=true,
	["models/grayspout_player.mdl"]=true,
	["models/nick_player.mdl"]=true,
	["models/polishprince_player.mdl"]=true,
	["models/snowdash_player.mdl"]=true,
	["models/thunderdasher_player.mdl"]=true,
	["models/rainbowscout_player.mdl"]=true,
	["models/yin_player.mdl"]=true,
	["models/yang_player.mdl"]=true,
	["models/ravenshadowdash_player.mdl"]=true,
	["models/duskhappiness_turret_player.mdl"]=true,
}
local unicorns={--a list of unicorn models
--static
--NPC/PM
	["models/littlepip_npc.mdl"]=true,
	["models/littlepip_player.mdl"]=true,
	["models/colgate_npc.mdl"]=true,
	["models/colgate_player.mdl"]=true,
	["models/lyra_npc.mdl"]=true,
	["models/lyra_player.mdl"]=true,
	["models/rarity_player.mdl"]=true,
	["models/rarity_npc.mdl"]=true,
	["models/trixie_npc.mdl"]=true,
	["models/trixie_player.mdl"]=true,
	["models/twilightsparkle_npc.mdl"]=true,
	["models/twilightsparkle_player.mdl"]=true,
	["models/vinyl_npc.mdl"]=true,
	["models/vinyl_player.mdl"]=true,
	["models/player/blackjack.mdl"]=true,
	["models/colgate.mdl"]=true,
	["models/modded.mdl"]=true,
	["models/treblemaker_player.mdl"]=true,
	["models/midnightflare_player.mdl"]=true,
	["models/midnightshade_player.mdl"]=true,
	["models/themaster_player.mdl"]=true,
	["models/pewdiepie_player.mdl"]=true,
	["models/violetrecord_player.mdl"]=true,
	["models/kinziesparkle_player.mdl"]=true,
	["models/shaity_player.mdl"]=true,
	["models/askan_player.mdl"]=true,
}
local alicorns={--a list of alicorn models
--static
--NPC/PM
	["models/celestia_player.mdl"]=true,
	["models/luna_npc.mdl"]=true,
	["models/luna_player.mdl"]=true,
	["models/princesstwilight_player.mdl"]=true,
	["models/princesstwilight_npc.mdl"]=true,
	["models/twilance_player.mdl"]=true,
}

local pegasus_static_1={
	["models/brightmane.mdl"]=true,
	["models/derpyhooves.mdl"]=true,
	["models/evestormrider.mdl"]=true,
	["models/fire_sparkl2.mdl"]=true,
	["models/fluttershy.mdl"]=true,
	["models/gilda.mdl"]=true,
}

ppm_dlc.models={}
for k,v in pairs(alicorns)do
	ppm_dlc.models[k]=v
end
for k,v in pairs(pegasus)do
	ppm_dlc.models[k]=v
end
for k,v in pairs(pegasus_invert)do
	ppm_dlc.models[k]=v
end
for k,v in pairs(earth)do
	ppm_dlc.models[k]=v
end
for k,v in pairs(ppm_models)do
	ppm_dlc.models[k]=v
end
for k,v in pairs(unicorns)do
	ppm_dlc.models[k]=v
end
for k,v in pairs(pegasus_static_1)do
--	ppm_dlc.models[k]=v
end

hook.Add("PlayerSpawnEffect","ppm_dlc_hooks",function(ply,m)
	if ppm_dlc.models[m]then
--		return false
	end
end)
hook.Add("PlayerSpawnProp","ppm_dlc_hooks",function(ply,m)
	if ppm_dlc.models[m]then
--		return false
	end
end)
hook.Add("PlayerSpawnRagdoll","ppm_dlc_hooks",function(ply,m)
	if ppm_dlc.models[m]then
--		return false
	end
end)

for k,v in ipairs(ents.GetAll())do
	local m=v:GetModel()
	if ppm_dlc.models[m] and SERVER then
		v:Remove()
	end
end
local flying={
	[2]=true,
	[4]=true,
}
local magic={
	[3]=true,
	[4]=true,
}
function ppm_dlc.HasWings(self)
	return self:GetBodygroup(3)!=1
end
function ppm_dlc.HasHorn(self)
	return self:GetBodygroup(2)!=1
end
function ppm_dlc.IsPony(self)
	if self and self:IsValid() then
		local mdl=self:GetModel()
		if ppm_models[mdl] then
			if PPM_vEH and PPM_vEH.PonyData[self] then
				local ponydata=PPM_vEH.PonyData[self]
				if ponydata and ponydata.kind then
					return ponydata.kind
				end
			elseif PPM then
				if ppm_dlc.HasWings(self) and ppm_dlc.HasHorn(self) then--wings+horn=alicorn
					return 4
				elseif ppm_dlc.HasHorn(self) then--horn=unicorn
					return 3
				elseif ppm_dlc.HasWings(self) then--wings=pegasus
					return 2
				end
			end
			return 1
		elseif alicorns[mdl] then return 4
		elseif unicorns[mdl] then return 3
		elseif pegasus[mdl] or pegasus_invert[mdl] then return 2
		elseif earth[mdl] then return 1
		end
	end
	return 4
end
function ppm_dlc.setponytype(ply,arg)

	local PONYTYPE=ppm_dlc.IsPony(ply)
	local HOOK=nil
	if arg then
		HOOK=hook.Run("ppm_dlc_choice_allow",ply,arg)
	end
	local CAN=CHOICE and HOOK!=false or HOOK
	if PONYTYPE==4 and math.Rand(1,100)>alicorn_chance then
		if arg and CAN and arg>0 and arg<4 then--alicorns can specify what type they want to be
			PONYTYPE=arg
		else
			PONYTYPE=math.random(1,3)--alicorns will get a random selection of earth pony, pegasus, or unicorn powers
		end
	end
		
	ply:SetNWInt("PONYTYPE",PONYTYPE)
	local MOVETYPE=ply:GetMoveType()
	if (MOVETYPE==MOVETYPE_FLY or MOVETYPE==MOVETYPE_FLYGRAVITY) and PONYTYPE!=2 and PONYTYPE!=4 then--they changed out of pegasus while flying
		ppm_dlc.stop_flying(ply)
	end
	
	local types={
		[0]=" nonpony",
		[1]='n earth pony',
		[2]=' pegasus',
		[3]=' unicorn',
		[4]='n alicorn',
	}
	ply.OldPos=ply:GetPos()
	if ply.PrintMessage then
		ply:PrintMessage(HUD_PRINTTALK,"you are now a"..types[ply:GetNWInt("PONYTYPE",0)])
	end
end
if SERVER then
	hook.Add("PlayerInitalSpawn","ppm_dlc_hooks",function(self)
		timer.Simple(1,function()
			local check=ppm_dlc.IsPony(self)
			local type=self:GetNWInt("PONYTYPE",0)
			if check==4 and type==0 or check!=type then
				ppm_dlc.setponytype(self)
			end
		end)
	end)
	hook.Add("PlayerSetModel","ppm_dlc_hooks",function(self)
		timer.Simple(0.2,function()
			local check=ppm_dlc.IsPony(self)
			local type=self:GetNWInt("PONYTYPE",0)
			if check==4 and type==0 or check!=type then
				ppm_dlc.setponytype(self)
			end
		end)
	end)
	hook.Add("OnPonyChanged","ppm_dlc_hooks",function(self)
		timer.Simple(0.2,function()
			local check=ppm_dlc.IsPony(self)
			local type=self:GetNWInt("PONYTYPE",0)
			if check==4 and type==0 or check!=type then
				ppm_dlc.setponytype(self)
			end
		end)
	end)
	
	hook.Add("OnPlayerChangedTeam","ppm_dlc_hooks",function(self,old,new)
		timer.Simple(0.2,function()
			local check=ppm_dlc.IsPony(self)
			local type=self:GetNWInt("PONYTYPE",0)
			if check==4 and type==0 or check!=type then
				ppm_dlc.setponytype(self)
			end
		end)
	end)
end
concommand.Add("ppm_dlc_update",function(ply,cmd,args)
	if !ply:IsValid() then print'this is for players in game' return end
	local HOOK=hook.Run("ppm_dlc_cmd",ply)
	if !CONCMD and HOOK!=true or HOOK==false or timer.Exists(ply:SteamID64().." ppm reload cooldown") then return end
	if CLIENT then 
		RunConsoleCommand("cmd","ppm_dlc_update",args[1])--cmd forwards a command to the server
		return
	end
	ppm_dlc.setponytype(ply,tonumber(args[1]))
	timer.Create(ply:SteamID64().." ppm reload cooldown",3,1,function() end)
end)
function ppm_dlc.unicorn_power(self)
	local HOOK,msg=hook.Run("ppm_dlc_teleport_allow",self)
	local ID=self:SteamID64()
	if CLIENT then--serverside function only
	elseif !allow_unicorn and HOOK!=true or HOOK==false then
		self:PrintMessage(HUD_PRINTTALK,reason or allow_unicorn and "hook.Run(\"ppm_dlc_teleport_allow\",self) returned false" or "")
	elseif timer.Exists(ID.."teleport_cooldown") then
		self:PrintMessage(HUD_PRINTTALK,"please wait "..math.Round(timer.TimeLeft(self:SteamID64().."teleport_cooldown"),2).." seconds before before trying to teleport again")
	elseif self:GetNWInt("PONYTYPE",0)!=3 and self:GetNWInt("PONYTYPE",0)!=4 then
		self:PrintMessage(HUD_PRINTTALK,"only those with unicorn powers can teleport")
	else

		local pos = self:GetPos()
		local eyes = self:EyePos()
		local ang = self:EyeAngles()
		local fwd = ang:Forward()
		local filter = {self}
		if self:IsPlayer() and self:InVehicle() and self:GetVehicle():IsValid() then
			table.insert(filter, self:GetVehicle())
		end
		if SERVER and self:IsPlayer() then
			self:LagCompensation(true)
		end
		local tr = util.TraceLine{
			filter=filter,
			start=eyes-fwd*2,
			endpos = eyes+fwd*MAX_DISTANCE
		}
		local check=util.TraceLine{--this trace is just to check if we are trying to go through a wall
			filter=filter,
			start=eyes+fwd*2,
			endpos = eyes+fwd*3
		}
		if SERVER and self:IsPlayer() then
			self:LagCompensation(false)
		end
		local v=tr.HitNormal
		local z=v.z
		if check.StartSolid or check.Hit then--are trying to go through a wall?
			tr.HitPos=self.OldPos or tr.HitPos--send them to their previous location
			self:PrintMessage(HUD_PRINTTALK,"you were in a wall and teleported to your previous location")
		else
			local smin,smax=self:GetHull()
			local size=(smax-smin)*Vector(.75,.75,.65)
			local sizez=size.z*v.z-size.z
			size=size*v
			size.z=sizez
			tr.HitPos=tr.HitPos+size
			self.OldPos=self:GetPos()--store their previous location on them
		end
		if self:InVehicle() then self:ExitVehicle() end
		timer.Simple(0,function()--delay by one frame so that certain sit addons won't interfere
			self:SetPos(tr.HitPos)
			self:SetVelocity(vector_origin)
		end)
		timer.Create(ID.."Fall_immunity",Duration,1,function() end)
		timer.Create(ID.."teleport_cooldown",DELAY,1,function() end)
	end
end
concommand.Add("ppm_dlc_teleport",function(ply,cmd,args)
	if CLIENT then
		RunConsoleCommand("cmd","ppm_dlc_teleport")
		return
	end
	ppm_dlc.unicorn_power(ply)
end)
if CLIENT then
	hook.Add("UpdateAnimation","ppm_dlc_hooks",function(ply, vel, maxseqgroundspeed)
		local mdl,MOVETYPE=ply:GetModel(),ply:GetMoveType()
		if (MOVETYPE == MOVETYPE_FLY or MOVETYPE==MOVETYPE_FLYGRAVITY) and ply:GetNWString("Flying","")!=mdl then
			if ppm_models[mdl] then
				if string.find(mdl,"cppm") then
					ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_FLY, false )
				end
				ply:SetNWString("Flying",mdl)
			elseif pegasus[mdl] or pegasus_invert[mdl] or alicorns[mdl] then
				ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_GMOD_NOCLIP_LAYER, false )
				ply:SetNWString("Flying",mdl)
			end
		elseif MOVETYPE!=MOVETYPE_FLY and MOVETYPE!=MOVETYPE_FLYGRAVITY and ply:GetNWString("Flying","")!="" then
			ply:SetNWString("Flying","")
			ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
		end
	end)
	return
end
concommand.Add("ppm_dlc_refresh",function(ply,cmd,args)
	if ply and ply:IsValid() and !ply:IsSuperAdmin() then
		if !game.IsDedicated() and !ply:IsListenServerHost() or game.IsDedicated() then 
			return
		end
	end
	include("autorun/ppm_dlc_init.lua")
	BroadcastLua([[include("autorun/ppm_dlc_init.lua")]])
end)

function ppm_dlc.start_flying(ply)
	if ply:IsOnGround() then return end
	local HOOK,reason=hook.Run("ppm_dlc_flight_allow",ply)
	if !allow_pegasus and HOOK!=true or HOOK==false then
		ply:PrintMessage(HUD_PRINTTALK,reason or allow_pegasus and"hook.Run(\"ppm_dlc_flight_allow\",self) returned false"or"")
		return
	end
	ply:SetMoveType(MOVETYPE_FLY)
	ply:SetNWBool("ppm_dlc_flight",true)
	local mdl=ply:GetModel()
	if mdl=="models/spectrum_the_goddamed_horse_playermodel.mdl" then
		ply:SetBodygroup(2,0)
	elseif mdl=="models/dashe.mdl" then
		ply:SetBodygroup(3,1)
	elseif pegasus[mdl] or alicorns[mdl] then 
		ply:SetBodygroup(1,1)
	elseif pegasus_invert[mdl] then 
		ply:SetBodygroup(1,0)
	elseif ppm_models[mdl] then
		local g=ply:GetBodygroup(3)
		if g==0 and string.find(mdl,"cppm") then
			ply:SetBodygroup(3,2)
		elseif g==0 and string.find(mdl,"ppm_veh") then
			ply:SetBodygroup(3,1)
		elseif g==3 then
			ply:SetBodygroup(3,4)
		elseif g==5 then
			ply:SetBodygroup(3,6)
		end
	else
		ply:SetBodygroup(1,0)
	end
	return true
end
function ppm_dlc.stop_flying(ply)
	ply:SetMoveType(MOVETYPE_WALK)
	ply:SetNWBool("ppm_dlc_flight",false)
	local mdl=ply:GetModel()
	if mdl=="models/spectrum_the_goddamed_horse_playermodel.mdl" then
		ply:SetBodygroup(2,1)
	elseif mdl=="models/dashe.mdl" then
		ply:SetBodygroup(3,0)
	elseif pegasus[mdl] or alicorns[mdl] then 
		ply:SetBodygroup(1,0)
	elseif pegasus_invert[mdl] then 
		ply:SetBodygroup(1,1)
	elseif ppm_models[mdl] then
		local g=ply:GetBodygroup(3) 
		if g==2!=string.StartWith(mdl,"models/ppm_veh/player_default_") then
			ply:SetBodygroup(3,0)
		elseif g==4 then
			ply:SetBodygroup(3,3)
		elseif g==6 then
			ply:SetBodygroup(3,5)
		end
	end
	return true
end
hook.Add( "KeyPress", "ppm_dlc_hooks", function( ply, key )
	if key!=IN_JUMP then return end
	local MOVETYPE=ply:GetMoveType()
	if MOVETYPE==MOVETYPE_NOCLIP or MOVETYPE==MOVETYPE_NONE then return end
	local ID=ply:SteamID64()
	local PONYTYPE=ply:GetNWInt("PONYTYPE",0)
	if PONYTYPE==2 then--2 or 4 means wings
		if MOVETYPE==MOVETYPE_WALK or MOVETYPE==MOVETYPE_FLYGRAVITY then
			ppm_dlc.start_flying(ply)
		elseif (MOVETYPE==MOVETYPE_FLY or MOVETYPE==MOVETYPE_FLYGRAVITY) and !timer.Exists(ID.."doublespace") then
			timer.Create(ID.."doublespace",0.375,1,function() end)
		elseif MOVETYPE==MOVETYPE_FLY then
			ply:SetMoveType(MOVETYPE_FLYGRAVITY)
--			timer.Create(ID.."Fall_immunity",Duration,1,function() end)
		end
	elseif PONYTYPE==3 then--3 or 4 means horn
		if !ply:IsOnGround() or ply:KeyDown(IN_WALK) or ply:KeyDown(IN_DUCK) then
			ppm_dlc.unicorn_power(ply)
		end
	elseif PONYTYPE==4 then
		if ply:KeyDown(IN_WALK) or ply:KeyDown(IN_DUCK) then
			ppm_dlc.unicorn_power(ply)
		elseif !ply:IsOnGround() and !ply:KeyDown(IN_WALK) and !ply:KeyDown(IN_DUCK) then
			if MOVETYPE==MOVETYPE_WALK or MOVETYPE==MOVETYPE_FLYGRAVITY then
				if ppm_dlc.start_flying(ply) then return end
			elseif (MOVETYPE==MOVETYPE_FLY or MOVETYPE==MOVETYPE_FLYGRAVITY) and !timer.Exists(ID.."doublespace") then
				timer.Create(ID.."doublespace",0.375,1,function() end)
				return
			elseif MOVETYPE==MOVETYPE_FLY then
				ply:SetMoveType(MOVETYPE_FLYGRAVITY)
				timer.Create(ID.."Fall_immunity",Duration,1,function() end)
				return
			end
			ppm_dlc.unicorn_power(ply)
		end
	end
end)
hook.Add("KeyRelease","ppm_dlc_hooks",function(ply,key)
	if key==IN_WALK or key==IN_DUCK then
		ply.Teleport_charged=nil
	end
end)
hook.Add("PlayerTick","ppm_dlc_hooks",function(ply,mv)
	local MOVETYPE=ply:GetMoveType()
	if MOVETYPE != MOVETYPE_FLY and MOVETYPE!=MOVETYPE_FLYGRAVITY then return end
	local Velocity = ply:GetVelocity()
	if MOVETYPE==MOVETYPE_FLYGRAVITY then
		Velocity = LerpVector(0.35,Velocity,Vector(Velocity.x,Velocity.y,-200))
	end
	if ply:KeyDown(IN_JUMP) then
		if Velocity.z < 0 then
			Velocity = LerpVector(0.35,Velocity,Vector(Velocity.x,Velocity.y,0))
		end
		Velocity.z = Velocity.z + 5
	elseif ply:KeyDown(IN_DUCK) then
		if Velocity.z > 0 then
			Velocity = LerpVector(0.35,Velocity,Vector(Velocity.x,Velocity.y,0))
		end
		Velocity.z=Velocity.z - 5
	end
	if ply:KeyDown(IN_WALK) then
		Velocity = LerpVector(0.35,Velocity,vector_up*0)
	end
	mv:SetVelocity(Velocity)
	
	if ply:IsOnGround() or ply:WaterLevel() >= 2 then
		ppm_dlc.stop_flying(ply)
	end
end)
hook.Add("OnPlayerHitGround","ppm_dlc_hooks",function(ply)
	if ply and ply:SteamID64() then
		ppm_dlc.stop_flying(ply)
		local ID=ply:SteamID64().."Fall_immunity"
		if timer.Exists(ID) then
			timer.Remove(ID)
			return true
		end
	end
end)
hook.Add("EntityTakeDamage","ppm_dlc_hooks",function(victim,CTakeDamageInfo)
	if !DMG_mod then return end
	local attack=CTakeDamageInfo:GetAttacker()
	local weapon=CTakeDamageInfo:GetInflictor()
	local attack_PONYTYPE=attack:GetNWInt("PONYTYPE",0)
	local victim_PONYTYPE=victim:GetNWInt("PONYTYPE",0)

	if victim_PONYTYPE==0 then--non pony, no benefits or bad
		if attack_PONYTYPE==0 then--human on human
			CTakeDamageInfo:ScaleDamage(DMG_hvh)
		elseif attack_PONYTYPE==1 or attack_PONYTYPE==4 then--earth pony on human
			CTakeDamageInfo:ScaleDamage(DMG_evh)
		else--pegasus or unicorn on human
			CTakeDamageInfo:ScaleDamage(DMG_uvh)--pegasi and unicorns doing less damage to humans is a price to pay for improved mobility
		end
	elseif victim_PONYTYPE==1 or victim_PONYTYPE==4 then--earth pony
		if attack_PONYTYPE==0 then--human on earth pony
			CTakeDamageInfo:ScaleDamage(DMG_hve)
		elseif attack_PONYTYPE==1 or attack_PONYTYPE==4 then--earth pony on earth pony
			CTakeDamageInfo:ScaleDamage(DMG_eve)
		else--pegasus or unicorn on earth pony
			CTakeDamageInfo:ScaleDamage(DMG_uve)--pegasi and unicorns doing less damage to earth ponies is a price to pay for improved mobility
		end
	else--pegasus or unicorn
		if attack_PONYTYPE==0 then--human on pegasus or unicorn
			CTakeDamageInfo:ScaleDamage(DMG_hvu)--pegasi and unicorns taking more damage from humans is a price to pay for improved mobility
		elseif attack_PONYTYPE==1 or attack_PONYTYPE==4 then--earth pony on pegasus or unicorn
			CTakeDamageInfo:ScaleDamage(DMG_evu)--pegasi and unicorns taking more damage from earth ponies is a price to pay for improved mobility
		else--pegasus or unicorn on pegasus or unicorn
			CTakeDamageInfo:ScaleDamage(DMG_uvu)
		end
	end
end)
