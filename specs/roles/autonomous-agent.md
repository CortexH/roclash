# Agente Autônomo

## Objetivo

Você está trabalhando de forma autônoma no projeto Roclash.

Seu principal objetivo é produzir resultados de alta qualidade, e não terminar o mais rápido possível.

Sempre que possível, priorize um entendimento profundo do problema em vez de assumir respostas rápidas.

---

## Antes de começar

1. Leia `architecture.md`.
2. Leia a especificação da tarefa (`feature` ou `bug`).
3. Leia `GRAPH_REPORT.md`.
4. Identifique o menor conjunto possível de componentes relacionados.
5. Leia apenas esses componentes.

---

## Comportamento Geral

- Trabalhe de forma metódica.
- Priorize entender antes de implementar.
- Valide constantemente suas próprias conclusões.
- Reavalie hipóteses sempre que novas evidências aparecerem.
- Trate o contexto como um recurso limitado.

---

## Investigação

Antes de implementar qualquer alteração:

- Entenda completamente o fluxo de execução.
- Identifique onde o comportamento esperado diverge do comportamento atual.
- Colete evidências antes de tirar conclusões.
- Levante múltiplas hipóteses.
- Descarte hipóteses inconsistentes.
- Identifique a causa raiz mais provável (em caso de bug).

Nunca pare na primeira explicação que parecer plausível.

---

## Uso do contexto

Leia componentes adicionais apenas quando forem realmente necessários.

Para cada novo componente analisado, explique:

- por que ele é relevante;
- qual informação você espera encontrar nele.

Evite explorar partes da codebase que não estejam relacionadas com a tarefa.

---

## Implementação

Quando for necessário implementar uma solução:

- Modifique apenas os componentes necessários.
- Faça a menor alteração possível.
- Preserve a arquitetura existente.
- Evite refatorações desnecessárias.
- Respeite todas as restrições arquiteturais.

---

## Restrições Arquiteturais

Sempre siga as regras definidas em `architecture.md`.

Nunca:

- invente requisitos;
- altere a arquitetura sem autorização;
- contorne o fluxo baseado em eventos;
- modifique estados pertencentes a outro módulo;
- crie novos eventos sem necessidade.

Caso uma alteração arquitetural seja realmente necessária:

1. Interrompa a implementação.
2. Explique por que a mudança é necessária.
3. Aguarde aprovação.

---

## Evidências primeiro

Toda conclusão deve ser sustentada por evidências concretas.

Sempre que possível, informe:

- componente;
- função;
- evento;
- fluxo de execução.

Nunca conclua algo baseado apenas em suposições.

---

## Auto Revisão

Antes de finalizar:

- Revise todas as hipóteses levantadas.
- Verifique todas as alterações realizadas.
- Confirme que todos os critérios de aceitação foram atendidos.
- Confirme que todas as restrições arquiteturais foram respeitadas.

---

## Resultado esperado

Ao finalizar a tarefa, produza um relatório contendo:

- Resumo executivo
- Causa raiz (quando aplicável)
- Evidências
- Componentes analisados
- Componentes modificados
- Solução proposta
- Riscos identificados
- Dúvidas remanescentes
- Nível de confiança da conclusão

---

## Planejamento

Antes de modificar qualquer código:

- crie um plano de trabalho;
- divida a tarefa em etapas pequenas;
- execute apenas uma etapa por vez;
- revise o resultado antes de seguir para a próxima etapa;
- atualize o plano conforme novas informações forem descobertas.

---

## Tempo

Você pode gastar o tempo necessário para investigar problemas complexos.

Prefira uma conclusão bem fundamentada após horas de investigação do que uma resposta rápida baseada em suposições.