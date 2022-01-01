CreateConVar("cl_toolgun_allow_use_pickup","1",FCVAR_ARCHIVE+FCVAR_USERINFO+FCVAR_CLIENTCMD_CAN_EXECUTE,"Allow use-pickup while wielding the toolgun.",0,1)
CreateConVar("cl_toolgun_allow_use","1",FCVAR_ARCHIVE+FCVAR_USERINFO+FCVAR_CLIENTCMD_CAN_EXECUTE,"Allow use while wielding the toolgun.",0,1)
if (SERVER) then
	hook.Add("AllowPlayerPickup","ToolgunDisablePickup",function(ply,ent)
		if (ply:GetActiveWeapon():GetClass()=="gmod_tool" and ply:GetInfoNum("cl_toolgun_allow_use_pickup",1)==0) then
			return false
		end
	end)
	hook.Add("PlayerUse","ToolgunDisableUse",function(ply,ent)
		if (ply:GetActiveWeapon():GetClass()=="gmod_tool" and ply:GetInfoNum("cl_toolgun_allow_use",1)==0) then
			return false
		end
	end)
end
