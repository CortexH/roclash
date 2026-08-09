# DEBITOS TECNICOS

## [] Ajustar Movement Intent / planning

A ideia é ajustar o movementIntent e movementPlanning para ser consumido apenas pelo npcModule, removendo completamente essa responsabilidade do entityModule

## Ajustar InteractionModule -> 'ListenUnitSelectQuery' para receber 'canAttack' e 'canAggro'

## Automação de Testes de Regressão

O projeto não possui suíte de testes de regressão. Para implementá-la, os seguintes débitos técnicos precisam ser resolvidos (em ordem de prioridade):

### 1. Ports não são injetáveis (maior bloqueio)
Os ports (ex.: `MapPort`, `MapGatewayPort`, `BattleViewPort`) são módulos singleton com funções default que são **sobrescritas** pelas impls (ex.: `port.isCellWalkable = function...`). Não há injeção de dependência — não é possível trocar a implementação de um port por um mock sem mutar o singleton global, o que vaza estado entre testes.

**Ação:** injetar os ports (passar a impl como parâmetro ou usar um container/factory) em vez de sobrescrever singletons.

### 2. Dependências por path absoluto
Módulos usam `require(game.ServerStorage.Server.services.combatService...)` com paths absolutos, acoplando cada módulo à árvore do Roblox e impedindo carregamento isolado em teste.

**Ação:** reduzir o acoplamento a paths absolutos para permitir carregar módulos isoladamente.

### 3. `BattleContext` como "god object"
O `context` é passado por toda parte e contém todos os BCs (`UnitsBC`, `ConstsBC`, `IdentityBC`, etc.). Montar um `context` de teste exige inicializar e popular vários BCs.

**Ação:** criar factories de `context` de teste que montam BCs mínimos.

### 4. Dependência de runtime do Roblox
Módulos usam `game`, `workspace`, `Players`, `RunService`, `Instance.new`, `Vector3`, `CFrame`, `Enum`, `mouse` e um `Part` no workspace (`buildModeConsts.battleFieldPart`). Testes em Luau puro não têm esses objetos; testes dentro do Roblox (ex.: TestEZ) exigem ambiente.

**Ação:** priorizar testes do domínio puro (PathService, UnitPlacementService, validações) com ports mockados, sem runtime do Roblox.

### 5. Estado global mutável
Caches e estados são singletons com estado global: `UnitStateCache`, `UnitViewRegistry`, `InteractionState`, `GameState`. Sem reset entre casos, um teste contamina o outro.

**Ação:** adicionar função de reset ou recarregar módulos entre testes.

### 6. Timing / Heartbeat
`UnitCellMonitor` e `UnitMovementRender` dependem de `RunService.Heartbeat` e do `GameState.currentTime`. Testar o recálculo do preview exige controle determinístico do tempo.

**Ação:** controlar o tempo via `GameState` em vez de `os.clock`/Heartbeat real.

### 7. Fluxo orientado a eventos + fila FIFO
O sistema processa eventos via `EventQueue`. Testar um fluxo completo (ex.: `PATHFIND_UNIT` → `UnitPathfindingQuery` → `UnitPathfindingQuerySuccess` → resposta) exige simular a fila, o processamento e a tradução dos pipelines.

### 8. Rede / Remotes
O frontend usa `CommandSender`/`EventPacketsReceiver` com Remotes. Testar o fluxo ponta-a-ponta exige mockar os Remotes.

### 9. Ausência de testes existentes
Não há suíte de regressão no projeto (o `CombatApplicationInitiator` é um iniciador, não testes). Não há padrão estabelecido a seguir.

### 10. Determinismo
O A* e o sistema de eventos precisam ser determinísticos para regressão confiável. Dependência de tempo real ou ordem de chegada de Remotes quebra a reprodutibilidade.

---

**Recomendação inicial:** começar pelos testes do **domínio puro** (PathService e validação de spawn) com ports mockados, que é o ponto de maior valor e menor fricção.