local module = {}

function module.apply(event, context)
	event.shouldRender = true
end

return module
