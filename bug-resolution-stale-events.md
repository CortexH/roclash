# Bug Resolution — Eventos Stale após mudança de Aggro/Target

## Status

- **Status:** Em investigação
- **Prioridade:** Alta
- **Sistema:** Combat / NPC / Intent / Event Queue
- **Tipo:** Bug de consistência da simulação
- **Sintoma principal:** eventos pertencentes a um estado anterior da unidade continuam sendo processados depois de uma mudança de estado estrutural.

---

## 1. Contexto

A simulação do combate é uma **Discrete Event Simulation (DES)** determinística.

O fluxo geral é:

```text
Commands → Events → Systems → Appliers
```

A simulação não utiliza tick contínuo. O estado só muda quando eventos são processados.

Eventos futuros são colocados na fila e podem representar, por exemplo:

```text
UnitMovementStartedEvent
UnitMovementResolvedEvent
VerifyAggroReachedEvent
AttackIntent
AttackStartedEvent
AttackImpactEvent
CooldownReadyEvent
```

O sistema possui **versionamento por entidade** para permitir cancelamento implícito de eventos:

```text
se event.version ~= entity.version:
    ignorar evento
```

A intenção desse mecanismo é impedir que eventos antigos continuem afetando uma entidade depois que uma mudança estrutural invalida aquela cadeia de eventos.

---

## 2. Sintoma observado

O log apresenta situações em que duas unidades aparentemente legítimas entram simultaneamente no pipeline de ataque:

```text
CooldownReadyEvent
CooldownReadyEvent

AttackIntent
AttackIntent

AttackIntentAccepted
AttackIntentAccepted

AttackStartedEvent
AttackStartedEvent

AttackImpactEvent
AttackImpactEvent

DamageAppliedEvent
DamageAppliedEvent
```

Isso, isoladamente, **não é necessariamente um bug**, pois pode representar duas unidades atacando o mesmo alvo.

O problema suspeito aparece quando o alvo morre ou quando o aggro da unidade muda.

---

## 3. Sequência suspeita

Trecho relevante do log:

```text
UnitMovementResolvedEvent
UnitStructureBlockingPathEvent
VerifyAggroReachedEvent
TargetAcquiredEvent
UnitStructureBlockingPathEvent

Target View
AttackIntent
TargetAcquiredEvent
AttackIntent
AttackIntentAccepted
AttackStartedEvent
AttackIntentAccepted
AttackStartedEvent

AttackImpactEvent
AttackImpactEvent
DamageAppliedEvent
DamageAppliedEvent

UnitDiedEvent
UnitAggroStoppedEvent
TargetLostEvent

UnitAggroSearchEvent
UnitAggroIntentEvent
AggroIntentAccepted
UnitAggroStartedEvent

MovementIntent
MovementIntentRejected

VerifyAggroReachedEvent
TargetAcquiredEvent
```

A sequência final é o ponto mais suspeito:

```text
MovementIntent
MovementIntentRejected
VerifyAggroReachedEvent
TargetAcquiredEvent
```

Existe um `MovementIntentRejected`, mas um `VerifyAggroReachedEvent` continua sendo processado imediatamente depois e gera `TargetAcquiredEvent`.

Isso pode indicar que o `VerifyAggroReachedEvent` pertence a uma cadeia de eventos anterior e não foi invalidado corretamente.

---

## 4. Hipótese principal

### Evento stale

Um evento futuro foi criado para um estado anterior da entidade.

Exemplo conceitual:

```text
Unit A
    ↓
Aggro → Target X
    ↓
Movement
    ↓
VerifyAggroReachedEvent
```

Enquanto esse evento está na fila:

```text
Target X morre
    ↓
TargetLostEvent
    ↓
AggroSearch
    ↓
novo AggroTarget
```

A mudança de estado deveria invalidar a cadeia anterior.

Porém, se o evento antigo continuar válido:

```text
VerifyAggroReachedEvent antigo
    ↓
TargetAcquiredEvent
    ↓
AttackIntent
```

o sistema pode voltar a executar uma consequência pertencente ao estado anterior.

---

## 5. Ponto crítico a investigar

Investigar principalmente a relação entre:

```text
MovementIntent
MovementIntentAccepted
MovementIntentRejected
UnitMovementPlanningEvent
UnitMovementStartedEvent
UnitMovementResolvedEvent
VerifyAggroReachedEvent
TargetAcquiredEvent
```

Especialmente quando ocorre:

```text
TargetLostEvent
```

ou:

```text
UnitAggroStoppedEvent
```

e uma nova cadeia de aggro/movimento é iniciada.

---

## 6. Instrumentação obrigatória para investigação

Adicionar temporariamente ao log dos eventos relevantes:

```lua
event.type
event.unitId
event.targetId
event.version
entity.version
```

Idealmente:

```text
EVENT CONSUMED
type = VerifyAggroReachedEvent
unitId = ABC
targetId = XYZ
eventVersion = 4
entityVersion = 5
```

Isso permitirá verificar diretamente se um evento antigo está chegando à fila com uma versão diferente da entidade.

Instrumentar no mínimo:

```text
UnitAggroStartedEvent
UnitAggroStoppedEvent
TargetLostEvent

MovementIntent
MovementIntentAccepted
MovementIntentRejected

UnitMovementPlanningEvent
UnitMovementStartedEvent
UnitMovementResolvedEvent

VerifyAggroReachedEvent
TargetAcquiredEvent

AttackIntent
AttackIntentAccepted
AttackStartedEvent
```

---

## 7. Perguntas que a investigação deve responder

### 7.1 Versionamento

Quando ocorre:

```text
TargetLostEvent
```

a `version` da unidade é incrementada?

Se não, verificar se deveria ser.

---

### 7.2 Aggro change

Quando:

```text
UnitAggroStoppedEvent
```

é processado, eventos futuros relacionados ao aggro/movimento anterior tornam-se inválidos?

---

### 7.3 Movement rejection

Quando:

```text
MovementIntentRejected
```

acontece, existe algum:

```text
VerifyAggroReachedEvent
```

já presente na fila?

Se sim, esse evento ainda está sendo considerado válido?

---

### 7.4 VerifyAggroReached

O `VerifyAggroReachedEvent` valida novamente se:

- a unidade ainda possui aquele aggro;
- o target ainda é o target atual;
- a versão do evento ainda corresponde à versão atual da entidade;
- a movimentação relacionada ainda é válida.

Não assumir que o evento é válido apenas porque chegou ao momento de execução.

---

### 7.5 TargetAcquiredEvent

Verificar se `TargetAcquiredEvent` pode ser emitido por um `VerifyAggroReachedEvent` que pertence a uma cadeia de movimento antiga.

---

## 8. Critério de sucesso

A resolução deve garantir que:

1. Eventos antigos não produzam efeitos depois de uma mudança estrutural.
2. `MovementIntentRejected` não seja seguido por efeitos da movimentação rejeitada.
3. Um `VerifyAggroReachedEvent` antigo não possa gerar `TargetAcquiredEvent`.
4. Mudanças de target/aggro invalidem corretamente eventos futuros relacionados ao estado anterior.
5. Ataques legítimos de múltiplas unidades continuem funcionando normalmente.
6. O sistema continue determinístico.
7. Não seja necessário remover manualmente eventos antigos da priority queue.

---

## 9. Restrições

Não alterar a arquitetura geral da simulação apenas para esconder o sintoma.

Preservar:

```text
Discrete Event Simulation
Event Queue
Versionamento
Commands → Events → Systems → Appliers
```

Não adicionar tick global.

Não resolver o problema com delays arbitrários.

Não simplesmente ignorar `AttackIntent` duplicado sem antes determinar se os intents pertencem a unidades diferentes.

Não remover eventos manualmente da fila como mecanismo primário de cancelamento.

---

## 10. Investigação sugerida

### Passo 1 — rastrear uma única unidade

Escolher uma unidade que:

```text
Aggro → Movement → Target
```

e posteriormente perde o target.

Registrar:

```text
unitId
targetId
version
event.version
```

em todos os eventos acima.

### Passo 2 — identificar a cadeia de eventos

Reconstruir:

```text
AggroStarted
    ↓
MovementIntent
    ↓
MovementStarted
    ↓
VerifyAggroReached
```

e descobrir qual evento provocou a mudança estrutural.

### Passo 3 — comparar versões

Verificar se:

```text
event.version ~= entity.version
```

no momento em que o evento stale é consumido.

### Passo 4 — localizar a invalidação

Se o evento stale possui versão antiga:

```text
event.version = N
entity.version = N + 1
```

descobrir por que o handler não o descartou.

Se as versões forem iguais:

```text
event.version = entity.version
```

investigar se o mecanismo de versionamento está sendo incrementado no ponto estrutural correto.

### Passo 5 — validar o comportamento

Reproduzir o cenário:

```text
Unit A e Unit B atacam
        ↓
um ataque mata o target
        ↓
TargetLost
        ↓
novo AggroSearch
        ↓
novo MovementIntent
        ↓
MovementIntentRejected
        ↓
verificar se algum VerifyAggroReached antigo ainda produz TargetAcquired
```

---

## 11. Observação importante

O log **não prova sozinho** que existe um bug de duplicação de `AttackIntent`.

As ocorrências:

```text
AttackIntent
AttackIntent
```

podem representar duas unidades diferentes atacando o mesmo alvo.

O indício mais forte é a sequência:

```text
MovementIntent
MovementIntentRejected
VerifyAggroReachedEvent
TargetAcquiredEvent
```

imediatamente após:

```text
UnitDiedEvent
UnitAggroStoppedEvent
TargetLostEvent
```

Portanto, a investigação deve priorizar **eventos stale / invalidação de cadeia de movimento e aggro**, e não simplesmente deduplicação de ataques.

---

## 12. Resultado esperado da IA

A IA deve:

1. Inspecionar o código responsável pelos eventos acima.
2. Identificar a causa raiz.
3. Explicar exatamente qual cadeia de eventos está ficando inválida.
4. Determinar se o problema é:
   - versionamento ausente;
   - versionamento incrementado no ponto errado;
   - evento sem validação suficiente;
   - evento sendo criado indevidamente;
   - `MovementIntentRejected` não invalidando estado anterior;
   - ou outra causa demonstrada pelo código.
5. Implementar a menor correção arquiteturalmente correta.
6. Não mascarar o problema com condições arbitrárias.
7. Adicionar logs/testes necessários para provar a correção.
8. Relatar quais arquivos foram alterados e por quê.

**Não assumir a hipótese como fato antes de confirmar no código.**
