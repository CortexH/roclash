# AI DEVELOPMENT WORKFLOW

Este documento define o fluxo obrigatório que uma IA deve seguir ao trabalhar no projeto.

O objetivo é garantir que alterações sejam realizadas de forma controlada, compreendida, investigada, isolada, revisada e validada antes de chegarem à `master`.

A IA deve seguir as etapas na ordem apresentada.

---

# 1. Entendimento

Esta é a primeira e mais importante etapa.

Antes de investigar a implementação ou escrever qualquer código, a IA deve **entender completamente o que está sendo solicitado**.

A IA deve identificar:

* o que precisa ser feito;
* por que precisa ser feito;
* qual comportamento é esperado;
* qual é o escopo da tarefa;
* quais são os critérios para considerar a tarefa concluída;
* quais partes do projeto provavelmente serão afetadas.

A IA não deve começar a implementar enquanto ainda existir uma dúvida relevante sobre o objetivo da tarefa.

Se o pedido estiver ambíguo, incompleto ou possuir múltiplas interpretações relevantes, a IA deve:

1. apontar a ambiguidade;
2. explicar o que precisa ser definido;
3. apresentar alternativas quando possível;
4. aguardar a decisão do usuário.

> **Não implementar algo que a IA ainda não entende.**

Entender a tarefa vem antes de descobrir como implementá-la.

---

# 2. Investigação

Depois de entender o objetivo, a IA deve investigar o projeto antes de decidir como implementar.

Esta etapa é obrigatória.

A IA deve consultar, quando relevante:

* documentação;
* `AI_GUIDELINES.md`;
* este workflow;
* `EVENTS.md`;
* `MODULES.md`;
* `AI_DEVELOPMENT_GUIDELINES.md`
* outras especificações relacionadas;
* estrutura da codebase;
* módulos existentes;
* services existentes;
* sistemas existentes;
* eventos existentes;
* fluxos relacionados;
* implementações semelhantes;
* testes;
* logs;
* referências e consumidores das estruturas envolvidas.

A IA deve procurar primeiro por soluções e padrões existentes.

Antes de criar algo novo, deve verificar se já existe algo equivalente que possa ser reutilizado.

Exemplo:

Se a tarefa exige uma operação que já é fornecida por um service existente, a IA deve utilizar o mecanismo existente em vez de criar uma nova implementação equivalente.

A investigação deve buscar entender não apenas **onde** alterar, mas também **como o fluxo funciona atualmente**.

> **Investigar a codebase antes de decidir a implementação.**

---

# 3. Decisão

Com o entendimento e a investigação concluídos, a IA deve definir a abordagem de implementação.

A decisão deve ser baseada em:

* especificação;
* arquitetura existente;
* padrões encontrados na codebase;
* documentação;
* comportamento atual;
* escopo da tarefa.

Decisões locais e triviais podem ser tomadas autonomamente.

Entretanto, a IA deve parar e consultar o usuário quando a decisão envolver:

* arquitetura;
* responsabilidades entre módulos;
* novos contratos;
* novas regras de gameplay;
* mudanças relevantes de comportamento;
* novas abstrações importantes;
* interpretação ambígua da especificação;
* alterações fora do escopo.

Quando necessário, a IA deve apresentar alternativas e justificar sua recomendação.

> **A IA pode decidir detalhes de implementação. Decisões relevantes devem ser apresentadas ao usuário.**

Antes de continuar, deve existir uma abordagem clara para a implementação.

---

# 4. Criar uma Branch

Somente após entender, investigar e decidir a abordagem, a IA deve iniciar as alterações na codebase.

Antes de modificar o código, deve criar uma **nova branch de trabalho**.

A finalidade é manter a `master` limpa e preservar uma separação clara entre:

* estado estável;
* trabalho em andamento;
* implementação em validação.

A IA deve realizar todas as alterações da tarefa dentro dessa branch.

A `master` não deve ser utilizada como área de desenvolvimento da tarefa.

> **Não iniciar uma implementação diretamente na `master`.**

---

# 5. Implementação

Com a branch criada, a IA pode iniciar a implementação.

Durante esta etapa, deve:

* seguir a abordagem definida;
* respeitar a arquitetura;
* reutilizar padrões existentes;
* alterar somente o necessário;
* manter o escopo da tarefa;
* evitar duplicação;
* evitar abstrações desnecessárias;
* preservar contratos existentes;
* seguir as convenções da codebase.

A IA não deve expandir o escopo silenciosamente.

Se encontrar um problema não relacionado durante a implementação, deve registrá-lo e reportá-lo posteriormente, mas não corrigi-lo sem autorização.

---

## 5.1 Documentação obrigatória durante a implementação

Qualquer **novo evento** criado durante a implementação deve ser documentado no `EVENTS.md`.

Qualquer **novo módulo** criado durante a implementação deve ser documentado no `MODULES.md`.

A documentação deve ser atualizada **como parte da própria implementação**, e não deixada para uma etapa futura indefinida.

### Eventos

Ao adicionar um novo evento, a IA deve:

1. adicioná-lo ao `EVENTS.md`;
2. seguir a organização e ordem existentes;
3. documentar suas informações relevantes;
4. identificar seu papel no sistema;
5. documentar o fluxo do qual participa, quando aplicável.

Se o evento fizer parte de um fluxo existente, como o fluxo de ataque, ele também deve ser incluído na documentação desse fluxo dentro do `EVENTS.md`.

A documentação de eventos deve permitir entender não apenas o evento isoladamente, mas também sua participação no fluxo do sistema.

### Módulos

Ao criar um novo módulo, a IA deve:

1. adicioná-lo ao `MODULES.md`;
2. seguir a organização existente;
3. documentar sua responsabilidade;
4. documentar suas relações e limites relevantes;
5. manter a documentação consistente com a arquitetura existente.

> **Código novo e documentação correspondente devem permanecer sincronizados.**

---

# 6. Revisão

Depois de implementar a tarefa, a IA deve revisar suas próprias alterações antes de solicitar validação.

A revisão deve verificar, quando aplicável:

* se a implementação corresponde à especificação;
* se o escopo foi respeitado;
* se a arquitetura foi preservada;
* se responsabilidades foram colocadas no lugar correto;
* se existe código duplicado;
* se novas abstrações realmente são necessárias;
* se os padrões existentes foram seguidos;
* se eventos foram documentados;
* se módulos foram documentados;
* se fluxos relacionados foram atualizados;
* se existem alterações acidentais;
* se existem alterações não relacionadas;
* se existem problemas óbvios de lógica.

A IA deve analisar o conjunto da alteração, não apenas o código que acabou de escrever.

Se encontrar um problema arquitetural durante a revisão, não deve corrigi-lo autonomamente. Deve reportá-lo e solicitar uma decisão.

---

# 7. Validação com o Usuário

Depois da revisão, a IA deve solicitar que o usuário valide o comportamento da implementação.

A IA deve explicar:

* o que foi implementado;
* o que deve ser testado;
* qual comportamento é esperado;
* qualquer cenário importante que deva ser observado.

No sistema de combate, logs de eventos são uma ferramenta importante para essa validação.

O usuário pode retornar:

* confirmação de que funcionou;
* comportamento inesperado;
* erro;
* logs;
* evidências adicionais.

Se a validação falhar, a IA deve retornar ao processo de investigação.

### Fluxo de correção

```text
Resultado do teste
    ↓
Problema encontrado
    ↓
Investigar
    ↓
Identificar causa
    ↓
Corrigir na branch
    ↓
Revisar novamente
    ↓
Solicitar novo teste
```

O processo pode ser repetido quantas vezes forem necessárias.

A tarefa somente avança quando o comportamento estiver validado pelo usuário.

> **A IA não deve considerar a tarefa concluída apenas porque a implementação parece correta.**

---

# 8. Commit e Merge na Master

A IA **não deve realizar commit ou merge na `master` automaticamente ao terminar a implementação**.

Essas operações dependem de uma solicitação explícita.

Depois que:

1. a implementação estiver concluída;
2. a revisão estiver concluída;
3. o usuário tiver validado o comportamento;

a IA deve aguardar a solicitação para realizar o commit.

Após a solicitação de commit:

1. preparar o commit da alteração;
2. utilizar uma mensagem de commit coerente com a alteração;
3. manter o commit restrito ao escopo da tarefa;
4. posteriormente, quando solicitado/autorizado, realizar o merge da branch na `master`.

A `master` representa o estado integrado e validado do projeto.

> **Implementar não significa automaticamente commitar.**
>
> **Validar não significa automaticamente fazer merge.**

---

# 9. Encerramento

Após o trabalho estar validado e o fluxo de Git concluído conforme solicitado, a IA deve apresentar um resumo final.

O encerramento deve informar:

### O que foi feito

Resumo objetivo das alterações realizadas.

### Como foi implementado

Principais decisões e estruturas utilizadas.

### Documentação atualizada

Indicar quais documentos foram alterados, especialmente:

* `EVENTS.md`;
* `MODULES.md`;
* Passar o documento da funcionalidade (bug, task ou refactor) para o diretório 'finished' na mesma pasta do item
* outros documentos relevantes.

### Validação

Informar:

* o que foi testado;
* resultado dos testes;
* problemas encontrados durante a validação;
* se houve iterações de correção.

### Git

Informar:

* branch utilizada;
* commit realizado, quando aplicável;
* merge realizado, quando aplicável.

### Observações

Listar problemas não relacionados encontrados durante o trabalho que não foram corrigidos por estarem fora do escopo.

### Sugestões

A IA pode apresentar ideias ou melhorias descobertas durante o processo.

Essas sugestões devem permanecer separadas da implementação realizada.

Não devem ser aplicadas automaticamente.

---

# 10. Fluxo Completo

O fluxo padrão de desenvolvimento é:

```text
1. ENTENDIMENTO
       ↓
2. INVESTIGAÇÃO
       ↓
3. DECISÃO
       ↓
4. CRIAR BRANCH
       ↓
5. IMPLEMENTAÇÃO
       ↓
6. REVISÃO
       ↓
7. VALIDAÇÃO COM O USUÁRIO
       ↓
   ┌───┴───┐
   │       │
 FALHOU  APROVADO
   │       │
   ↓       ↓
INVESTIGAR 8. COMMIT / MERGE
   │       │
   └─→ CORRIGIR
           ↓
      9. ENCERRAMENTO
```

A documentação de eventos e módulos ocorre **durante a implementação**:

```text
Novo Evento
    ↓
Implementar
    ↓
Documentar em EVENTS.md
    ↓
Se fizer parte de um fluxo:
documentar também no fluxo correspondente
```

```text
Novo Módulo
    ↓
Implementar
    ↓
Documentar em MODULES.md
```

---

# 11. Regras Fundamentais do Workflow

As seguintes regras são obrigatórias:

1. **Entender antes de investigar a implementação.**
2. **Investigar antes de decidir.**
3. **Decidir antes de implementar.**
4. **Criar uma branch antes de modificar a codebase.**
5. **Nunca desenvolver diretamente na `master`.**
6. **Respeitar a arquitetura durante toda a implementação.**
7. **Não expandir o escopo silenciosamente.**
8. **Documentar todo novo evento em `EVENTS.md`.**
9. **Documentar todo novo módulo em `MODULES.md`.**
10. **Documentar eventos também dentro dos fluxos dos quais participam.**
11. **Revisar as alterações antes da validação.**
12. **A validação final depende do usuário.**
13. **Se a validação falhar, investigar novamente em vez de mascarar o problema.**
14. **Não realizar commit sem solicitação.**
15. **Não realizar merge na `master` sem solicitação/autorização.**
16. **Encerrar somente após a alteração estar validada e o fluxo solicitado de Git estar concluído.**

---

# Princípio do Workflow

O desenvolvimento deve seguir:

> **Entender → Investigar → Decidir → Isolar → Implementar → Revisar → Validar → Integrar → Encerrar**

Cada etapa existe para reduzir incerteza antes de avançar para a próxima.

A IA não deve pular etapas simplesmente porque acredita que a alteração é simples.
