local module = {}

export type unitDiedNotificationEvent = {
	eventType : "UnitDiedNotificationEvent",
	delay : number,
	type : "EVENT",
	data : {
		unitId : string,
		killerUnitId : string
	}
}

return module
