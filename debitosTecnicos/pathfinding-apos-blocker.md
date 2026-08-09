# Débito Técnico — Unit quebra o blocker mas não continua o caminho

## Contexto

Quando a unit é pedida para se mover para frente de um blocker (ex.: uma parede/estrutura que bloqueia o caminho), a ideia era ela **quebrar o blocker e continuar** o caminho até o destino. Hoje ela apenas quebra o blocker e **para ali** (não continua o path planejado).

## Evidência (log)

```text
UnitMoveCommand → MoveIntent → MoveIntentAccepted → UnitMovementPlanningEvent
→ UnitMovementStartedEvent
→ (a unit ataca o blocker)
→ AttackImpactEvent → DamageAppliedEvent → UnitDiedEvent → TargetLostEvent
```

A unit ataca o blocker, o blocker morre, mas a unit não continua o movimento até o destino original.

## Ideia (proposta)

Após a unit destruir o blocker, o sistema deveria **recalcular o path** (ou continuar o path planejado) para a unit seguir até o destino original.

## Pontos de atenção

- Requer mudança no fluxo de movimento (npcModule/entityModule) para, ao destruir um blocker, re-planejar o movimento até o destino original.
- Relacionado ao débito de "recalcular path preview quando uma unit que bloqueia a visão é destruída" — o preview já simula a continuação; o movimento real precisa acompanhar.

## Status

- [ ] Ao destruir um blocker, a unit continua o caminho até o destino original.