local module = {}

export type AggroIntentRejectReason = "OUT_OF_RANGE" | "TARGET_DEAD"
									| "COOLDOWN_NOT_READY" | "INVALID_TARGET"
									| "INVALID_INPUT" | "SOURCE_VIEW_NOT_FOUND"
									| "INVALID_AGGRO_RANGE" | "OUT_OF_AGGRO_RANGE"
									| "SOURCE_INVALID" | "TARGET_INVALID"
									| "SOURCE_NOT_PLACED" | "TARGET_NOT_PLACED"
									| "TARGET_NOT_ENEMY" | "ALREADY_HAS_TARGET"
									| "BEHAVIOR_NOT_ALLOWED"

export type AggroPolicyType = "COMMAND" | "AUTO"
export type AggroIntentOriginType = "PLAYER" | "SYSTEM" | "DAMAGE_RECEIVED"

export type AggroIntentOrigin = {
	type : AggroIntentOriginType,
	playerId : string | nil
}

export type AggroIntent = {
	["delay"] : number,
	["eventType"] : "AggroIntent",
	["type"] : "EVENT",
	["data"] : {
		["source"] : string,
		["target"] : string,
		["origin"] : AggroIntentOrigin,
		["policy"] : AggroPolicyType
	},
	["isValid"] : boolean
}

export type AggroIntentRejected = {
	["delay"] : number,
	["eventType"] : "AggroIntentRejected",
	["type"] : "EVENT",
	["data"] : {
		["source"] : string,
		["target"] : string,

		["origin"] : AggroIntentOrigin,
		["reason"] : AggroIntentRejectReason
	},
	["isValid"] : boolean
}

export type AggroIntentAccepted = {
	["delay"] : number,
	["eventType"] : "AggroIntentAccepted",
	["type"] : "EVENT",
	["data"] : {
		["source"] : string,
		["target"] : string,
		["origin"] : AggroIntentOrigin,
	},
	["isValid"] : boolean
}

return module
