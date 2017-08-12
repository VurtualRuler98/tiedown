--[[
Copyright 2017 vurtual 
VurtualRuler98@gmail.com
vurtual.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]--
if (SERVER) then
	AddCSLuaFile()
end
if (CLIENT) then
	SWEP.PrintName = "Push/Pull"
	SWEP.Author = "vurtual"
	SWEP.Slot = 0
	SWEP.SlotPos = 4
end
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Primary.Ammo=""
SWEP.Secondary.Ammo=""
SWEP.Primary.ClipSize=-1
SWEP.Secondary.ClipSize=-1
SWEP.Primary.Automatic=true
SWEP.Secondary.Automatic=true
SWEP.Primary.Delay=0.05
SWEP.Secondary.Delay=0.05
SWEP.HoldType="passive"
SWEP.MaxForce=7500
SWEP.PullForce=50
SWEP.KickForce=1000
SWEP.MaxKickForce=10000
SWEP.NextKick=0
function SWEP:Initialize()
end
function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
end
function SWEP:FindPushable(len)
	local tr=util.TraceLine({
		start=self.Owner:GetShootPos(),
		endpos=self.Owner:GetShootPos()+self.Owner:GetAimVector()*len,
		filter=self.Owner
	})
	if (IsValid(tr.Entity) and not tr.Entity:IsWorld() and not tr.Entity:IsPlayer()) then
		return tr
	end
	return nil
end
function SWEP:PushPull(len,force,pull,maxforce,kick)
	if (not self.Owner:IsOnGround()) then return end
	local tr=self:FindPushable(len)
	if (tr and tr.Entity:IsValid()) then
		if (kick) then self:EmitSound("flesh.ImpactHard") end
		if (self.Owner:GetGroundEntity()==tr.Entity) then return end
		if (SERVER and util.IsValidPhysicsObject(tr.Entity,tr.PhysicsBone)) then
			local phys=tr.Entity:GetPhysicsObjectNum(tr.PhysicsBone)
			if (phys) then
				local newforce=force*phys:GetMass()
				if (newforce>maxforce) then newforce=maxforce end
				if (phys:GetMass()>2500) then newforce=0 end
				if (pull) then newforce=newforce*-1 end
				if (phys:GetVelocity():Length()>50) then newforce=0 end
				local vec=self.Owner:GetAimVector()
				if (kick) then vec.z=0 end
				phys:ApplyForceCenter(vec*newforce)
			end
		end
	elseif (kick) then self:EmitSound("weapon_slam.satchelthrow") end
end
function SWEP:PrimaryAttack()
	self:PushPull(100,self.PullForce,false,self.MaxForce,false)
end
function SWEP:SecondaryAttack()
	self:PushPull(100,self.PullForce,true,self.MaxForce,false)
end
function SWEP:Reload()
	if (self.NextKick<CurTime()) then
		self:PushPull(100,self.KickForce,false,self.MaxKickForce,true)
		self.NextKick=CurTime()+1.5
	end
end
function SWEP:DrawWorldModel()
	return
end
