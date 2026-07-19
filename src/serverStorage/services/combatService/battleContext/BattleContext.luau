local context = {}

local allContexts = script.Parent
local eventQueue = require(script.Parent.Parent.eventQueue.EventQueue)

function context.new(playerId : number, opponentId : number, snapshotNumber : number, attackerData, battleId)

	local tab = {}

	for _, v : Instance in allContexts:GetDescendants() do
		
		if(v:IsA("ModuleScript") == false) then continue end
		if v.Name == script.Name then continue end

		local module = require(v)

		if(module.contextName == nil) then
			warn("CONTEXT SEM NOME :: " .. v.Name)
			continue
		end
		
		tab[module.contextName] = module.new(playerId, opponentId, snapshotNumber, attackerData, battleId)
	end
	
	return tab
end

export type battleContext = typeof(context.new(1, 2, 3))

--[[
	
	ESTRUTURA DO BATTLE CONTEXT:
	
	context = {
		["contexto-tal"] = {},
		["contexto-tal2"] = {}
	}

]]

return context
