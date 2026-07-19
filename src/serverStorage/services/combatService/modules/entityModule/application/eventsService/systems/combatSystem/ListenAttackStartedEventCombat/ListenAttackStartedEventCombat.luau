local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local deliveryTypeGenerator = require(script.Parent.DeliveryTypeGenerator)
local impactGenerator = require(script.Parent.ImpactGenerator)
local attackFinishedGenerator = require(script.Parent.AttackResolvedGenerator)

-- TODO: ao configurar ataque que tenha múltiplos hits,
-- validar também quando a entidade morrer durante os hits
-- (o ataque tem que ser finalizado antes do restante dos hits começarem)

function module.handle(event : eventType.attackStartedEvent, context)
	if event.isValid == false then return {} end

	local totalEvents = {}
	
	for _, v in deliveryTypeGenerator.generate(event, context) or {} do
		table.insert(totalEvents, v)
	end
	
	for _, v in impactGenerator.generate(event, context) or {} do
		table.insert(totalEvents, v)
	end
	
	table.insert(totalEvents, attackFinishedGenerator.generate(event, context))
	
	return totalEvents
end

return module
