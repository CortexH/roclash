local module = {}

module.registry = {}

export type deadUnit = {
	unitId : string,
	deathTime : number,
	duration : number
}

function module.register(unitId : string, deathTime : number, duration : number)
	module.registry[unitId] = {
		unitId = unitId,
		deathTime = deathTime,
		duration = duration
	}
end

function module.unregister(unitId : string)
	module.registry[unitId] = nil
end

function module.getAll() : { [string] : deadUnit }
	return module.registry
end

return module
