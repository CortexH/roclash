# Explicação dos Eventos — Roclash Combat

Este documento explica os eventos do sistema de combate, organizados por **fluxos** e por **listagem completa**.

- **Fluxos** — a sequência de eventos de cada situação (spawn, aggro, movimento, ataque, morte, targeting).
- **Listagem completa** — todos os eventos, o que significam e o que fazem, organizados por módulo.

---

## Visão Geral do Fluxo

```text
                    SERVIDOR
                        │
              Battle Simulation
                        │
            eventos processados no tick
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
   RENDER          INTERACTION      UI STATE
   PIPELINE         PIPELINE        PIPELINE
        │               │               │
        ▼               ▼               ▼
  Render Event      Response         UI Diff
        │               │               │
        └───────────────┴───────────────┘
                        │
                        ▼
                     CLIENTE
```

Cada pipeline responde a uma pergunta diferente:

| Pipeline | Pergunta |
|----------|----------|
| Render | O que mudou no mundo? |
| Interaction | O que o jogador pediu e qual é a resposta? |
| UI State | O que mudou no estado que o jogador está observando? |

---

# 1. Fluxos

## 1.1 Fluxo de Spawn

```text
UnitPlacementCommand
    ↓ (interactionModule: CommandSystem)
SpawnIntent
    ↓ (entityModule: SpawnIntentSystem valida)
SpawnIntentAccepted
    ↓ (entityModule: ListenSpawnIntentAccepted)
UnitSpawnedEvent
    ↓ (interactionModule: CommandResponseSystem, se origin PLAYER)
UnitPlacementCommandResponse
```

**Cliente:** `UnitSpawn` (render) + `UnitPlacementCommandResponse`

Se a unit for do tipo `aggressive`, logo após o spawn ela inicia a busca de aggro:

```text
UnitSpawnedEvent → UnitAggroSearchEvent → AggroIntent
```

## 1.2 Fluxo de Aggro

```text
UnitAggroCommand
    ↓ (interactionModule: CommandSystem)
AggroIntent
    ↓ (npcModule: AggroSystem valida)
AggroIntentAccepted
    ↓ (entityModule: UnitIntentSystem)
UnitAggroStartedEvent
    ↓ (interactionModule: CommandResponseSystem, se origin PLAYER)
UnitAggroCommandResponse
```

Após aggroar, a unit se move até o alvo (ver Fluxo de Movimento).

## 1.3 Fluxo de Movimento

```text
MoveIntent
    ↓ (npcModule: MovementSystem valida)
MoveIntentAccepted
    ↓ (npcModule: ListenMovementIntentAccepted)
UnitMovementPlanningEvent
    ↓ (entityModule: MovementSystem)
UnitMovementStartedEvent
    ↓
UnitMovementResolvedEvent
    ↓
VerifyAggroReachedEvent
    ↓
TargetAcquiredEvent
```

**Cliente:** `UnitMove` (render)

## 1.4 Fluxo de Ataque

```text
TargetAcquiredEvent
    ↓ (npcModule: CombatSystem)
AttackIntent
    ↓ (npcModule: ListenAttackIntentEvent valida)
AttackIntentAccepted
    ↓ (entityModule: UnitIntentSystem)
AttackStartedEvent
    ↓ (entityModule: CombatSystem)
AttackImpactEvent
    ↓ (entityModule: DamageResolutionSystem)
DamageAppliedEvent
    ↓
AttackResolvedEvent
```

**Cliente:** `DamageApplied` (render) + `DamageIndicatorCreated`

## 1.5 Fluxo de Morte

```text
UnitDiedEvent
    ↓
UnitAggroStoppedEvent
    ↓
TargetLostEvent
    ↓
UnitAggroSearchEvent
    ↓
AggroIntent
```

## 1.6 Fluxo de Targeting (tower range)

```text
UnitEnteredTowerRangeEvent
    ↓
TargetAcquiredEvent
    ↓
AttackIntent → AttackIntentAccepted → AttackStartedEvent
```

Quando a unit **sai** do range da torre, a torre perde o alvo:

```text
UnitLeftTowerRangeEvent → TargetLostEvent
```

O `UnitReachedAggroEvent` também gera um `TargetAcquiredEvent` (a unit alcançou o alvo de aggro e pode atacar).

## 1.7 Subfluxos

### Cooldown ready

```text
CooldownReadyEvent → AttackIntent → AttackIntentAccepted → AttackStartedEvent
```

### Attack resolved → cooldown (loop de ataque)

O `AttackResolvedEvent` agenda o `CooldownReadyEvent` com delay (tempo de cooldown do ataque), fechando o loop de ataque:

```text
AttackResolvedEvent → (delay) CooldownReadyEvent → AttackIntent → ...
```

### Verificação de aggro

```text
UnitMovementResolvedEvent → VerifyAggroReachedEvent → TargetAcquiredEvent
```

## 1.8 Fluxo de Ataque com Projétil

Ataques com projétil (ex.: torre) passam por `ProjectileLaunchedEvent` antes do impacto:

```text
UnitEnteredTowerRangeEvent
    ↓
TargetAcquiredEvent
    ↓
AttackIntent → AttackIntentAccepted → AttackStartedEvent
    ↓
ProjectileLaunchedEvent
    ↓
AttackImpactEvent → DamageAppliedEvent → AttackResolvedEvent
```

## 1.9 Fluxo de Bloqueio de Caminho

Quando uma estrutura bloqueia o caminho da unit até o alvo, a unit troca o alvo para a estrutura bloqueadora:

```text
UnitMovementResolvedEvent
    ↓
UnitStructureBlockingPathEvent
    ↓
VerifyAggroReachedEvent
    ↓
TargetAcquiredEvent
    ↓
AttackIntent → AttackIntentAccepted → AttackStartedEvent
```

## 1.10 Fluxo de Seleção (UnitSelect)

```text
SelectUnitButtonClickedClient (cliente)
    ↓
UnitSelectQuery
    ↓
UnitSelectQuerySuccess
    ↓
UnitSelectQuerySuccessResponse (cliente)
```

## 1.11 Fluxo de UI State (UI Diff)

O `UIStateUpdateResponse` é gerado quando o estado observado muda. Por enquanto, o dano é o principal trigger:

```text
AttackImpactEvent → DamageAppliedEvent
    ↓
UIStateUpdateResponse (cliente)
```

**Cliente:** `DamageApplied` (render) + `DamageIndicatorCreated` + `UIStateUpdateResponse`

> Qualquer mudança no estado observado pode gerar o UI Diff, mas atualmente só o dano o dispara.

---

# 2. Fluxo de Commands (command → intent → intentResponse → commandResponse)

O `interactionModule` é a **porta de entrada** de commands e queries. Todo command segue o fluxo:

```text
command → intent → intentResponse → commandResponse
```

- **Command** — pedido externo do jogador (não valida nada).
- **Intent** — decisão a ser validada pelo domínio.
- **IntentResponse** — resultado da validação (`Accepted`/`Rejected`).
- **CommandResponse** — resposta ao jogador, gerada **apenas se** o intent tiver `origin.type == "PLAYER"`.

## 2.1 Commands (interactionModule)

| Command | Gera o intent |
|---------|---------------|
| `UnitMoveCommand` | `MoveIntent` |
| `UnitPlacementCommand` | `SpawnIntent` |
| `UnitAggroCommand` | `AggroIntent` |

Os listeners de command ficam no `interactionModule` (`CommandSystem`) e **apenas traduzem** command → intent, sem validação.

## 2.2 Intents

| Intent | Validado por | IntentResponse |
|--------|--------------|----------------|
| `MoveIntent` | npcModule (`MovementSystem`) | `MoveIntentAccepted` / `MoveIntentRejected` |
| `SpawnIntent` | entityModule (`SpawnIntentSystem`) | `SpawnIntentAccepted` / `SpawnIntentRejected` |
| `AggroIntent` | npcModule (`AggroSystem`) | `AggroIntentAccepted` / `AggroIntentRejected` |
| `AttackIntent` | npcModule (`CombatSystem`) | `AttackIntentAccepted` / `AttackIntentRejected` |

## 2.3 CommandResponses (interactionModule)

O `CommandResponseSystem` (interactionModule) escuta os intentResponses e, se `origin.type == "PLAYER"`, gera o commandResponse:

| IntentResponse | CommandResponse |
|----------------|-----------------|
| `MoveIntentAccepted` / `MoveIntentRejected` | `UnitMoveCommandResponse` |
| `SpawnIntentAccepted` / `SpawnIntentRejected` | `UnitPlacementCommandResponse` |
| `AggroIntentAccepted` / `AggroIntentRejected` | `UnitAggroCommandResponse` |

O `commandResponseType` usa `"SUCCESS"` ou `"REJECT"`.

---

# 3. Listagem Completa de Eventos

Listagem de todos os eventos do sistema, organizados por módulo/categoria, com o que significam e o que fazem.

## 3.1 Commands (interactionModule)

| Evento | O que faz | Gera |
|--------|-----------|------|
| `UnitMoveCommand` | pedido do jogador para mover uma unit | `MoveIntent` |
| `UnitPlacementCommand` | pedido do jogador para posicionar/spawnar uma unit | `SpawnIntent` |
| `UnitAggroCommand` | pedido do jogador para uma unit aggroar um alvo | `AggroIntent` |

## 3.2 Queries (interactionModule)

| Evento | O que faz | Gera |
|--------|-----------|------|
| `UnitSelectQuery` | query de seleção de uma unit | `UnitSelectQuerySuccess` / `UnitSelectQueryFailure` |

> **Semântica das Queries:** o `eventType` identifica a operação solicitada. O campo `signature` identifica o consumidor/contexto que fez a requisição (ex: `"UNIT_CARD"`), é enviado pelo frontend e ecoado pelo servidor na resposta, permitindo que múltiplos listeners da mesma operação se diferenciem sem criar eventos por consumidor. O `requesterId` identifica o responsável pela requisição (obtido do `player.UserId` no servidor).

## 3.3 Intents (npcModule valida, exceto SpawnIntent no entityModule)

| Intent | O que faz | Validado por | IntentResponse |
|--------|-----------|--------------|----------------|
| `MoveIntent` | intenção de mover uma unit | npcModule | `MoveIntentAccepted` / `MoveIntentRejected` |
| `SpawnIntent` | intenção de spawnar uma unit | entityModule | `SpawnIntentAccepted` / `SpawnIntentRejected` |
| `AggroIntent` | intenção de aggroar um alvo | npcModule | `AggroIntentAccepted` / `AggroIntentRejected` |
| `AttackIntent` | intenção de atacar um alvo | npcModule | `AttackIntentAccepted` / `AttackIntentRejected` |

## 3.4 CommandResponses (interactionModule)

| Evento | O que faz |
|--------|-----------|
| `UnitMoveCommandResponse` | resposta ao jogador do comando de mover (`SUCCESS`/`REJECT`) |
| `UnitPlacementCommandResponse` | resposta ao jogador do comando de posicionar (`SUCCESS`/`REJECT`) |
| `UnitAggroCommandResponse` | resposta ao jogador do comando de aggro (`SUCCESS`/`REJECT`) |

## 3.5 Eventos de domínio (entityModule)

| Evento | O que faz |
|--------|-----------|
| `UnitSpawnedEvent` | uma unit nasceu/foi criada |
| `UnitDiedEvent` | uma unit morreu |
| `DamageAppliedEvent` | uma unit sofreu dano |
| `AttackStartedEvent` | um ataque começou |
| `AttackResolvedEvent` | um ataque foi resolvido |
| `AttackImpactEvent` | o impacto de um ataque ocorreu |
| `ProjectileLaunchedEvent` | um projétil foi lançado |
| `CooldownReadyEvent` | o cooldown de ataque de uma unit terminou |
| `UnitMovementStartedEvent` | uma unit começou a se mover |
| `UnitMovementResolvedEvent` | uma unit concluiu o movimento |
| `UnitMovementStoppedEvent` | uma unit parou de se mover |
| `UnitMovementSegmentEvent` | um segmento de movimento foi processado |
| `UnitMovementInterruptedEvent` | o movimento de uma unit foi interrompido |
| `UnitMovementPlanningEvent` | o planejamento de caminho de uma unit |
| `UnitEnteredTowerRangeEvent` | uma unit entrou no range de uma torre |
| `UnitLeftTowerRangeEvent` | uma unit saiu do range de uma torre |
| `UnitAggroStartedEvent` | uma unit começou a aggroar um alvo |
| `BeginGameEvent` | início do jogo |

## 3.6 Eventos de domínio (npcModule)

| Evento | O que faz |
|--------|-----------|
| `UnitAggroStoppedEvent` | uma unit parou de aggroar um alvo |
| `UnitAggroSearchEvent` | uma unit iniciou busca de aggro |
| `UnitReachedAggroEvent` | uma unit alcançou o alvo de aggro |
| `VerifyAggroReachedEvent` | verificação se a unit alcançou o aggro |
| `TargetAcquiredEvent` | uma unit adquiriu um alvo |
| `TargetLostEvent` | uma unit perdeu um alvo |
| `UnitIdleEvent` | uma unit ficou ociosa |
| `UnitStructureBlockingPathEvent` | uma estrutura bloqueia o caminho de uma unit |

## 3.7 Render Events (servidor → cliente)

| Evento | O que faz |
|--------|-----------|
| `UnitSpawn` | render de spawn de unit |
| `UnitDied` | render de morte de unit |
| `UnitMove` | render de movimento de unit |
| `AttackStarted` | render de início de ataque |
| `ProjectileLaunch` | render de lançamento de projétil |
| `AttackImpact` | render de impacto de ataque |
| `DamageApplied` | render de dano aplicado |
| `ImpactVFX` | render de efeito visual de impacto |
| `GameBeginEvent` | render de início de jogo |

## 3.8 Interaction Responses (servidor → cliente)

| Evento | O que faz |
|--------|-----------|
| `UnitSelectQuerySuccessResponse` | resposta de sucesso da query de seleção |
| `UnitSelectQueryFailureResponse` | resposta de falha da query de seleção |

> A resposta ecoa a `signature` do consumidor que originou a Query, permitindo que múltiplos listeners da mesma operação se diferenciem. Cada listener possui uma `signature` fixa e ignora respostas cuja `signature` não seja a sua.

## 3.9 UI State (servidor → cliente)

| Evento | O que faz |
|--------|-----------|
| `UIStateUpdateResponse` | atualização incremental do estado observado (UI Diff) |

## 3.10 Eventos internos do cliente

| Evento | O que faz |
|--------|-----------|
| `DamageIndicatorCreated` | cria indicador de dano na UI |
| `UnitRemoved` | remove a unit do mundo (após morte) |
| `SelectUnitButtonClickedClient` | botão de seleção de unit clicado |
| `CardAttackButtonClickedClient` | botão de atacar do card clicado |
| `CardMoveButtonClickedClient` | botão de mover do card clicado |
| `BeginUnitSelectionClientEvent` | início do modo de seleção de unit |
| `StopUnitSelectionClientEvent` | fim do modo de seleção de unit |
| `BeginUnitAttackSelectionClientEvent` | início do modo de seleção de ataque |
| `StopUnitAttackSelectionClientEvent` | fim do modo de seleção de ataque |
