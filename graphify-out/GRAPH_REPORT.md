# Graph Report - C:\projects\roclash\src  (2026-07-21)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 957 nodes · 1026 edges · 231 communities (216 shown, 15 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 3 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `5e01d929`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- MathService.luau
- MovementDomainService.luau
- EntityEvent.luau
- ClientEventQueue.luau
- Position.luau
- UnitsBC.luau
- ListenUnitMoveCommand.luau
- EventQueue.luau
- UnitTarget.luau
- AggroDomainService.luau
- AggroScoringCalc.luau
- SelectUnit.luau
- PrimaryButton.luau
- UnitViewFactory.luau
- SpawnUnitInput.luau
- EventLog.luau
- ListenMovementResolvedEventCombat.luau
- StructureEntityMapper.luau
- QueueApplication.luau
- ModelsUtils.luau
- ClientCombatApplication.luau
- ClientQueueApplication.luau
- ClientEventLog.luau
- BattleHudScreen.luau
- CombatApplication.luau
- UnitService.luau
- AggroIntentSystem.luau
- PlacementResponseApplier.luau
- BattleHudController.luau
- GUIInitiator.luau
- ListenMovementSegment.luau
- MapGatewayImpl.luau
- ListenAggroCommand.luau
- _RenderPipeline.luau
- ProjectLauncherClientApplier.luau
- UnitSpawnClientApplier.luau
- Remotes.luau
- ListenAttackResolvedEvent.luau
- ListenDamageApplied.luau
- RadiusTypeImpactHandler.luau
- ListenGameBegin.luau

## God Nodes (most connected - your core abstractions)
1. `module.new()` - 7 edges
2. `heapUp()` - 5 edges
3. `heapUp()` - 5 edges
4. `module.handle()` - 5 edges
5. `module.handle()` - 5 edges
6. `module.beginSelect()` - 4 edges
7. `log()` - 4 edges
8. `heapDown()` - 4 edges
9. `formatCell()` - 4 edges
10. `verifyEventType()` - 4 edges

## Surprising Connections (you probably didn't know these)
- `module.buildDomainUnit()` --calls--> `unitEntity.new()`  [INFERRED]
  serverStorage/services/combatService/modules/entityModule/application/service/UnitService.luau → serverStorage/services/combatService/modules/entityModule/domain/entity/UnitEntity.luau
- `module.buildNotPlacedUnit()` --calls--> `unitEntity.newNotPlaced()`  [INFERRED]
  serverStorage/services/combatService/modules/entityModule/application/service/UnitService.luau → serverStorage/services/combatService/modules/entityModule/domain/entity/UnitEntity.luau
- `module.AStarPathRequest()` --calls--> `cellKey()`  [INFERRED]
  serverStorage/services/combatService/modules/npcModule/domain/service/PathService.luau → serverStorage/services/combatService/modules/entityModule/infrastructure/adapter/outbound/gateways/MapGatewayImpl.luau

## Import Cycles
- None detected.

## Communities (231 total, 15 thin omitted)

### Community 1 - "MathService.luau"
Cohesion: 0.09
Nodes (12): generateProjectileEventAOE(), generateProjectileEventSingle(), getProjectileTravelTime(), handleProjectileTypeAttack(), generateImpactEventAOE(), generateImpactEventSingle(), handleMeleeImpactEvent(), handleProjectileImpactEvent() (+4 more)

### Community 2 - "MovementDomainService.luau"
Cohesion: 0.10
Nodes (9): generateMovementStopped(), module.handle(), generateMovementEvent(), module.handle(), generateSegmentRequestEvent(), module.handle(), module.getUnitWalkSpeed(), module.timeToMoveToCell() (+1 more)

### Community 4 - "EntityEvent.luau"
Cohesion: 0.10
Nodes (4): generateEvent(), module.handle(), generateEnteredRangeEvent(), module.handle()

### Community 6 - "ClientEventQueue.luau"
Cohesion: 0.17
Nodes (7): heapDown(), heapSwap(), heapUp(), isLess(), module:enqueue(), module:enqueueInBatch(), module:pop()

### Community 7 - "Position.luau"
Cohesion: 0.16
Nodes (7): module:add(), module:div(), module:lerp(), module:mul(), module.new(), module:normalize(), module:sub()

### Community 8 - "UnitsBC.luau"
Cohesion: 0.15
Nodes (4): formatCell(), module:addActiveUnit(), module:getActiveUnitByCell(), module:unitChangedPosition()

### Community 9 - "ListenUnitMoveCommand.luau"
Cohesion: 0.20
Nodes (11): generateErrorMessage(), generateMoveEvent(), generateSuccessMessage(), module.handle(), module.validateSingleEventData(), validatePosition(), createEvent(), failCommand() (+3 more)

### Community 10 - "EventQueue.luau"
Cohesion: 0.20
Nodes (7): heapDown(), heapSwap(), heapUp(), isLess(), module:enqueue(), module:enqueueInBatch(), module:pop()

### Community 15 - "UnitTarget.luau"
Cohesion: 0.24
Nodes (3): module:removeTarget(), module:removeTargetCandidate(), removeFromList()

### Community 24 - "AggroDomainService.luau"
Cohesion: 0.36
Nodes (5): generateMovementResolvedEvent(), module.handle(), getNearestUnit(), module.getNearestUnitInAggroPath(), module.getNextAggroTarget()

### Community 27 - "SelectUnit.luau"
Cohesion: 0.43
Nodes (4): getIdFromUnit(), module.beginSelect(), module.onUnitDeselected(), module.onUnitSelected()

### Community 30 - "PrimaryButton.luau"
Cohesion: 0.60
Nodes (4): darken(), lighten(), module.create(), module.setBackgroundColor()

### Community 31 - "UnitViewFactory.luau"
Cohesion: 0.53
Nodes (5): createNpcView(), createView(), getMuzzle(), module.createNpc(), module.createStructure()

### Community 32 - "SpawnUnitInput.luau"
Cohesion: 0.47
Nodes (3): buildRequest(), module.beginSpawn(), triggerSpawn()

### Community 36 - "EventLog.luau"
Cohesion: 0.73
Nodes (5): log(), module.eventConsumed(), module.eventEnqueued(), module.eventFail(), verifyEventType()

### Community 40 - "StructureEntityMapper.luau"
Cohesion: 0.47
Nodes (4): getCell(), getCellNpc(), module.toNpcInbound(), module.toStructureInbound()

### Community 43 - "QueueApplication.luau"
Cohesion: 0.47
Nodes (3): module.enqueueEvent(), module.processEvent(), validateRequest()

### Community 45 - "ClientCombatApplication.luau"
Cohesion: 0.70
Nodes (3): module.loadBattle(), module.requestPing(), runPingSchedule()

### Community 47 - "ClientEventLog.luau"
Cohesion: 0.70
Nodes (4): log(), module.eventConsumed(), module.eventEnqueued(), module.eventFail()

### Community 49 - "BattleHudScreen.luau"
Cohesion: 0.70
Nodes (3): applyButtonConstraints(), createBehaviorButton(), module.build()

### Community 54 - "UnitService.luau"
Cohesion: 0.40
Nodes (4): module.buildDomainUnit(), module.buildNotPlacedUnit(), unitEntity.new(), unitEntity.newNotPlaced()

### Community 61 - "PlacementResponseApplier.luau"
Cohesion: 0.83
Nodes (3): fail(), module.apply(), success()

### Community 65 - "GUIInitiator.luau"
Cohesion: 0.83
Nodes (3): initBattleHud(), initBeforeCombatHUD(), module.init()

### Community 68 - "ListenMovementSegment.luau"
Cohesion: 0.83
Nodes (3): generateMovementResolvedEvent(), generateMovementStartedEvent(), module.handle()

### Community 76 - "ListenAggroCommand.luau"
Cohesion: 0.83
Nodes (3): generateCommandFailEvent(), generateCommandSuccessEvent(), module.handleEvent()

### Community 79 - "_RenderPipeline.luau"
Cohesion: 0.83
Nodes (3): module.process(), module.processInBatch(), module.renderEvents()

## Knowledge Gaps
- **15 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `module.AStarPathRequest()` connect `MapGatewayImpl.luau` to `NpcEventFactory.luau`?**
  _High betweenness centrality (0.001) - this node is a cross-community bridge._
- **Why does `unitEntity.new()` connect `UnitService.luau` to `UnitEntity.luau`?**
  _High betweenness centrality (0.001) - this node is a cross-community bridge._
- **Why does `unitEntity.newNotPlaced()` connect `UnitService.luau` to `UnitEntity.luau`?**
  _High betweenness centrality (0.001) - this node is a cross-community bridge._
- **Should `NpcEventFactory.luau` be split into smaller, more focused modules?**
  _Cohesion score 0.05042016806722689 - nodes in this community are weakly interconnected._
- **Should `MathService.luau` be split into smaller, more focused modules?**
  _Cohesion score 0.09032258064516129 - nodes in this community are weakly interconnected._
- **Should `MovementDomainService.luau` be split into smaller, more focused modules?**
  _Cohesion score 0.10098522167487685 - nodes in this community are weakly interconnected._
- **Should `UnitEntity.luau` be split into smaller, more focused modules?**
  _Cohesion score 0.07407407407407407 - nodes in this community are weakly interconnected._