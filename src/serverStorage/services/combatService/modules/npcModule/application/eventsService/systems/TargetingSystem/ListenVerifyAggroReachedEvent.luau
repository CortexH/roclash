local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)
local mapPort = require(domain.ports.MapPort)

-- VerifyAggroReachedHandler
-- Estrutura preparada para o fluxo de verificação de aggro.
-- No futuro, este Handler será responsável por:
--   - verificar se o NPC realmente chegou próximo do aggro;
--   - caso tenha chegado, emitir AggroReachedEvent;
--   - caso ainda não tenha chegado, emitir um novo MovementIntent para continuar a movimentação.
-- Nesta primeira implementação, mantém o comportamento atual de verificação de range.
function module.handle(event : combatEventTypes.verifyAggroReachedEvent, context)
	if event.isValid == false then return {} end

	local unit = viewPort.getSelfBattleView(event.data.unitId, context)
	if not unit then return {} end
	if not unit.isAlive then return {} end

	local brain = brainPort.getNpcBrain(event.data.unitId, context)
	if not brain then return {} end

	local aggroId = brain:getAggro():getCurrentAggro()
	if not aggroId then return {} end

	local aggroView = viewPort.getUnitBattleView(unit.id, aggroId, context)
	if not aggroView then return {} end
	if not aggroView.isAlive then return {} end

	-- Se existe uma Wall bloqueando o acesso ao aggro, a unit deve
	-- resolver o blocker antes de adquirir o aggro como alvo de ataque.
	-- O blocker é resolvido pelo fluxo canônico (UnitStructureBlockingPathEvent),
	-- emitido pelo planning ou pelo ListenMovementIntent (caso ALREADY_AT_TARGET).
	local hasWall = mapPort.hasWallToward(unit.currentCell, aggroView.currentCell, context)
	if hasWall then return {} end

	if not aggroView.inRange then return {} end

	-- TODO: implementar a lógica completa de verificação (emitir novo MovementIntent caso não tenha chegado).
	return { eventService.targetAcquired(
		0,
		event.data.unitId,
		aggroId
	)}
end

return module