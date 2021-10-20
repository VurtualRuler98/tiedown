ENT.Type = "Anim"
ENT.Base = "base_gmodentity"
ENT.PrintName		= "Padlock"
ENT.Spawnable = false
ENT.AdminSpawnable = false
if (CLIENT) then
function ENT:Draw()
	self:DrawModel()
end
end
if (SERVER) then
AddCSLuaFile()

function ENT:SpawnFunction(ply, tr)
	if (!tr.HitWorld) then return end

	local ent = ents.Create("sent_tiedown_padlock")
	ent:SetPos(tr.HitPos + Vector(0, 0, 15))
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	self:SetModel( "models/props_wasteland/prison_padlock001a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetMaxHealth(5)
	self:SetHealth(5)
	self:PrecacheGibs()
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
end

function ENT:Think()
end

function ENT:OnRemove()
	local weldent = self:GetNWEntity("weldent")
	if (SERVER and IsValid(weldent)) then
		weldent:Remove()
	end
end

function ENT:Use(activator,caller,usetype,value)
end

function ENT:OnTakeDamage(dmginfo)
	self:SetHealth(self:Health()-dmginfo:GetDamage())
	if (self:Health()<=0) then
		self:GibBreakClient(Vector())
		self:Remove()
	end
end

