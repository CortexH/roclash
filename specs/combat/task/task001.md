# Task: Emitir `VerifyAggroReachedEvent` após `MovementIntentRejected(ALREADY_AT_TARGET)`

## Objetivo

Garantir que o fluxo de movimentação consiga finalizar corretamente quando um `MovementIntent` for rejeitado porque a unidade já está no destino desejado.

Atualmente, quando um `MovementIntent` é rejeitado com o motivo:

ALREADY_AT_TARGET

o fluxo de movimentação é encerrado sem existir uma etapa posterior responsável por verificar se o objetivo foi alcançado.

O objetivo desta task é permitir que este cenário siga o mesmo fluxo conceitual de uma movimentação concluída:

MovementFinishedEvent
        ↓
VerifyAggroReachedEvent
        ↓
VerifyAggroReachedHandler

Sem alterar o comportamento atual da movimentação.

---

# Situação atual

Atualmente existe o seguinte fluxo:

MovementIntent
        ↓
MovementIntentRejectedEvent
        ↓
reason: ALREADY_AT_TARGET
        ↓
fim do fluxo

O problema é que, neste cenário, o sistema sabe que a unidade já está na posição desejada, porém nenhuma etapa posterior é executada para verificar se o objetivo associado ao movimento foi alcançado.

Exemplo:

NPC possui aggro em uma unidade inimiga

        ↓

NPC gera MovementIntent

        ↓

Validação verifica posição atual

        ↓

NPC já está próximo o suficiente do alvo

        ↓

MovementIntentRejected(ALREADY_AT_TARGET)

        ↓

fluxo termina

Neste caso, a unidade pode já estar em uma condição onde o aggro deveria ser considerado alcançado.

---

# Fluxo desejado

Quando um `MovementIntent` for rejeitado com:

ALREADY_AT_TARGET

deve ser emitido um:

VerifyAggroReachedEvent

O novo fluxo será:

MovementIntent
        ↓
MovementIntentRejectedEvent
        ↓
(reason: ALREADY_AT_TARGET)
        ↓
VerifyAggroReachedEvent
        ↓
VerifyAggroReachedHandler

Futuramente, o `VerifyAggroReachedHandler` poderá emitir:

AggroReachedEvent

caso a unidade realmente tenha alcançado o objetivo.

---

# Responsabilidades

## MovementIntentRejectedHandler

O Handler responsável pelo `MovementIntentRejectedEvent` deve continuar tratando normalmente os demais motivos de rejeição.

Apenas o caso:

reason = "ALREADY_AT_TARGET"

deve possuir comportamento adicional.

Neste caso, ele deve:

- reconhecer que a movimentação não é necessária;
- emitir um `VerifyAggroReachedEvent`;
- não alterar estado do mundo;
- não emitir diretamente um `AggroReachedEvent`.

---

# VerifyAggroReachedEvent

O evento representa apenas:

"Uma tentativa de movimentação terminou ou foi considerada desnecessária. Verifique se o objetivo foi alcançado."

Ele não representa que o aggro foi alcançado.

O evento deve possuir dados suficientes para permitir a futura verificação.

Exemplo:

export type verifyAggroReachedEvent = {
    ["eventType"] : "VerifyAggroReachedEvent",
    ["delay"] : number,
    ["type"] : "EVENT",
    ["data"] : {
        ["unitId"] : string,
    }
}

Caso o sistema já possua contexto relacionado ao aggro da unidade, os dados devem seguir o padrão existente.

---

# VerifyAggroReachedHandler

O Handler deve seguir a arquitetura definida anteriormente.

Nesta task:

- criar a estrutura do Handler caso ainda não exista;
- receber `VerifyAggroReachedEvent`;
- preparar o fluxo para futuras implementações.

A lógica completa de verificação não faz parte desta task.

Futuramente este Handler será responsável por:

- verificar se a unidade realmente está próxima do alvo;
- emitir `AggroReachedEvent` caso tenha alcançado;
- criar um novo `MovementIntent` caso ainda seja necessário continuar a movimentação.

---

# Regras importantes

## Não emitir `AggroReachedEvent` diretamente

O fluxo abaixo não deve existir:

MovementIntentRejected(ALREADY_AT_TARGET)
        ↓
AggroReachedEvent

A confirmação do objetivo deve sempre passar pelo:

VerifyAggroReachedEvent

porque o sistema precisa separar:

- tentativa de movimentação;
- confirmação de objetivo alcançado.

---

## Não alterar outros motivos de rejeição

Apenas:

ALREADY_AT_TARGET

deve gerar o novo evento.

Outros motivos de rejeição devem continuar funcionando exatamente como antes.

Exemplos:

INVALID_TARGET

NO_PATH

BLOCKED

não devem alterar seu comportamento.

---

# Critérios de aceite

- [ ] `MovementIntentRejected(ALREADY_AT_TARGET)` gera `VerifyAggroReachedEvent`.
- [ ] Nenhum outro motivo de rejeição gera esse evento.
- [ ] `AggroReachedEvent` não é emitido diretamente pelo fluxo de rejeição.
- [ ] Existe um `VerifyAggroReachedHandler`.
- [ ] O Handler possui estrutura preparada para futuras implementações.
- [ ] Nenhuma lógica existente de movimentação foi alterada.
- [ ] O fluxo passa a suportar:

MovementIntentRejected(ALREADY_AT_TARGET)
        ↓
VerifyAggroReachedEvent
        ↓
VerifyAggroReachedHandler