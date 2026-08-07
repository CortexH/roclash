# AI Guidelines

## Antes de implementar

- leia architecture.md.
- leia a spec da feature/bug.
- leia apenas os arquivos relacionados / arquivos colocados na spec da feature.

## Durante a implementação

- Não invente requisitos
- Não altere a arquitetura sem autorização.
- Não crie eventos novos sem necessidade.
A criação de eventos novos não é restrita, mas pare a implementação e avise caso seja necessário.
- Não modifique arquivos fora do escopo.

## Em caso de dúvida

- Não assuma comportamento.
- Explique quais informações estão faltando.
- Solicite apenas os arquivos necessários.

## Após implementar

- Revise sua implementação.
- Confirme que todos os critérios de aceitação foram atendidos.
- Confirme que todas as restrições arquiteturais foram respeitadas.
- Liste os arquivos modificados e justifique cada alteração.

## Fluxo

Sempre siga o fluxo abaixo.

1. Leia architecture.md.
2. Leia a spec.
3. Identifique os arquivos necessários.
4. Leia apenas esses arquivos.
5. Analise a tarefa.
6. Caso necessário, solicite arquivos adicionais.
7. Planeje a implementação.
8. Implemente.
9. Revise a implementação.
10. Confirme que as restrições arquiteturais foram respeitadas.

Nunca:

- invente requisitos;
- altere arquitetura sem autorização;
- leia a codebase inteira;
- modifique arquivos fora do escopo;
- faça suposições quando houver dúvida.
- modificar estado pertencente a outro módulo.