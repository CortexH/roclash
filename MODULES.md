# Arquitetura de Módulos — Roclash Combat

Este documento explica a diferença e as responsabilidades de cada módulo do sistema de combate.

---

## Visão Geral

O sistema é dividido em módulos, cada um com uma responsabilidade clara e um `BattleContext` que "possui".

```text
                    ┌─────────────────────┐
                    │   interactionModule  │  porta de entrada (commands → intents)
                    └──────────┬──────────┘
                               │ intents
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│   npcModule    │      │  entityModule  │      │   mapModule    │
│  decisão/valida│      │  entidade/unit │      │  dados espaciais│
└───────────────┘      └───────────────┘      └───────────────┘
```

---

## npcModule

**Responsabilidade:** organiza o **cérebro** e a **tomada de decisão** das units.

- Aqui são **validados** (em tese) **todos os intents**.
- Recebe um intent e o valida de acordo com o domínio.
- **Exceção:** o `SpawnIntent` (spawn de unit) **não** é validado aqui — ele não representa bem um intent, então é validado no `entityModule`.

**BattleContext que organiza:** `NpcsBC`

**Exemplos de intents validados aqui:**
- `MoveIntent` → `MoveIntentAccepted` / `MoveIntentRejected`
- `AggroIntent` → `AggroIntentAccepted` / `AggroIntentRejected`
- `AttackIntent` → `AttackIntentAccepted` / `AttackIntentRejected`

---

## entityModule

**Responsabilidade:** relacionado à **entidade** (a unit em si).

- Tem "permissão" para mexer nos `BattleContext` relacionados à unit, principalmente o `UnitsBC`.
- Valida e utiliza eventos como: **tomar dano**, **realizar movimentação**, etc.
- Contém **todos os dados da própria unit**.

**BattleContext que organiza:** `UnitsBC`

**Exemplos de eventos de domínio tratados aqui:**
- `DamageAppliedEvent` (aplicar dano)
- `UnitMovementStartedEvent` / `UnitMovementResolvedEvent` (movimentação)
- `UnitSpawnedEvent` / `UnitDiedEvent` (ciclo de vida)
- `AttackStartedEvent` / `AttackResolvedEvent` / `AttackImpactEvent` (combate)
- `SpawnIntent` → `SpawnIntentAccepted` / `SpawnIntentRejected` (exceção de validação de intent)

---

## mapModule

**Responsabilidade:** relacionado **apenas ao mapa**.

- Qualquer dado **espacial** é obtido aqui.
- Exemplos: tamanho de células, conversão de célula ↔ studs, posições, etc.

**BattleContext que organiza:** `MapStateBC` / `ConstsBC` (dados do mapa)

---

## interactionModule

**Responsabilidade:** interação entre o **jogador** e o **servidor**.

- Aqui são **consumidos os commands** e **transformados em intents**.
- Também é a porta de entrada das **queries** (ex.: `UnitSelectQuery`).
- Os listeners de command **não validam** — apenas traduzem command → intent.
- O `CommandResponseSystem` gera o `commandResponse` a partir do `intentResponse` quando a origem é o jogador.

**BattleContext que organiza:** `PlayerSessionBC`

**Exemplos:**
- `UnitMoveCommand` → `MoveIntent`
- `UnitPlacementCommand` → `SpawnIntent`
- `UnitAggroCommand` → `AggroIntent`
- `UnitSelectQuery` → `UnitSelectQuerySuccess` / `UnitSelectQueryFailure`
- `UnitPathfindingQuery` → `UnitPathfindingQuerySuccess` / `UnitPathfindingQueryFailure` (sistema `UnitPathfindingSystem`, consulta o `PathService` do npcModule para o preview de caminho)

---

## gameModule

**Responsabilidade:** módulo **genérico** para coisas genéricas.

- Exemplo: início de jogo (`BeginGameEvent`), dados iniciais enviados ao cliente.

---

## Resumo

| Módulo | Responsabilidade | BattleContext | Valida intents? |
|--------|------------------|---------------|-----------------|
| `npcModule` | cérebro / tomada de decisão | `NpcsBC` | Sim (exceto `SpawnIntent`) |
| `entityModule` | entidade / unit | `UnitsBC` | Sim (`SpawnIntent`) |
| `mapModule` | dados espaciais do mapa | `MapStateBC` / `ConstsBC` | Não |
| `interactionModule` | interação jogador ↔ servidor | `PlayerSessionBC` | Não (só traduz command → intent) |
| `gameModule` | coisas genéricas | — | Não |

---

# Como os Eventos São Consumidos (Appliers e Systems)

Cada módulo possui dois consumidores de eventos:

- **`EventListenerApplier`** — executa os **Appliers** (mutam o `BattleContext`).
- **`EventsListenerSystem`** — executa os **Systems** (geram novos eventos).

Ambos usam o mesmo padrão de registro: um mapa `applies` com `["EventType"] = handler`.

```lua
-- Exemplo de um System (_MovementSystem)
module.applies = {
	["UnitAggroStartedEvent"] = require(script.Parent.ListenAggroStartedEvent).handle,
	["MoveIntent"] = require(script.Parent.ListenMovementIntent).handle,
	["MoveIntentAccepted"] = require(script.Parent.ListenMovementIntentAccepted).handle
}
```

## Ordem de Execução (por evento)

Quando um evento é processado, a ordem é: **Appliers primeiro, Systems depois**.

```text
evento
    │
    ▼
┌─────────────────────────────────────────────┐
│ 1. Appliers (em TODOS os módulos)           │  mutam o BattleContext
│    entityModule.applyEvent(event)           │  (aplicar dano, mover, spawnar...)
│    npcModule.applyEvent(event)              │
│    interactionModule.applyEvent(event)      │
├─────────────────────────────────────────────┤
│ 2. Systems (em TODOS os módulos)            │  geram NOVOS eventos
│    entityModule.handleEvent(event)          │  (validar intent, reagir, gerar...)
│    npcModule.handleEvent(event)             │
│    interactionModule.handleEvent(event)     │
├─────────────────────────────────────────────┤
│ 3. Enfileirar os novos eventos              │
└─────────────────────────────────────────────┘
```

## Detalhamento

1. **Appliers** — mutam o estado do `BattleContext` que o módulo possui.
   - Ex.: `ApplyDamageAppliedEvent` reduz o HP da unit no `UnitsBC`.
   - **Não geram novos eventos.**

2. **Systems** — observam o evento (já com o estado mutado pelos appliers), validam e **geram novos eventos**.
   - Ex.: `ListenDamageApplied` gera `UnitDiedEvent` se o HP zerou.
   - **Não mutam o estado diretamente** (mutações ficam nos appliers).

3. **Novos eventos gerados** são enfileirados na Event Queue e processados no próximo loop.

## Fluxo real (QueueApplication)

```lua
for _, module in serviceModules do
	module.applyEvent(event, context)   -- 1. Appliers (todos os módulos)
end

for _, module in serviceModules do
	local newEvents = module.handleEvent(event, context)  -- 2. Systems (todos os módulos)
	-- coleta os novos eventos
end

-- 3. Enfileira os novos eventos
```

## Por que essa ordem?

- **Appliers primeiro** — o estado precisa refletir o fato antes dos systems reagirem a ele.
  - Ex.: `DamageAppliedEvent` precisa reduzir o HP (applier) antes que o `UnitDiedEvent` seja gerado (system).
- **Systems depois** — geram novos eventos a partir do estado **já atualizado**.

## Exemplo: DamageAppliedEvent

```text
DamageAppliedEvent
    ↓ (applier: entityModule ApplyDamageAppliedEvent)
HP da unit é reduzido no UnitsBC
    ↓ (system: entityModule ListenDamageApplied)
se HP <= 0, gera UnitDiedEvent
    ↓ (enfileirado e processado)
UnitDiedEvent → (applier marca morta) → (system gera UnitAggroStoppedEvent, TargetLostEvent...)
```

---

# Componentes visuais do cliente

## ProgressBar

**Local:** `src/client/assets/components/bars/ProgressBar.luau`

Componente visual genérico para representar uma proporção entre `0` e `1`. É responsável somente pela estrutura da barra e pela atualização segura do preenchimento; não conhece HP nem regras de gameplay.

## CompactActionButton

**Local:** `src/client/assets/components/buttons/CompactActionButton.luau`

Botão compacto com ícone, texto, cor de destaque e estado selecionado persistente. É usado em ações contextuais que precisam permanecer legíveis em painéis pequenos, como `MOVER` e `ATACAR` na Unit Card.
