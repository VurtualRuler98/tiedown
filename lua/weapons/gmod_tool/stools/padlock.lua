TOOL.Category = "Constraints"
TOOL.Name = "Padlock"
function TOOL:LeftClick(trace)
	return self:Padlock(trace,false)
end
function TOOL:RightClick(trace)
	return self:Padlock(trace,true)
end
function TOOL:Padlock(trace,rightclick)
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
		if (rightclick) then
			self:SetStage(2)
		else
			self:SetStage(1)
		end
		return true
	end
	if (inum == 1) then
		local ent1,ent2=self:GetEnt(1),self:GetEnt(2)
		local bone1,bone2=self:GetBone(1),self:GetBone(2)
		local tiedown
		if (self:GetStage()==1) then
			tiedown=constraint.Weld(ent1,ent2,bone1,bone2,0,false)
		end
		if (self:GetStage()==2) then
			tiedown=constraint.Rope(ent1,ent2,bone1,bone2,self:GetLocalPos(1),self:GetLocalPos(2),(self:GetPos(1)-self:GetPos(2)):Length(),0,0,1,"cable/rope",false,Color(255,255,255,255))
		end
		local padlock = ents.Create("sent_tiedown_padlock")
		local offset=Vector(trace.Normal)
		offset:Rotate(Angle(-90,0,0))
		offset=offset*5
		local ang=trace.Normal:Angle()
		ang=ang:SnapTo("x",360):SnapTo("y",360)
		if (not rightclick) then
			offset=offset-trace.Normal*2
		end
		if (rightclick) then
			offset=offset+trace.Normal*2
		end
		if (tiedown) then
			padlock:SetPos(trace.HitPos+offset) --test
			padlock:SetAngles(ang)
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

