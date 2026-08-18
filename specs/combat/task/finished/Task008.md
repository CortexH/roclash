# Feature — Aggro por Dano Recebido

## Objetivo

Adicionar uma nova origem de aggro ao sistema:

> Quando uma unit recebe dano através de um `DamageApplied`, o sistema pode gerar uma tentativa de aggro contra a entidade que causou o dano.

Essa tentativa **não garante que o aggro será aceito**.

O evento de dano apenas dispara um `AggroIntent`.

Toda a decisão sobre aceitar ou rejeitar esse intent deve continuar centralizada no `NpcModule`, utilizando o estado atual da unit no momento em que o intent for processado.

---

# Regra principal

Fluxo esperado:

```text
DamageApplied
    ↓
gera AggroIntent
    ↓
AggroIntentListener
    ↓
NpcModule valida o estado atual
    ↓
AggroIntentAccepted
ou
AggroIntentRejected
```

O listener de `DamageApplied` **não deve decidir se o aggro é válido**.

Ele apenas identifica que ocorreu uma situação capaz de gerar uma tentativa de aggro.

---

# Escopo

Esta alteração deve implementar apenas:

1. geração de `AggroIntent` após uma unit receber dano;
2. identificação da origem do `AggroIntent`;
3. validação dessa tentativa pelo fluxo normal do `NpcModule`;
4. suporte às regras específicas de reação a dano descritas neste documento.

Não implementar:

- threat system;
- scoring de targets;
- troca automática de alvo;
- memória de agressores;
- fila de intents;
- prioridade entre intents;
- IA avançada;
- retaliation especial que ignore regras normais de targeting;
- comportamento novo para `PEACEFUL`.

---

# Novo contexto do AggroIntent

O `AggroIntent` deve possuir informação indicando **a origem da tentativa de aggro**.

Nome recomendado:

```lua
origin
```

Exemplo:

```lua
origin = "DAMAGE_RECEIVED"
```

A origem representa:

> Qual situação do sistema provocou a criação daquele `AggroIntent`.

Ela não representa:

- o resultado da validação;
- o motivo de rejeição;
- prioridade;
- histórico;
- memória da unit.

Evitar utilizar o nome `reason` para esse campo, pois `reason` pode ser utilizado futuramente para explicar resultados como:

```text
OUT_OF_AGGRO_RANGE
ALREADY_HAS_TARGET
INVALID_TARGET
BEHAVIOR_NOT_ALLOWED
```

---

# AggroIntent Origins

Criar ou expandir a definição de origins de forma compatível com a arquitetura existente.

A nova origem obrigatória desta feature é:

```text
DAMAGE_RECEIVED
```

Não adicionar outras origins apenas por antecipação caso elas ainda não existam no sistema.

Se já existir estrutura equivalente para origem de intents, reutilizá-la.

---

# DamageApplied → AggroIntent

Quando ocorrer um `DamageApplied` sobre uma unit capaz de possuir comportamento de NPC, o fluxo deve poder emitir:

```lua
AggroIntent = {
    unitId = damagedUnitId,
    targetId = damageSourceId,
    origin = "DAMAGE_RECEIVED",
}
```

Os nomes exatos dos campos devem respeitar os tipos e convenções já existentes na codebase.

A IA deve investigar os eventos atuais antes de alterar estruturas.

---

# Responsabilidade do listener de DamageApplied

O listener responsável por reagir ao `DamageApplied` deve ser simples.

Ele não deve executar regras como:

```lua
if behavior == "AGGRESSIVE" then ...
if not hasTarget then ...
if distance <= aggroRange then ...
```

Essas regras pertencem ao `NpcModule`.

O listener deve apenas:

1. receber o `DamageApplied`;
2. identificar a unit que recebeu o dano;
3. identificar a entidade responsável pelo dano, caso exista um target aggrável;
4. emitir o `AggroIntent` com `origin = DAMAGE_RECEIVED`.

---

# Damage source inválido

Nem todo dano necessariamente precisa possuir uma entidade que possa ser alvo.

Exemplos futuros:

- dano ambiental;
- fogo;
- veneno;
- armadilha;
- efeito persistente;
- dano sem entidade fonte.

Se o `DamageApplied` não possuir uma entidade que possa sequer ser representada como candidato de target, não deve ser criado um `AggroIntent` inválido.

Essa filtragem estrutural é permitida antes do `NpcModule`.

Porém, regras de decisão de NPC devem permanecer no `NpcModule`.

---

# Validação no NpcModule

Quando um `AggroIntent` com:

```lua
origin = "DAMAGE_RECEIVED"
```

for recebido, o `NpcModule` deve avaliar **o estado atual da unit naquele momento**.

O intent não deve carregar uma fotografia antiga da decisão.

O sistema deve validar, no mínimo:

1. a unit existe;
2. a unit está em estado válido para processar aggro;
3. a unit possui comportamento compatível;
4. o comportamento é `DEFENSIVE` ou `AGGRESSIVE`;
5. a unit ainda não possui um target/aggro ativo;
6. o target do intent existe;
7. o target está vivo;
8. o target é inimigo;
9. o target é válido segundo as regras normais de targeting;
10. o target está dentro do `aggroRange`;
11. demais regras normais já existentes para aquisição de aggro continuam válidas.

Se qualquer regra falhar, o intent deve seguir o fluxo normal de rejeição já existente.

---

# Behavior

Para esta feature:

## AGGRESSIVE

Pode reagir ao dano recebido.

```text
DamageApplied
→ AggroIntent(DAMAGE_RECEIVED)
→ validação
→ pode adquirir o agressor
```

## DEFENSIVE

Também pode reagir ao dano recebido.

```text
DamageApplied
→ AggroIntent(DAMAGE_RECEIVED)
→ validação
→ pode adquirir o agressor
```

## PEACEFUL

Não deve adquirir aggro automaticamente por dano recebido.

O `NpcModule` deve rejeitar essa tentativa.

---

# Unit que já possui target

Uma unit que já possui um target/aggro ativo não deve trocar de alvo apenas por receber dano.

Exemplo:

```text
B está atacando A

C causa dano em B

DamageApplied(C → B)
↓
AggroIntent(B → C, DAMAGE_RECEIVED)
↓
B já possui target A
↓
AggroIntentRejected
```

Não implementar comparação entre targets.

Não implementar prioridade por último atacante.

Não implementar threat.

Não substituir o target atual.

---

# Estado atual é a fonte da verdade

Este é um princípio importante da feature.

O `AggroIntentListener` deve analisar cada intent individualmente.

Ele não deve saber:

- quais intents vieram antes;
- quantos intents estão esperando;
- qual foi o último atacante;
- qual intent possui maior prioridade;
- qual seria o próximo intent da fila.

Exemplo:

```text
DamageApplied(A → B)
DamageApplied(C → B)
DamageApplied(D → B)
```

Podem ser gerados:

```text
AggroIntent(B → A)
AggroIntent(B → C)
AggroIntent(B → D)
```

Quando cada intent chegar ao processamento, o sistema deve consultar novamente o estado atual de `B`.

Possível resultado:

```text
AggroIntent(B → A)
→ B não possui target
→ accepted
→ A torna-se target

AggroIntent(B → C)
→ B já possui target
→ rejected

AggroIntent(B → D)
→ B já possui target
→ rejected
```

Não criar mecanismo adicional de deduplicação ou fila de aggro para resolver esse cenário.

A ordenação normal da simulação e o estado atual da entidade devem definir o resultado.

---

# Determinismo

A feature deve preservar o determinismo da simulação.

Em situações onde múltiplos danos e intents ocorram no mesmo instante, o resultado deve depender apenas:

- da ordem determinística dos eventos;
- do estado da batalha no momento em que cada evento é processado.

Não utilizar:

- execução paralela;
- ordem não determinística;
- tabelas percorridas sem garantia necessária de ordem para decisões relevantes;
- estado externo à simulação.

---

# Aggressor morto antes do processamento

É válido que o agressor esteja vivo no momento do dano e morto quando o `AggroIntent` for processado.

Exemplo:

```text
A causa dano em B
↓
DamageApplied
↓
AggroIntent(B → A)

antes do processamento:
A morre
```

Nesse caso:

```text
NpcModule valida estado atual
↓
A está morto
↓
AggroIntentRejected
```

Não criar tratamento especial.

---

# Aggressor fora do AggroRange

Receber dano não concede aggro automático.

Se o agressor estiver fora do alcance normal de aggro:

```text
distance > aggroRange
```

o intent deve ser rejeitado.

A origem `DAMAGE_RECEIVED` não ignora essa regra.

---

# Regras espaciais e targeting

`DAMAGE_RECEIVED` não deve funcionar como bypass das regras normais de aquisição de target.

Se o sistema atual possui validações relacionadas a:

- target válido;
- facção/time;
- entidade viva;
- path;
- blocker;
- visão;
- alcance;
- outras restrições de targeting;

elas devem continuar sendo aplicadas conforme a arquitetura atual.

A IA não deve criar novas regras espaciais nesta feature.

Deve reutilizar as existentes.

---

# Estruturas como agressor

Não assumir que o agressor precisa ser outro NPC.

Se estruturas, torres ou outras entidades puderem causar `DamageApplied`, elas devem seguir as mesmas regras normais de target.

Exemplo:

```text
Tower
→ causa DamageApplied em NPC
→ AggroIntent contra Tower
```

Se `Tower` for um target válido segundo o sistema atual, o aggro pode ser aceito.

Não adicionar validação do tipo:

```lua
if attackerType ~= "NPC" then
    reject
end
```

a menos que essa seja uma regra já existente na codebase.

---

# Friendly Fire

Mesmo que friendly fire não faça parte do fluxo atual, o `NpcModule` deve continuar dependendo das regras normais de validação de target.

Receber dano não transforma automaticamente a fonte em inimigo.

Se a fonte não for um target válido, o intent deve ser rejeitado.

---

# Sem memória implícita

O `origin` não cria memória.

Após o `AggroIntent` ser processado, não deve existir automaticamente algo como:

```lua
lastAggressor
pendingAggro
aggroQueue
damageThreat
```

Isso está fora do escopo.

Se algum desses conceitos já existir na arquitetura, não alterá-los sem necessidade direta.

---

# Semântica desejada

O sistema deve tratar:

```text
DamageApplied
```

como:

> "Aconteceu algo que justifica perguntar ao cérebro se esta unit deveria adquirir este agressor como alvo."

E não como:

> "Esta unit obrigatoriamente deve atacar quem causou dano."

Da mesma forma:

```text
AggroIntent
```

representa uma solicitação de decisão.

Não representa uma decisão já tomada.

---

# Investigação obrigatória antes da implementação

Antes de alterar código, a IA deve localizar e compreender:

1. definição atual de `DamageApplied`;
2. definição atual de `AggroIntent`;
3. definição de `AggroIntentAccepted`;
4. definição de `AggroIntentRejected`, caso exista;
5. listener atual de `AggroIntent`;
6. fluxo de validação dentro do `NpcModule`;
7. estrutura atual de behaviors;
8. serviço atual responsável por targeting;
9. representação atual de aggro/target ativo;
10. como `sourceId`, `attackerId`, `targetId` ou equivalentes são representados em `DamageApplied`;
11. como eventos do mesmo timestamp são ordenados;
12. convenções atuais para `origin` em outros intents.

Não criar novos módulos se a responsabilidade já existir em algum módulo atual.

---

# Diretrizes arquiteturais

Preservar:

```text
evento acontece
    ↓
gera intent
    ↓
NpcModule decide
    ↓
Accepted / Rejected
    ↓
restante do sistema executa
```

O listener que reage ao evento não deve duplicar a inteligência do `NpcModule`.

Princípio:

> Producers de Intent detectam oportunidades de decisão.
> O NpcModule toma a decisão.

---

# Eventos e documentação

Qualquer evento novo deve ser documentado em `EVENTS.md`.

Se `AggroIntent` for alterado para incluir `origin`, atualizar sua documentação.

Se existir documentação do fluxo de aggro, atualizar também o fluxo:

```text
DamageApplied
→ AggroIntent(origin = DAMAGE_RECEIVED)
→ AggroIntentAccepted / AggroIntentRejected
```

Caso seja criado algum módulo novo — somente se realmente necessário após investigação — documentá-lo em `MODULES.md`.

Seguir a ordem e o padrão já existentes nesses documentos.

---

# Testes / cenários mínimos de validação

A implementação deve ser validada pelo menos com os seguintes cenários:

## Cenário 1 — Aggressive sem target

```text
AGGRESSIVE
sem target
recebe dano de inimigo dentro do aggroRange
```

Esperado:

```text
AggroIntent(DAMAGE_RECEIVED)
→ accepted
→ agressor torna-se target
```

---

## Cenário 2 — Defensive sem target

```text
DEFENSIVE
sem target
recebe dano de inimigo dentro do aggroRange
```

Esperado:

```text
AggroIntent(DAMAGE_RECEIVED)
→ accepted
```

---

## Cenário 3 — Peaceful

```text
PEACEFUL
recebe dano
```

Esperado:

```text
AggroIntent
→ rejected
```

---

## Cenário 4 — Já possui target

```text
AGGRESSIVE ou DEFENSIVE
já possui target ativo
recebe dano de outro inimigo
```

Esperado:

```text
AggroIntent
→ rejected
```

Target atual deve permanecer inalterado.

---

## Cenário 5 — Agressor fora do range

```text
sem target
agressor fora do aggroRange
```

Esperado:

```text
AggroIntent
→ rejected
```

---

## Cenário 6 — Agressor morto

```text
DamageApplied gera AggroIntent
agressor morre antes da validação
```

Esperado:

```text
AggroIntent
→ rejected
```

---

## Cenário 7 — Múltiplos DamageApplied

```text
A, C e D causam dano em B
B inicialmente não possui target
```

Esperado:

- intents podem ser criados para os três;
- o primeiro intent válido processado pode adquirir target;
- intents posteriores devem consultar o estado atual;
- após target adquirido, os demais devem ser rejeitados;
- não criar fila de prioridade.

---

## Cenário 8 — Fonte não aggrável

```text
DamageApplied sem entidade válida como source
```

Esperado:

```text
não gerar AggroIntent inválido
```

---

## Cenário 9 — Estrutura agressora válida

Se estruturas puderem causar dano e forem targets válidos:

```text
Tower causa dano
→ AggroIntent
→ validação normal
```

Esperado:

a origem da entidade não deve ser rejeitada apenas por não ser NPC.

---

# Critérios de aceite

A feature estará concluída quando:

- `DamageApplied` puder originar `AggroIntent`;
- o intent possuir `origin = DAMAGE_RECEIVED`;
- decisões de behavior forem feitas no `NpcModule`;
- apenas `AGGRESSIVE` e `DEFENSIVE` puderem reagir automaticamente;
- units com target atual não trocarem de alvo por causa dessa feature;
- `aggroRange` continuar sendo respeitado;
- regras normais de targeting continuarem válidas;
- múltiplos intents forem resolvidos com base no estado atual, sem fila adicional;
- o fluxo continuar determinístico;
- documentação de eventos estiver atualizada;
- nenhum sistema de threat, memória ou prioridade tiver sido introduzido indevidamente.

---

# Princípio final

> O `DamageApplied` não decide retaliar.
> Ele apenas cria uma oportunidade de decisão.

> O `AggroIntent` não carrega a decisão anterior da unit.
> Quando processado, o `NpcModule` valida todo o estado atual e decide naquele instante.

> `origin` explica de onde surgiu a tentativa de aggro.
> Ele não representa memória, prioridade ou autorização automática.
