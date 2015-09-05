class "C4Spawner"

function C4Spawner:__init()
	self.timer = Timer()

	Events:Subscribe("PlayerQuit", self, self.PlayerQuit)
	Events:Subscribe("EntityDespawn", self, self.EntityDespawn)
	Events:Subscribe("ModuleUnload", self, self.ModuleUnload)
	Network:Subscribe("Spawn", self, self.Spawn)
	Network:Subscribe("Detonate", self, self.Detonate)
end

function C4Spawner:PlayerQuit(args)
	local player = args.player

	for k, c4 in pairs(C4Manager.C4) do
		if c4:GetOwner() == player then
			c4:Remove()
		end
	end
end

function C4Spawner:EntityDespawn(args)
	local entity = args.entity

	for k, c4 in pairs(C4Manager.C4) do
		local parent = c4:GetParent()

		if parent and parent.__type == entity.__type and parent == entity then
			c4:Remove()
		end
	end
end

function C4Spawner:ModuleUnload()
	for k, c4 in pairs(C4Manager.C4) do
		c4:Remove()
	end
end

function C4Spawner:Spawn(args, sender)
	args.values.type = C4.__type
	args.values.owner = sender

	WorldNetworkObject.Create(args):SetStreamDistance(500)
end

function C4Spawner:Detonate(args, sender)
	for k, c4 in pairs(C4Manager.C4) do
		if c4:GetOwner() == sender then
			c4:Detonate()
		end
	end
end

C4Spawner = C4Spawner()
