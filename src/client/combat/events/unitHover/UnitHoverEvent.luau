local module = {}

export type UnitHoverEvent = {
	delay : number,
	eventType : "UnitHoverClient",
	data : {
		unitId : string,
		hovering : boolean,
		-- Assinatura de quem originou o hover (ex.: UNIT_SELECT, UNIT_ATTACK_SELECT).
		signature : string
	}
}

return module
