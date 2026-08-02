local module = {}

-- Traduz o diff interno (estado observado) para uma lista de eventos
-- explicitamente destinados ao cliente (UI State).
function module.translateDiff(diff, currentTime)
	local translatedEvents = {}

	for _, unitDiff in pairs(diff) do
		table.insert(translatedEvents, {
			eventType = "UIStateUpdateResponse",
			delay = 0,
			data = {
				selectedUnit = {
					unitId = unitDiff.unitId,
					stats = {
						health = unitDiff.stats.health,
						maxHealth = unitDiff.stats.maxHealth
					},
					isDead = unitDiff.isDead
				}
			}
		})
	end

	return translatedEvents
end

return module
