TOOL.Category = "Constraints"
TOOL.Name = "Tiedown"
function TOOL:LeftClick(trace)
	if (IsValid(trace.Entity) and trace.Entity:IsPlayer()) then return end
	if (SERVER and not util.IsValidPhysicsObject(trace.Entity,trace.PhysicsBone)) then return end
	local phys = trace.Entity:GetPhysicsObjectNum(trace.PhysicsBone)
	local inum = self:NumObjects()
	self:SetObject(inum+1,trace.Entity,trace.HitPos,phys,trace.PhysicsBone,trace.HitNormal)
	if (CLIENT) then
		if (inum > 0 ) then self:ClearObjects() end
		return true
	end
	self:SetOperation(1)
	if (inum == 0) then
		self:SetStage(1)
		return true
	end
	if (inum == 1) then
		local ent1,ent2=self:GetEnt(1),self:GetEnt(2)
		local bone1,bone2=self:GetBone(1),self:GetBone(2)
		local tiedown=constraint.Weld(ent1,ent2,bone1,bone2,0,false)
		if (tiedown) then
			tiedown.Type = "Tiedown"
			undo.Create("Tiedown")
				undo.AddEntity(tiedown)
				undo.SetPlayer(self:GetOwner())
			undo.Finish()
			self:GetOwner():AddCleanup("constraints",tiedown)
		end
		self:ClearObjects()
	end
	return true
end

function TOOL:Reload(trace)
	if (not IsValid(trace.Entity) or trace.Entity:IsPlayer()) then return false end
	if (CLIENT) then return false end
	self:ClearObjects()
	return constraint.RemoveConstraints(trace.Entity,"Tiedown")
end

function TOOL:Holster()
	self:ClearObjects()
end

