AddCSLuaFile()
local ppm_dlc=ppm_dlc or {}
FLAGS={FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}
local CONCMD=CreateConVar("ppm_dlc_concmd_allow","1",FLAGS,[[if set to 1, updating your pony type via concommand will work unless hook.Run("ppm_dlc_concmd_allow",ply) returns false
otherwise it won't work unless hook.Run("ppm_dlc_concmd_allow",ply) returns true]]):GetBool()
local CHOICE=CreateConVar("ppm_dlc_concmd_choice","1",FLAGS,[[if set to 1, alicorns can specify what ability they want hook.Run("ppm_dlc_concmd_choice",ply,type) returns false
otherwise they can't work unless hook.Run("ppm_dlc_concmd_choice",ply,type) returns true]]):GetBool()
local DELAY=CreateConVar("ppm_dlc_teleprot_delay","3",FLAGS,[[how many seconds does a player have to wait after they teleport before they can teleport again?]]):GetFloat()
local MAX_DISTANCE = CreateConVar('ppm_dlc_teleport_distance','100',FLAGS,'how many meters can you go when teleporting?'):GetFloat()
local Duration = CreateConVar('ppm_dlc_fall_immunity','3',FLAGS,[[how many seconds after teleporting slash droping out of flight is a player immune to fall damage?
run ppm_dlc_refresh after changing]]):GetFloat()
local allow_unicorn=CreateConVar("ppm_dlc_teleport_allow","1",FLAGS,[[if set to 1, unicorns teleportation will unless hook.Run("ppm_dlc_teleport_allow",ply) returns false
otherwise it won't work unless hook.Run("ppm_dlc_teleport_allow",ply) returns true]]):GetBool()
local allow_pegasus=CreateConVar("ppm_dlc_flight_allow","1",FLAGS,[[if set to 1, unicorns teleportation will unless hook.Run("ppm_dlc_flight_allow",ply) returns false
otherwise it won't work unless hook.Run("ppm_dlc_flight_allow",ply) returns true]]):GetBool()
local ppm_models={--models associated with ppm
	["models/cppm/player_default_base.mdl"]=true,
	["models/cppm/player_default_base_nj.mdl"]=true,
	["models/cppm/player_default_base_ragdoll.mdl"]=true,
	["models/ppm/player_default_base.mdl"]=true,
	["models/ppm/player_default_base_nj.mdl"]=true,
	["models/ppm/player_default_base_ragdoll.mdl"]=true,
--	["models/ppm/player_mature_base.mdl"]=true,
}
--[[ local BODYGROUP_HORN = 2 local BODYGROUP_WING = 3]]

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
}
local pegasi={--a list of pegasus models
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
}
local alicorns={--a list of alicorn models
	["models/celestia_player.mdl"]=true,
	["models/luna_npc.mdl"]=true,
	["models/luna_player.mdl"]=true,
	["models/mlp/player_celestia.mdl"]=true,
	["models/mlp/player_celestia_nj.mdl"]=true,
	["models/mlp/player_luna.mdl"]=true,
	["models/mlp/player_luna_nj.mdl"]=true,
	["models/princesstwilight_player.mdl"]=true,
	["models/princesstwilight_npc.mdl"]=true,
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
		elseif pegasi[mdl] then return 2
		elseif earth[mdl] then return 1
		end
	end
	return 0
end
function ppm_dlc.setponytype(self,arg)

	local PONYTYPE=ppm_dlc.IsPony(self)

	local HOOK=hook.Run("ppm_dlc_concmd_choice",self,arg)
	local CAN=CHOICE and HOOK!=false or HOOK

	if PONYTYPE==4 and arg and CAN then--alicorns can specify what type they want to be
		PONYTYPE=math.Clamp(arg,1,3)
	elseif PONYTYPE==4 then
		PONYTYPE=math.random(1,3)--alicorns will get a random selection of earth pony, pegasus, or unicorn powers
	end
		
	self:SetNWInt("PONYTYPE",PONYTYPE)
	
	if self:GetMoveType()==MOVETYPE_FLY and PONYTYPE!=2 then--they changed out of pegasus while flying
		self:SetMoveType(MOVETYPE_WALK)--ground them
		local mdl=self:GetModel()
		if pegasi[mdl] or alicorns[mdl] then 
			self:SetBodygroup(1,0)
		elseif ppm_models[mdl] then
			local g=self:GetBodygroup(3)--3 is the wings of PPM wings 
			if g==2 then
				self:SetBodygroup(3,0)
			elseif g==4 then
				self:SetBodygroup(3,3)
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
	self:PrintMessage(HUD_PRINTTALK,"you are now a"..types[self:GetNWInt("PONYTYPE",0)])
end
if SERVER then
	hook.Add("PlayerSpawn","ppm_dlc_hooks",function(self)
		ppm_dlc.setponytype(self)
	end)
	hook.Add("OnPlayerChangedTeam","ppm_dlc_hooks",function(self,old,new)
		ppm_dlc.setponytype(self)
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
	local ID=self:SteamID64()
	if CLIENT then
		return 
	elseif timer.Exists(ID.."teleport_cooldown") then
		self:PrintMessage(HUD_PRINTTALK,"please wait "..math.Round(timer.TimeLeft(self:SteamID64().."teleport_cooldown"),2).." seconds before before trying to teleport again")
		return
	elseif self:GetNWInt("PONYTYPE",0)!=3 then
		self:PrintMessage(HUD_PRINTTALK,"only those with unicorn powers can teleport")
	end

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
	
	if SERVER and self:IsPlayer() then
		self:LagCompensation(false)
	end
	
	local v=tr.HitNormal
	local z=v.z
--	print(math.Round(v.x,1),math.Round(v.y,1),math.Round(z,1))
--	if tr.HitPos.z>=self:GetPos().z+72 then--are they trying to go up more than one players height?
	if math.Round(tr.HitNormal.z,1)<=0 then--
		tr.HitPos=tr.HitPos-Vector(0,0,72)*self:GetModelScale()--move the hitpos down by 72 Hammer units
	else
		tr.HitPos=tr.HitPos+Vector(0,0,5)*self:GetModelScale()--move the hitpos up by 5 Hammer units
	end
	if self:InVehicle() then self:ExitVehicle() end
	if tr.Fraction!=0 then
		self:SetPos(tr.HitPos)
	end
	timer.Create(ID.."Fall_immunity",Duration,1,function() end)
	timer.Create(ID.."teleport_cooldown",DELAY,1,function() end)
end
if CLIENT then
	return 
end
concommand.Add("ppm_dlc_refresh",function(ply,cmd,args)
	if ply and ply:IsValid() and !ply:IsSuperAdmin() then return end
	include("autorun/ppm_dlc_init.lua")
	BroadcastLua([[include("autorun/ppm_dlc_init.lua")]])
end)
hook.Add( "KeyPress", "ppm_dlc_hooks", function( ply, key )
	local MOVETYPE=ply:GetMoveType()
	if MOVETYPE==MOVETYPE_NOCLIP then return end
	local ID=ply:SteamID64()
	local EXIST=timer.Exists(ID.."doublespace")
	local PONYTYPE=ply:GetNWInt("PONYTYPE",0)
	if key==IN_WALK then
		ply.teleport_charged=true
	end
	if key == IN_JUMP and PONYTYPE==3 then--3 means unicorn
		local HOOK=hook.Run("ppm_dlc_teleport_allow",ply)
		if !allow_unicorn and HOOK!=true or HOOK==false then return end
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
			if pegasi[mdl] or alicorns[mdl] then 
				ply:SetBodygroup(1,1)
			elseif ppm_models[mdl] then
				local g=ply:GetBodygroup(3) 
				if g==0 then
					ply:SetBodygroup(3,2)
				elseif g==3 then
					ply:SetBodygroup(3,4)
				end
			end

		elseif MOVETYPE==MOVETYPE_FLY and !EXIST then
			timer.Create(ID.."doublespace",0.25,1,function() end)
		elseif MOVETYPE==MOVETYPE_FLY then
			ply:SetMoveType(MOVETYPE_WALK)
			local mdl=ply:GetModel()
			if pegasi[mdl] or alicorns[mdl] then 
				ply:SetBodygroup(1,0)
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
	end--[[
end)
timer.Create("ppm_dlc_checking_ground",5,1,function()
	for k,ply in ipairs(player.GetAll()) do
		local MOVETYPE=ply:GetMoveType()
		if MOVETYPE==MOVETYPE_FLY or MOVETYPE==MOVETYPE_FLYGRAVITY then
			if util.TraceLine({start=ply:GetPos(),endpos=ply:GetPos()-Vector(0,0,30)}).Hit then
				ply:SetMoveType(MOVETYPE_WALK)
			end
		end
	end]]
end)
hook.Add( "KeyRelease", "ppm_dlc_hooks", function( ply, key )
	if key==IN_WALK then
		ply.teleport_charged=nil
	end
end)
hook.Add("PlayerTick","ppm_dlc_hooks",function(ply,mv)
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
		if pegasi[mdl] or alicorns[mdl] then 
			ply:SetBodygroup(1,0)
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
hook.Add("OnPlayerHitGround","ppm_dlc_hooks",function(ply)
		if pegasi[mdl] or alicorns[mdl] then 
			ply:SetBodygroup(1,0)
		end
	local ID=ply:SteamID64().."Fall_immunity"
	if timer.Exists(ID) then
		timer.Remove(ID)
		return true
	end
end)
hook.Add("EntityTakeDamage","ppm_dlc_hooks",function(victim,CTakeDamageInfo)
	local attack=CTakeDamageInfo:GetAttacker()
	local weapon=CTakeDamageInfo:GetInflictor()
	local attack_PONYTYPE=attack:GetNWInt("PONYTYPE",0)
	local victim_PONYTYPE=victim:GetNWInt("PONYTYPE",0)

	local DMG_0t0=1	--human on human 

	local DMG_0t1=1.125	--earth pony on human

	local DMG_0t2=0.875	--pegasus or unicorn on human

	local DMG_1t0=0.875	--human on earth pony

	local DMG_1t1=1	--earth pony on earth pony

	local DMG_1t2=0.75	--pegasus or unicorn on earth pony

	local DMG_2t0=1.125	--human on pegasus or unicorn

	local DMG_2t1=1.25	--earth pony on pegasus or unicorn

	local DMG_2t2=1	--pegasus or unicorn on pegasus or unicorn

	if victim_PONYTYPE==0 then--non pony, no benefits or bad
		if attack_PONYTYPE==0 then--human on human
--			CTakeDamageInfo:ScaleDamage(DMG_0t0)
		elseif attack_PONYTYPE==1 then--earth pony on human
			CTakeDamageInfo:ScaleDamage(DMG_0t1)
		else--pegasus or unicorn on human
			CTakeDamageInfo:ScaleDamage(DMG_0t2)--pegasi and unicorns doing less damage to humans is a price to pay for improved mobility
		end
	elseif victim_PONYTYPE==1 then--earth pony
		if attack_PONYTYPE==0 then--human on earth pony
			CTakeDamageInfo:ScaleDamage(DMG_1t0)
		elseif attack_PONYTYPE==1 then--earth pony on earth pony
--			CTakeDamageInfo:ScaleDamage(DMG_1t1)
		else--pegasus or unicorn on earth pony
			CTakeDamageInfo:ScaleDamage(DMG_1t2)--pegasi and unicorns doing less damage to earth ponies is a price to pay for improved mobility
		end
	else--pegasus or unicorn
		if attack_PONYTYPE==0 then--human on pegasus or unicorn
			CTakeDamageInfo:ScaleDamage(DMG_2t0)--pegasi and unicorns taking more damage from humans is a price to pay for improved mobility
		elseif attack_PONYTYPE==1 then--earth pony on pegasus or unicorn
			CTakeDamageInfo:ScaleDamage(DMG_2t1)--pegasi and unicorns taking more damage from earth ponies is a price to pay for improved mobility
		else--pegasus or unicorn on pegasus or unicorn
--			CTakeDamageInfo:ScaleDamage(DMG_2t2)
		end
	end
end)