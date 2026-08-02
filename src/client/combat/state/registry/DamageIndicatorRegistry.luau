local module = {}

local httpService = game:GetService("HttpService")

module.registry = {}

export type damageIndicator = {
	id : string,
	unitId : string,
	amount : number,
	startTime : number,
	duration : number,
	component : any?
}

function module.create(unitId : string, amount : number, startTime : number) : damageIndicator
	return {
		id = httpService:GenerateGUID(false),
		unitId = unitId,
		amount = amount,
		startTime = startTime,
		duration = 1
	}
end

function module.getAll() : { [string] : damageIndicator }
	return module.registry
end

function module.register(id : string, indicator : damageIndicator)
	module.registry[id] = indicator
end

function module.unregister(id : string)
	module.registry[id] = nil
end

function module.get(id : string) : damageIndicator?
	return module.registry[id]
end

-- Remove todos os indicadores de uma unit (ex: quando a unit é removida do mundo).
function module.removeByUnit(unitId : string)
	for id, indicator in pairs(module.registry) do
		if indicator.unitId == unitId then
			if indicator.component then
				indicator.component:destroy()
			end
			module.registry[id] = nil
		end
	end
end

return module
