local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.MovementIntentEvent)
local eventService = require(domain.service.NpcEventFactory)

local viewPort = require(domain.ports.BattleViewPort)

-- MovementIntentRejectedHandler
-- Trata os motivos de rejeição do MovementIntent.
-- Apenas o motivo ALREADY_AT_TARGET possui comportamento adicional:
-- reconhece que a movimentação não é necessária e emite um VerifyAggroReachedEvent,
-- para que o fluxo de verificação de objetivo continue.
-- Não altera estado do mundo e não emite AggroReachedEvent diretamente.
function module.handle(event : intentTypes.MovementIntentRejected, context)
	if event.isValid == false then return {} end

	if event.data.reason ~= "ALREADY_AT_TARGET" then
		return {}
	end

	-- O VerifyAggroReachedEvent carrega a movementVersion atual da entidade
	-- para que, se o estado estrutural mudar (ex: novo aggro), o evento antigo
	-- seja invalidado pela validação de versão.
	-- A versão é obtida via BattleViewPort (getUnitVersionView), sem acesso
	-- direto ao UnitsBC pelo NpcModule.
	local versionView = viewPort.getUnitVersionView(event.data.unitId, context)
	if not versionView then return {} end

	return {eventService.createVerifyAggroReachedEvent(0, event.data.unitId, versionView.movementVersion)}
end

return module