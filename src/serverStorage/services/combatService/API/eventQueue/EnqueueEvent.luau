local module = {
    enqueueEvent = function(item : {request}) end
}

export type event = {
	time: number?,
	delay : number?,
	eventType : string
}

export type request = {
	event: event,
	targetQueue: string
}

export type requestInBatch = {
	events : {event},
	targetQueue : string
}

export type response = {
	success: boolean,
	error: {string}?,
	eventId: string?
}



return module