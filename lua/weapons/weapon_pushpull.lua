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
SWEP.MaxForce=15000
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
	if (IsValid(tr.Entity) and not tr.Entity:IsWorld() and not tr.Entity:IsPlayer() and util.IsValidPhysicsObject(tr.Entity,tr.PhysicsBone)) then
		return tr
	end
	return nil
end
function SWEP:PushPull(len,pull)
	local force=50
	if (CLIENT) then return end
	local tr=self:FindPushable(len)
	if (tr) then
		local phys=tr.Entity:GetPhysicsObjectNum(tr.PhysicsBone)
		if (phys) then
			local newforce=force*phys:GetMass()
			if (newforce>self.MaxForce) then newforce=self.MaxForce end
			if (pull) then newforce=newforce*-1 end
			if (phys:GetVelocity():Length()>50) then newforce=0 end
			phys:ApplyForceCenter(self.Owner:GetAimVector()*newforce)
		end
	end
end
function SWEP:PrimaryAttack()
	self:PushPull(100,false)
end
function SWEP:SecondaryAttack()
	self:PushPull(100,true)
end
function SWEP:DrawWorldModel()
	return
end
