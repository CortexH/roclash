# Feature — Padronização Semântica das Queries

## Objetivo

Padronizar a semântica dos eventos de **Query** utilizados na comunicação entre frontend e backend da batalha.

A alteração deve estabelecer um contrato simples para que:

- o próprio `eventType` identifique semanticamente qual operação está sendo solicitada;
- `requestId` identifique uma requisição específica;
- `requesterId` identifique quem originou a requisição;
- múltiplos consumidores possam escutar a mesma resposta sem a necessidade de criar eventos diferentes para cada contexto de uso.

Esta alteração é arquitetural e deve ser implementada de forma compatível com os padrões já existentes no projeto.

---

## Contexto

O sistema possui operações que precisam consultar informações do backend.

Um mesmo tipo de informação pode ser solicitado por diferentes partes do frontend.

Por exemplo, uma consulta de dados do castelo pode ser utilizada por várias telas ou componentes.

Não queremos criar eventos semanticamente duplicados apenas porque a mesma informação foi solicitada por lugares diferentes.

Exemplo do problema que deve ser evitado:

```text
CastleDataForBattleHUD
CastleDataForCastleScreen
CastleDataForMiniMap
CastleDataForInspection
...
```

Todos representam essencialmente a mesma operação:

```text
"buscar dados do castelo"
```

O evento de Query deve representar a **operação**, enquanto o `requestId` identifica a **requisição específica**.

---

# Semântica dos campos

Uma Query deve seguir o conceito:

```text
eventType
    ↓
O que está sendo solicitado?

requestId
    ↓
Qual requisição específica é essa?

requesterId
    ↓
Quem realizou a requisição?
```

## `eventType`

O `eventType` é a identificação semântica da Query.

Ele já funciona como a assinatura da operação.

Não deve ser criado um campo adicional como:

```ts
signature: "CASTLE_DATA"
```

quando o próprio evento já possui:

```ts
eventType: "CastleDataQuery"
```

Isso criaria informação redundante.

### Regra

O nome/tipo do evento deve ser suficiente para identificar **qual operação a Query representa**.

Exemplos:

```text
UnitSelectQuery
CastleDataQuery
UnitPathfindingQuery
BattleStateQuery
```

Não adicionar um campo `signature` apenas para repetir a semântica já expressa pelo `eventType`.

---

# `requestId`

O `requestId` identifica uma instância específica de uma Query.

Duas Queries podem possuir o mesmo `eventType` e ainda assim serem requisições completamente diferentes.

Exemplo:

```text
CastleDataQuery
requestId = "AAA"
```

e:

```text
CastleDataQuery
requestId = "BBB"
```

As duas consultas representam a mesma operação, porém são requisições distintas.

A resposta deve preservar o `requestId` correspondente para permitir que o frontend associe a resposta à requisição que a originou.

### Exemplo

```text
Frontend A
    ↓
CastleDataQuery
requestId = AAA

Frontend B
    ↓
CastleDataQuery
requestId = BBB

Backend
    ↓

CastleDataQueryResponse
requestId = AAA

CastleDataQueryResponse
requestId = BBB
```

Um consumidor interessado na requisição `AAA` deve ignorar a resposta `BBB`.

---

# `requesterId`

O `requesterId` identifica o responsável pela requisição.

No contexto atual, a batalha possui essencialmente um único dono da fila/batalha, portanto esse campo pode parecer redundante.

Ainda assim, ele deve fazer parte do contrato das Queries.

A intenção é manter explícita a autoria/contexto da requisição e permitir evolução futura caso uma batalha possa possuir mais de um participante ou solicitante.

O `requesterId` não deve ser utilizado para diferenciar componentes ou listeners dentro do mesmo cliente.

Essa diferenciação é responsabilidade do `requestId`.

---

# Contrato esperado

Uma Query deve seguir o padrão conceitual:

```ts
export type UnitSelectQuery = {
    eventType: "UnitSelectQuery",
    type: "QUERY",

    requestId: string,
    requesterId: string,

    delay: number,

    data: {
        unitId: string
    }
}
```

Os campos de domínio dentro de `data` continuam variando conforme a Query.

O padrão de identificação, entretanto, deve permanecer consistente.

---

# Semântica da resposta

Quando uma Query gerar uma resposta, a resposta deve manter informação suficiente para correlacionar a resposta com sua origem.

Conceitualmente:

```text
QUERY
 ├── eventType
 ├── requestId
 ├── requesterId
 └── data

        ↓

QUERY_RESPONSE
 ├── eventType / tipo correspondente
 ├── requestId
 ├── requesterId
 └── data
```

A implementação deve investigar o padrão de eventos de resposta já existente no projeto e adaptá-lo a esse contrato, sem criar uma arquitetura paralela.

O ponto essencial é que o `requestId` da resposta corresponda ao `requestId` da Query original.

---

# Múltiplos consumidores

Uma mesma resposta pode ser observada por diversos listeners do frontend.

Isso é permitido e esperado.

Exemplo:

```text
             CastleDataQueryResponse
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
     BattleHUD     CastleScreen   MiniMap
```

Cada consumidor pode verificar se a resposta corresponde à requisição que realizou.

Exemplo conceitual:

```lua
if response.requestId ~= myRequestId then
    return
end
```

O listener que não possui interesse naquela resposta simplesmente ignora o evento.

### Importante

Não criar eventos separados apenas para atender consumidores diferentes da mesma operação.

O evento representa a operação semântica, não o local do frontend que a utiliza.

---

# Exemplo: consulta de Pathfinding

O sistema de pathfinding do backend já possui a capacidade de calcular um caminho.

Essa capacidade deve ser disponibilizada ao frontend através de uma Query.

A Query deve seguir a mesma semântica definida neste documento.

Conceitualmente:

```ts
export type UnitPathfindingQuery = {
    eventType: "UnitPathfindingQuery",
    type: "QUERY",

    requestId: string,
    requesterId: string,

    delay: number,

    data: {
        unitId: string,
        destination: Cell
    }
}
```

O formato exato dos dados deve ser descoberto através da investigação do código existente.

A implementação não deve duplicar o algoritmo de pathfinding no frontend.

O frontend deve consultar o backend e utilizar o resultado fornecido por ele.

---

# Regras de implementação

1. Não criar um campo `signature` redundante quando o `eventType` já identifica a operação.
2. `requestId` deve identificar exclusivamente uma requisição.
3. A resposta de uma Query deve preservar o `requestId` necessário para correlação.
4. `requesterId` deve identificar o responsável pela requisição.
5. `requesterId` não deve ser utilizado como identificador de componente/listener dentro do cliente.
6. Não criar eventos diferentes para cada consumidor da mesma operação.
7. Uma mesma resposta pode ser observada por múltiplos listeners.
8. Listeners que não possuem interesse na resposta devem simplesmente ignorá-la.
9. Utilizar os padrões existentes do projeto para eventos, Queries e respostas.
10. Não criar uma nova arquitetura de comunicação para resolver este problema.
11. Antes de implementar, investigar como Queries e respostas são atualmente criadas, encaminhadas e consumidas.
12. Não alterar o backend de domínio de uma Query sem necessidade. Esta alteração trata principalmente da semântica e correlação das Queries.
13. O sistema deve permanecer compatível com a arquitetura event-driven existente.

---

# Fora de escopo

Esta alteração **não** deve:

- implementar o sistema completo de movimentação da Unit;
- alterar o algoritmo de pathfinding;
- criar um novo sistema de eventos;
- criar uma nova arquitetura de listeners;
- adicionar um sistema de `signature`;
- refatorar componentes do frontend sem necessidade para cumprir o contrato;
- alterar regras de combate;
- alterar regras de seleção de Unit;
- criar eventos específicos para cada tela ou componente.

A Query de pathfinding pode ser criada como aplicação prática deste padrão caso seja necessária para a implementação atual, mas o objetivo desta feature é estabelecer a semântica e correlação das Queries.

---

# Investigação obrigatória

Antes de modificar qualquer código, investigar:

- onde os tipos de Query existentes estão definidos;
- como `type: "QUERY"` é utilizado atualmente;
- como Queries são enviadas;
- como Queries chegam ao backend;
- como respostas de Queries são geradas;
- como respostas chegam ao frontend;
- como listeners são registrados;
- se já existe algum mecanismo equivalente a `requestId`;
- se já existe algum identificador equivalente a `requesterId`;
- como eventos são nomeados no projeto;
- como o sistema atual de seleção/ataque utiliza eventos e respostas.

A implementação deve reutilizar as abstrações existentes sempre que possível.

---

# Critérios de aceitação

A feature será considerada concluída quando:

- [ ] Queries possuem identificação semântica através do próprio `eventType`.
- [ ] Não existe um campo `signature` redundante para repetir o significado do `eventType`.
- [ ] Queries possuem `requestId`.
- [ ] Queries possuem `requesterId`.
- [ ] Uma resposta consegue ser correlacionada à Query original através do `requestId`.
- [ ] Duas Queries do mesmo tipo podem existir simultaneamente sem ambiguidade.
- [ ] Múltiplos listeners podem observar a mesma resposta.
- [ ] Um listener consegue ignorar respostas que não correspondem ao seu `requestId`.
- [ ] Não existem eventos duplicados apenas para diferenciar consumidores.
- [ ] A implementação utiliza a arquitetura existente do projeto.
- [ ] O sistema existente de seleção/ataque continua funcionando.
- [ ] A Query de pathfinding, caso implementada nesta etapa, utiliza o mesmo contrato semântico.