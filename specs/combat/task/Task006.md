# Feature — Preview de Caminho para Movimentação de Unit

## Objetivo

Implementar no frontend o consumo do pathfinding existente no backend para permitir que o jogador visualize, em tempo real, o caminho que uma Unit percorreria antes de confirmar uma ordem de movimentação.

O backend já possui o sistema responsável por calcular o caminho.

Esta feature **não implementa nem altera o algoritmo de pathfinding**.

O frontend deve apenas:
1. entrar no modo de seleção de destino;
2. consultar o backend quando o destino/origem relevante mudar de célula;
3. receber o resultado do pathfinding;
4. representar visualmente o caminho retornado.

---

## Contexto

O sistema de movimentação do backend já utiliza o pathfinding.

De forma simplificada:

```text
posição inicial + posição final
        ↓
MovementIntent
        ↓
Pathfinding
        ↓
PathResult
```

O frontend precisa utilizar essa mesma capacidade para fornecer um preview visual ao jogador.

Enquanto o jogador estiver escolhendo o destino de uma Unit, o frontend deve mostrar as células pelas quais a Unit passaria.

O frontend **não deve calcular o caminho por conta própria**.

---

## Fluxo esperado

### 1. Jogador inicia a movimentação

Quando o jogador clicar no botão `MOVER` da UnitCard, o frontend deve iniciar a interação de movimentação seguindo o mesmo padrão já utilizado pela interação de ataque.

O comportamento de seleção existente deve ser preservado.

A implementação deve investigar o fluxo atual de `ATACAR` e reutilizar suas abstrações de interação/seleção sempre que possível.

### 2. Jogador aponta para um destino

Enquanto a interação de movimentação estiver ativa, o jogador poderá mover o mouse pelo campo de batalha.

O cursor representa a posição final desejada para a Unit.

Não deve ser feita uma Query de pathfinding a cada atualização do mouse.

A Query deve ser disparada somente quando houver mudança relevante de célula.

---

## Gatilhos para recalcular o caminho

O preview deve ser recalculado quando ocorrer qualquer uma das seguintes mudanças:

### Mouse

O mouse mudou o suficiente para passar para outra célula.

```text
Mouse Cell A
     ↓
Mouse Cell B
     ↓
nova Query
```

Movimentos do mouse dentro da mesma célula não devem gerar novas Queries.

### Unit

A Unit também pode mudar de célula enquanto o jogador permanece no modo de movimentação.

Quando a Unit tiver avançado o suficiente para trocar de célula, o frontend deve considerar a posição atualizada da Unit e recalcular o preview.

Portanto, o caminho é baseado na posição atual da Unit, e não necessariamente na posição que ela possuía quando o jogador iniciou a interação.

---

## Dados enviados ao Pathfinding

Cada recalculo deve consultar o backend utilizando:

```text
start = posição atual da Unit
goal  = célula apontada pelo mouse
```

A Query deve seguir o padrão estabelecido para as demais Queries do sistema.

Utilizar `UnitSelectQuery` como referência para compreender:
- estrutura do evento;
- `type`;
- `requestId`;
- `requesterId`;
- `delay`;
- organização de `data`;
- fluxo de envio;
- fluxo de resposta;
- registro/consumo de listeners.

Não inventar uma nova arquitetura de Query para o pathfinding.

Conceitualmente:

```ts
UnitPathfindingQuery
    requestId
    requesterId
    delay
    data
        unitId
        start
        goal
```

Os nomes exatos devem seguir as convenções existentes no projeto.

---

## Resposta do Pathfinding

O frontend deve utilizar a resposta do backend como fonte de verdade para o preview.

O resultado do pathfinding já possui o conceito de `PathResult`.

A implementação deve investigar o contrato real existente e utilizar os dados fornecidos pelo backend.

O frontend não deve recalcular, corrigir ou substituir o caminho recebido.

A ideia é ser feito de forma parecida com o UnitSelectQuery, onde retorna query success ou não. e com esses dados criar o path no front.

---

## Renderização do Preview

Quando a resposta do pathfinding chegar, o frontend deve representar visualmente as células do caminho.

```text
Backend
   ↓
PathResult
   ↓
Frontend
   ↓
células do caminho
   ↓
preview visual
```

O caminho deve ser atualizado sempre que uma nova resposta válida for recebida.

A visualização deve representar o caminho retornado pelo backend, não um caminho estimado pelo cliente.

---

## Pathfinding é Preview, não Movimento

A Query de pathfinding **não executa a movimentação**.

Ela somente responde:

> "Qual seria o caminho?"

Portanto:

```text
UnitPathfindingQuery
        ↓
    PathResult
        ↓
    Preview visual
```

não deve iniciar o movimento real da Unit.

O movimento efetivo continuará utilizando o fluxo de movimentação já existente no backend.

Conceitualmente:

```text
Player → MOVER
             ↓
     seleção/preview
             ↓
      confirmação
             ↓
    MovementIntent existente
```

A implementação deve investigar o fluxo atual de `MovementIntent` e conectá-lo à confirmação da interação, sem duplicar a lógica de movimentação.

---

## Correlação das Queries

Cada solicitação de pathfinding deve possuir seu próprio `requestId`.

Isso é importante porque o jogador pode mover o mouse rapidamente e gerar várias Queries sucessivas:

```text
Query A → requestId A
Query B → requestId B
Query C → requestId C
Query D → requestId D
```

As respostas podem retornar posteriormente.

O frontend deve utilizar o mecanismo de correlação existente para determinar a qual solicitação cada resposta pertence.

Uma resposta antiga não deve sobrescrever indevidamente um preview mais recente.

Exemplo conceitual:

```text
Mouse → célula A
    ↓
Query A

Mouse → célula B
    ↓
Query B

Mouse → célula C
    ↓
Query C

Resposta B chega
    ↓
preview de B

Resposta C chega
    ↓
preview de C
```

Se uma resposta correspondente a um estado anterior não for mais relevante para o estado atual da interação, ela deve ser ignorada.

A implementação deve investigar como o projeto atualmente trata respostas e correlação antes de introduzir qualquer mecanismo novo.

---

## Mudança de célula como unidade de atualização

O sistema deve trabalhar com células, e não com pequenas variações contínuas de posição.

Se várias posições do mouse pertencem à mesma célula lógica, nenhuma nova Query deve ser enviada.

Quando o mouse passar para outra célula, uma nova Query deve ser realizada.

O mesmo princípio deve ser aplicado à posição da Unit.

---

## Investigação obrigatória

Antes de implementar, investigar:
- implementação atual da interação `ATACAR`;
- implementação atual da interação `MOVER`, caso já exista parcialmente;
- UnitCard e botão `MOVER`;
- sistema responsável por seleção/interação;
- sistema responsável por obter a célula sob o mouse;
- representação da posição da Unit no frontend;
- eventos enviados pelo frontend ao backend;
- `MovementIntent`;
- sistema de pathfinding existente;
- contrato real do `PathResult`;
- mecanismo existente de Queries;
- `UnitSelectQuery`;
- mecanismo existente de respostas;
- mecanismo de `requestId`;
- mecanismo de listeners;
- sistema responsável por renderizar/alterar a representação das células do campo.

A implementação deve reutilizar as abstrações existentes.

Não criar classes, serviços, eventos ou sistemas duplicados antes de verificar se já existe uma abstração equivalente.

---

## Regras de implementação

1. O frontend não implementa pathfinding.
2. O backend permanece como fonte de verdade do caminho.
3. A Query de pathfinding deve seguir o padrão das Queries existentes.
4. `UnitSelectQuery` deve ser utilizada como referência estrutural.
5. Cada Query deve possuir `requestId`.
6. Cada Query deve possuir `requesterId`.
7. Não adicionar uma nova arquitetura de comunicação.
8. Não realizar Queries continuamente a cada movimento do mouse.
9. Mudanças dentro da mesma célula não devem gerar novas Queries.
10. Mudanças de célula do mouse devem gerar nova Query.
11. Mudanças de célula da Unit devem permitir o recálculo do caminho.
12. A origem do pathfinding deve representar a posição atual da Unit no momento do recálculo.
13. O destino deve representar a célula atualmente apontada pelo mouse.
14. O resultado recebido deve ser utilizado para o preview visual.
15. O preview não deve executar o movimento da Unit.
16. O movimento real deve continuar utilizando o fluxo existente de `MovementIntent`.
17. Respostas antigas ou não mais relevantes não devem sobrescrever um preview mais recente.
18. Não alterar o algoritmo ou as regras de pathfinding como parte desta feature.
19. Não criar um segundo sistema de renderização de células sem investigar o existente.
20. Não expandir o escopo para novas mecânicas de movimentação.

---

## Fora de escopo

Esta feature não deve:
- alterar o algoritmo de pathfinding;
- alterar regras de colisão;
- alterar regras de movimento;
- alterar velocidade da Unit;
- alterar `MovementIntent`;
- criar um novo sistema de movimentação no backend;
- implementar pathfinding no cliente;
- criar um sistema de tick para atualizar o preview;
- criar novas regras de navegação;
- alterar a lógica de seleção existente;
- implementar novas funcionalidades de UI além da visualização necessária do caminho;
- criar uma arquitetura nova de Query/Response.

---

## Critérios de aceitação

- [ ] Clicar em `MOVER` inicia a interação de movimentação seguindo o padrão existente.
- [ ] O jogador consegue apontar para uma célula do campo como destino.
- [ ] O frontend identifica corretamente a célula sob o mouse.
- [ ] Movimentos dentro da mesma célula não geram novas Queries.
- [ ] Ao mudar de célula, uma nova Query de pathfinding é enviada.
- [ ] A Query utiliza a posição atual da Unit como origem.
- [ ] A Query utiliza a célula do mouse como destino.
- [ ] A Query segue o padrão estrutural das Queries existentes.
- [ ] A Query possui `requestId`.
- [ ] A Query possui `requesterId`.
- [ ] O frontend recebe a resposta do backend.
- [ ] O resultado do backend é utilizado como fonte de verdade para o preview.
- [ ] As células retornadas pelo pathfinding são visualmente destacadas.
- [ ] Uma nova resposta atualiza o preview.
- [ ] Respostas antigas não sobrescrevem incorretamente um preview mais recente.
- [ ] Se a Unit mudar de célula durante a interação, o caminho pode ser recalculado a partir da nova posição.
- [ ] O preview não executa o movimento real.
- [ ] A confirmação da movimentação continua utilizando o fluxo existente de `MovementIntent`.
- [ ] Nenhum algoritmo de pathfinding é duplicado no frontend.
- [ ] O sistema existente de seleção/ataque continua funcionando.
- [ ] Nenhuma nova arquitetura de interação ou Query foi criada desnecessariamente.

---

## Validação sugerida

### Caso 1 — Preview básico

1. Selecionar uma Unit.
2. Clicar em `MOVER`.
3. Mover o mouse para uma célula distante.
4. Confirmar que o backend é consultado.
5. Confirmar que o caminho retornado é visualizado.

### Caso 2 — Movimento dentro da mesma célula

1. Entrar no modo `MOVER`.
2. Mover o mouse sem trocar de célula.
3. Confirmar que nenhuma nova Query é gerada.

### Caso 3 — Troca de célula

1. Entrar no modo `MOVER`.
2. Apontar para uma célula.
3. Mover o mouse para outra célula.
4. Confirmar que uma nova Query é gerada.

### Caso 4 — Caminho bloqueado

1. Selecionar um destino que possua obstáculos.
2. Confirmar que o preview corresponde ao `PathResult` retornado pelo backend.
3. Não tentar calcular uma alternativa no cliente.

### Caso 5 — Unit muda de célula

1. Iniciar a interação de movimentação.
2. Permitir que a Unit avance para outra célula.
3. Confirmar que o frontend consegue recalcular o preview usando a nova posição da Unit como origem.

### Caso 6 — Respostas fora de ordem

1. Gerar múltiplas Queries rapidamente.
2. Fazer as respostas retornarem em ordem diferente da criação.
3. Confirmar que uma resposta antiga não substitui incorretamente o preview correspondente ao estado mais recente.

---

## Princípio central

A responsabilidade deve permanecer separada:

```text
Frontend
    ↓
"Quero saber qual caminho esta Unit faria até aqui."

Backend
    ↓
"Este é o caminho calculado."

Frontend
    ↓
"Vou representar esse caminho."

Player confirma
    ↓
MovementIntent existente
    ↓
Backend executa o movimento
```

O frontend **consulta e representa**.

O backend **calcula e executa**.

---

# Pendências e Edge Cases (a resolver na finalização)

> Registro de pontos levantados durante a implementação/validação que devem ser tratados antes de considerar a feature 100% fechada.

## 1. Recálculo do preview quando a Unit muda de célula

- **Objetivo:** enquanto a interação de movimentação estiver ativa, se a Unit avançar e trocar de célula, o preview deve ser recalculado usando a nova posição da Unit como origem.
- **Regra obrigatória:** disparar a Query **somente quando a Unit trocar de célula** — nunca por mudança de posição contínua.
- **Abordagem proposta:** monitorar a posição interpolada da Unit (via `UnitView.visual.currentMovement:getPosition(ct)` + `mapUtils.getCellByPosition`), comparando a célula atual com a última usada na Query. Só disparar nova Query na troca de célula.
- **Observação:** o front não é 100% orientado a eventos para isso — o evento `UnitMove` informa o destino, mas não o progresso. Portanto, um monitoramento (Heartbeat) que converte posição→célula é a abordagem viável.

## 2. Correlação de respostas fora de ordem

- O back processa a fila de eventos em **FIFO**, então as respostas saem na ordem de processamento no servidor.
- **Ressalva:** os Remotes (`CommandSender`) não garantem ordem de **chegada** ao servidor — o cliente pode disparar Query A, B, C e o servidor receber B antes de A. Isso pode gerar resposta fora de ordem do ponto de vista do cliente.
- **Ação:** avaliar se é necessário um mecanismo de correlação (ex.: contador local no frontend para ignorar respostas antigas) ou se o FIFO do back é suficiente na prática.

## 3. Edge cases a tratar

- [x] Unit **morre** ou é **removida** durante a interação → o `UnitCellMonitor` remove o monitoramento automaticamente quando a unit não existe mais.
- [x] Interação **cancelada** no meio do movimento → `stopSelect` limpa o monitoramento; e o callback do monitoramento encerra sozinho se a interação de mover não for mais a ativa (evita vazamento ao trocar para ATACAR/seleção).
- [x] Clicar em `MOVER` **sem unit selecionada** → guarda no `beginSelect` (`if not selectedUnitId then return end`).
- [x] Apontar para **fora do mapa** (célula infinita) → tratado com `isCellInBounds`; manter como regressão.
- [x] Combinar os dois gatilhos de recálculo (célula do mouse **e** célula da Unit) sem duplicar requisições → ambos usam `requestPathPreview`; o monitoramento só dispara na troca de célula da unit.
- [x] Garantir que o preview não execute o movimento real (regressão).
- [ ] Unit **para** de se mover (chega ao destino) → célula para de mudar; garantir que o monitoramento não fique ativo sem necessidade (o monitoramento só dispara na troca de célula, então fica ocioso — avaliar se deve ser encerrado).

## 4. Edge cases do fluxo de seleção (`UnitSelectQuery`) e seleção de movimento

- [ ] **Resposta de seleção fora de ordem** — clicar em várias units rapidamente dispara múltiplas `UnitSelectQuery`; a resposta pode chegar fora de ordem e o card mostrar a unit errada (mesmo problema de correlação do item 2).
- [ ] **Unit morre/é removida após a seleção** — o card fica com dados obsoletos de uma unit inexistente.
- [ ] **Selecionar unit não colocada ou de outro jogador** — o backend valida (`canTarget`/`canMove`), mas o card pode exibir ações que serão rejeitadas.
- [ ] **Selecionar a mesma unit duas vezes** — comportamento de toggle/duplicidade.
- [ ] **Destino = posição atual** — `MoveIntent` rejeitado (`ALREADY_AT_TARGET`); preview pode mostrar caminho vazio.
- [ ] **Clicar fora do mapa ao confirmar** — `MOVE_UNIT` para célula inválida; backend rejeita (`INVALID_POSITION`).
