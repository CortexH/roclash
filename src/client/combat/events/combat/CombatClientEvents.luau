local module = {}

-- Eventos internos do frontend (não trafegam entre servidor e client).

export type damageIndicatorCreated = {
	time : number,
	eventType : "DamageIndicatorCreated",
	data : {
		unitId : string,
		amount : number
	}
}

export type unitRemoved = {
	time : number,
	eventType : "UnitRemoved",
	data : {
		unitId : string
	}
}

return module
