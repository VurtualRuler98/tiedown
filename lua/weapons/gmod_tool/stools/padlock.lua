TOOL.Category = "Constraints"
TOOL.Name = "Padlock"
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
		local padlock = ents.Create("sent_tiedown_padlock")
		local offset=Vector(trace.Normal)
		if (tiedown) then
			offset:Rotate(Angle(90,0,0))
			padlock:SetPos(trace.HitPos+trace.Normal*2+offset*5) --test
			padlock:SetAngles(trace.Normal:Angle())
			padlock:Spawn()
			local padlockweld=constraint.Weld(padlock,ent2,0,bone2,0,true)
			if (padlock and padlockweld) then
				tiedown.Type = "Padlock"
				padlockweld.Type = "Padlock"
				undo.Create("Tiedown")
					undo.AddEntity(tiedown)
					undo.AddEntity(padlock)
					undo.AddEntity(padlockweld)
					undo.SetPlayer(self:GetOwner())
				undo.Finish()
				self:GetOwner():AddCleanup("constraints",tiedown)
				self:GetOwner():AddCleanup("constraints",padlock)
				self:GetOwner():AddCleanup("constraints",padlockweld)
			end
			padlock:SetNWEntity("weldent",tiedown)
		end
		self:ClearObjects()
	end
	return true
end

function TOOL:Reload(trace)
end

function TOOL:Holster()
	self:ClearObjects()
end

