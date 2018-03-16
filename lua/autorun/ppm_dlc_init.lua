AddCSLuaFile()

local ppm_dlc=ppm_dlc or {}
FLAGS={FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}
local CONCMD=CreateConVar("ppm_dlc_concmd_allow","1",FLAGS,[[if set to 1, updating your pony type via concommand will work unless hook.Run("ppm_dlc_concmd_allow",ply) returns false
otherwise it won't work unless hook.Run("ppm_dlc_concmd_allow",ply) returns true]]):GetBool()
local CHOICE=CreateConVar("ppm_dlc_choice_allow","1",FLAGS,[[if set to 1, alicorns can specify what ability they want hook.Run("ppm_dlc_choice_allow",ply,type) returns false
otherwise they can't work unless hook.Run("ppm_dlc_choice_allow",ply,type) returns true]]):GetBool()
local DELAY=CreateConVar("ppm_dlc_teleport_delay","3",FLAGS,[[how many seconds does a player have to wait after they teleport before they can teleport again?]]):GetFloat()
local MAX_DISTANCE = CreateConVar('ppm_dlc_teleport_distance','100',FLAGS,'how many meters can you go when teleporting?'):GetFloat()
local Duration = CreateConVar('ppm_dlc_fall_immunity','2',FLAGS,[[how many seconds after teleporting slash droping out of flight is a player immune to fall damage?
run ppm_dlc_refresh after changing]]):GetFloat()
local allow_unicorn=CreateConVar("ppm_dlc_teleport_allow","1",FLAGS,[[if set to 1, unicorns teleportation will unless hook.Run("ppm_dlc_teleport_allow",ply) returns false
otherwise it won't work unless hook.Run("ppm_dlc_teleport_allow",ply) returns true]]):GetBool()
local allow_pegasus=CreateConVar("ppm_dlc_flight_allow","1",FLAGS,[[if set to 1, unicorns teleportation will unless hook.Run("ppm_dlc_flight_allow",ply) returns false
otherwise it won't work unless hook.Run("ppm_dlc_flight_allow",ply) returns true]]):GetBool()

local DMG_mod=CreateConVar("ppm_dlc_dmg_mod","1",FLAGS,[[enable/disable damage modifiers]]):GetBool()
local DMG_hvh=CreateConVar("ppm_dlc_dmg_hvh","1",FLAGS,"damage modifier for non ponies damaging non ponies"):GetFloat()	--human on human 
local DMG_evh=CreateConVar("ppm_dlc_dmg_evh","1.125",FLAGS,"damage modifier for earth ponies damaging non ponies"):GetFloat()	--earth pony on human
local DMG_uvh=CreateConVar("ppm_dlc_dmg_uvh","0.875",FLAGS,"damage modifier for pegasi and unicorns damaging non ponies"):GetFloat()	--pegasus or unicorn on human
local DMG_hve=CreateConVar("ppm_dlc_dmg_hve","0.875",FLAGS,"damage modifier for non ponies damaging earth ponies"):GetFloat()	--human on earth pony
local DMG_eve=CreateConVar("ppm_dlc_dmg_eve","1",FLAGS,"damage modifier for earth ponies damaging earth ponies"):GetFloat()	--earth pony on earth pony
local DMG_uve=CreateConVar("ppm_dlc_dmg_uve","0.75",FLAGS,"damage modifier for pegasi and unicorns damaging earth ponies"):GetFloat()	--pegasus or unicorn on earth pony
local DMG_hvu=CreateConVar("ppm_dlc_dmg_hvu","1.125",FLAGS,"damage modifier for non ponies damaging pegasi and unicorns"):GetFloat()	--human on pegasus or unicorn
local DMG_evu=CreateConVar("ppm_dlc_dmg_evu","1.25",FLAGS,"damage modifier for earth ponies damaging pegasi and unicorns"):GetFloat()	--earth pony on pegasus or unicorn
local DMG_uvu=CreateConVar("ppm_dlc_dmg_uvu","1",FLAGS,"damage modifier for pegasi and unicorns damaging pegasi and unicorns"):GetFloat()	--pegasus or unicorn on pegasus or unicorn
--wow, I unwittingly spelled "huehuehue" somewhere in this file, can you find it?

local ppm_models={--models associated with ppm
	["models/cppm/player_default_base.mdl"]=true,
	["models/cppm/player_default_base_nj.mdl"]=true,
	["models/cppm/player_default_base_ragdoll.mdl"]=true,
	["models/ppm/player_default_base.mdl"]=true,
	["models/ppm/player_default_base_nj.mdl"]=true,
	["models/ppm/player_default_base_ragdoll.mdl"]=true,
--	["models/ppm/player_mature_base.mdl"]=true,--
}
--local BODYGROUP_HORN,BODYGROUP_WING=2,3
local earth={--a list of earth pony models
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
	["models/celestia_player.mdl"]=true,
	["models/luna_npc.mdl"]=true,
	["models/luna_player.mdl"]=true,
	["models/princesstwilight_player.mdl"]=true,
	["models/princesstwilight_npc.mdl"]=true,
	["models/twilance_player.mdl"]=true,

	
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
			if ppm_dlc.HasWings(self) and ppm_dlc.HasHorn(self) then--wings+horn=alicorn
				return 4
			elseif ppm_dlc.HasHorn(self) then--horn=unicorn
				return 3
			elseif ppm_dlc.HasWings(self) then--wings=pegasus
				return 2
			end
			return 1
		elseif alicorns[mdl] then return 4
		elseif unicorns[mdl] then return 3
		elseif pegasus[mdl] or pegasus_invert[mdl] then return 2
		elseif earth[mdl] then return 1
		end
	end
	return 0
end
function ppm_dlc.setponytype(ply,arg)
	if ply and ply:IsValid() then
		local PONYTYPE=ppm_dlc.IsPony(ply)

		local HOOK=hook.Run("ppm_dlc_choice_allow",ply,arg)
		local CAN=CHOICE and HOOK!=false or HOOK

		if PONYTYPE==4 and arg and CAN then--alicorns can specify what type they want to be
			PONYTYPE=math.Clamp(arg,1,3)
		elseif PONYTYPE==4 then
			PONYTYPE=math.random(1,3)--alicorns will get a random selection of earth pony, pegasus, or unicorn powers
		end
			
		ply:SetNWInt("PONYTYPE",PONYTYPE)
		
		if !ply:IsPlayer() then return end
		
		if ply:GetMoveType()==MOVETYPE_FLY and PONYTYPE!=2 then--they changed out of pegasus while flying
			ply:SetMoveType(MOVETYPE_WALK)--ground them
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
				local g=ply:GetBodygroup(3)--3 is the wings of PPM wings 
				if g==2 then
					ply:SetBodygroup(3,0)
				elseif g==4 then
					ply:SetBodygroup(3,3)
				end
			end
		end
		
		local types={
			[0]=" nonpony",
			[1]='n earth pony',
			[2]=' pegasus',
			[3]=' unicorn',
			[4]='n alicorn',
		}
		ply.OldPos=ply:GetPos()
		ply:PrintMessage(HUD_PRINTTALK,"you are now a"..types[ply:GetNWInt("PONYTYPE",0)])
	end
end
if SERVER then
	hook.Add("PlayerSpawn","_ppm_dlc_hooks",function(self)
		timer.Simple(0.1,function()
			ppm_dlc.setponytype(self)
		end)
	end)
	hook.Add("OnPlayerChangedTeam","_ppm_dlc_hooks",function(self,old,new)
		timer.Simple(0.1,function()
			ppm_dlc.setponytype(self)
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
		self:PrintMessage(HUD_PRINTTALK,(msg or "you cannot teleport"))
	elseif timer.Exists(ID.."teleport_cooldown") then
		self:PrintMessage(HUD_PRINTTALK,"please wait "..math.Round(timer.TimeLeft(self:SteamID64().."teleport_cooldown"),2).." seconds before before trying to teleport again")
	elseif self:GetNWInt("PONYTYPE",0)!=3 then
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
			endpos = eyes+fwd*MAX_DISTANCE*40
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
	--	print(math.Round(v.x,1),math.Round(v.y,1),math.Round(z,1))
		
		if check.StartSolid or check.Hit then--are trying to go through a wall?
			tr.HitPos=self.OldPos or tr.HitPos--send them to their previous location
			self:PrintMessage(HUD_PRINTTALK,"you were in a wall and teleported to your previous location")
		elseif math.Round(tr.HitNormal.z,1)<0 then
			tr.HitPos=tr.HitPos-Vector(0,0,72)*self:GetModelScale()--move the hitpos down by 72 Hammer units
			self.OldPos=self:GetPos()--store their previous location on them
		elseif math.Round(tr.HitNormal.z,1)>0 then
			tr.HitPos=tr.HitPos+Vector(0,0,5)*self:GetModelScale()--move the hitpos up by 5 Hammer units
			self.OldPos=self:GetPos()
		else
			self.OldPos=self:GetPos()
		end

		if self:InVehicle() then self:ExitVehicle() end

		timer.Simple(0,function()--delay by one frame so that certain sit addons won't interfere
			self:SetPos(tr.HitPos)
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
	hook.Add("UpdateAnimation","_ppm_dlc_hooks",function(ply, vel, maxseqgroundspeed)
		local mdl=ply:GetModel()
		if ply:GetMoveType() == MOVETYPE_FLY and ply:GetNWString("Flying","")!=mdl then
			if ppm_models[mdl] then
				if string.find(mdl,"cppm") then
					ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_FLY, false )
				end
				ply:SetNWString("Flying",mdl)
			elseif pegasus[mdl] or pegasus_invert[mdl] or alicorns[mdl] then
				ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_GMOD_NOCLIP_LAYER, false )
				ply:SetNWString("Flying",mdl)
			end
		elseif ply:GetMoveType()!=MOVETYPE_FLY and ply:GetNWString("Flying","")!="" then
			ply:SetNWString("Flying","")
			ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
		end
	end)
	return
end
concommand.Add("ppm_dlc_refresh",function(ply,cmd,args)
	if ply and ply:IsValid() and !ply:IsSuperAdmin() and !ply:IsListenServerHost() then return end
	include("autorun/ppm_dlc_init.lua")
	BroadcastLua([[include("autorun/ppm_dlc_init.lua")]])
end)
hook.Add( "KeyPress", "_ppm_dlc_hooks", function( ply, key )
	local MOVETYPE=ply:GetMoveType()
	if MOVETYPE==MOVETYPE_NOCLIP then return end
	local ID=ply:SteamID64()
	local PONYTYPE=ply:GetNWInt("PONYTYPE",0)
	if key==IN_WALK then
		ply.teleport_charged=true
	end
	if key == IN_JUMP and PONYTYPE==3 then--3 means unicorn
		if ply.teleport_charged or !ply:IsOnGround() then
			ppm_dlc.unicorn_power(ply)
			ply.teleport_charged=nil
			ply:SetVelocity(Vector(0,0,0))
		end
	elseif key == IN_JUMP and PONYTYPE==2 and !ply:IsOnGround() then--2 means pegasus
		local HOOK=hook.Run("ppm_dlc_flight_allow",ply)
		if !allow_pegasus and HOOK!=true or !HOOK==false then return end
		
		if MOVETYPE==MOVETYPE_WALK then
			ply:SetMoveType(MOVETYPE_FLY)
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
				elseif g==3 then
					ply:SetBodygroup(3,4)
				end
			end

		elseif MOVETYPE==MOVETYPE_FLY and !timer.Exists(ID.."doublespace") then
			timer.Create(ID.."doublespace",0.25,1,function() end)
		elseif MOVETYPE==MOVETYPE_FLY then
			ply:SetMoveType(MOVETYPE_WALK)
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
				if g==2 then
					ply:SetBodygroup(3,0)
				elseif g==4 then
					ply:SetBodygroup(3,3)
				end
			end
			timer.Create(ID.."Fall_immunity",Duration,1,function() end)
		end
	end
end)

hook.Add("KeyRelease", "_ppm_dlc_hooks", function( ply, key )
	if key==IN_WALK then
		ply.teleport_charged=nil
	end
end)
hook.Add("PlayerTick","_ppm_dlc_hooks",function(ply,mv)
	if ply:GetMoveType() != MOVETYPE_FLY then return end
	local Velocity = ply:GetVelocity()
	if ply:KeyDown(IN_JUMP) then
		if Velocity.z < 0 then
			Velocity = LerpVector(0.35,Velocity,Vector(Velocity.x,Velocity.y,0))
		end
		Velocity.z = Velocity.z + 5
	elseif ply:KeyDown(IN_WALK) then
		Velocity = LerpVector(0.35,Velocity,vector_origin)
	elseif ply:KeyDown(IN_DUCK) then
		if Velocity.z > 0 then
			Velocity = LerpVector(0.35,Velocity,Vector(Velocity.x,Velocity.y,0))
		end
		Velocity.z = Velocity.z - 5
	end
	mv:SetVelocity(Velocity)
	
	if ply:IsOnGround() or ply:WaterLevel() >= 2 then
		ply:SetMoveType(MOVETYPE_WALK)
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
			if g==2 then
				ply:SetBodygroup(3,0)
			elseif g==4 then
				ply:SetBodygroup(3,3)
			end
		end
	end
end)
hook.Add("OnPlayerHitGround","_ppm_dlc_hooks",function(ply)
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
		if g==2 then
			ply:SetBodygroup(3,0)
		elseif g==4 then
			ply:SetBodygroup(3,3)
		end
	end
	local ID=ply:SteamID64().."Fall_immunity"
	if timer.Exists(ID) then
		timer.Remove(ID)
		return true
	end
end)
hook.Add("OnEntityCreated","_ppm_dlc_hooks",function(ent)
    timer.Simple(0,function()
		if ent and ent:IsValid() then
			ppm_dlc.setponytype(ent)
		end
    end)
end)
hook.Add("Initialize","_ppm_dlc_hooks",function()
	if CPPM then
		RunConsoleCommand("cppm_allowfly","0")
	end
end)
hook.Add("EntityTakeDamage","_ppm_dlc_hooks",function(victim,CTakeDamageInfo)
	if !DMG_mod then return end
	local attack=CTakeDamageInfo:GetAttacker()
	local weapon=CTakeDamageInfo:GetInflictor()
	local attack_PONYTYPE=attack:GetNWInt("PONYTYPE",0)
	local victim_PONYTYPE=victim:GetNWInt("PONYTYPE",0)

	if victim_PONYTYPE==0 then--non pony, no benefits or bad
		if attack_PONYTYPE==0 then--human on human
			CTakeDamageInfo:ScaleDamage(DMG_hvh)
		elseif attack_PONYTYPE==1 then--earth pony on human
			CTakeDamageInfo:ScaleDamage(DMG_evh)
		else--pegasus or unicorn on human
			CTakeDamageInfo:ScaleDamage(DMG_uvh)--pegasi and unicorns doing less damage to humans is a price to pay for improved mobility
		end
	elseif victim_PONYTYPE==1 then--earth pony
		if attack_PONYTYPE==0 then--human on earth pony
			CTakeDamageInfo:ScaleDamage(DMG_hve)
		elseif attack_PONYTYPE==1 then--earth pony on earth pony
			CTakeDamageInfo:ScaleDamage(DMG_eve)
		else--pegasus or unicorn on earth pony
			CTakeDamageInfo:ScaleDamage(DMG_uve)--pegasi and unicorns doing less damage to earth ponies is a price to pay for improved mobility
		end
	else--pegasus or unicorn
		if attack_PONYTYPE==0 then--human on pegasus or unicorn
			CTakeDamageInfo:ScaleDamage(DMG_hvu)--pegasi and unicorns taking more damage from humans is a price to pay for improved mobility
		elseif attack_PONYTYPE==1 then--earth pony on pegasus or unicorn
			CTakeDamageInfo:ScaleDamage(DMG_evu)--pegasi and unicorns taking more damage from earth ponies is a price to pay for improved mobility
		else--pegasus or unicorn on pegasus or unicorn
			CTakeDamageInfo:ScaleDamage(DMG_uvu)
		end
	end
end)