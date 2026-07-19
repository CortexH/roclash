local module = {}

module.reasons = {
    ["PT-BR"] = {
        ["SELF_DIED"] = "O guerreiro utilizado não está mais vivo!",
        ["TARGET_DIED"] = "O guerreiro ou estrutura alvo não está mais em batalha!",
        ["SELF_NOT_PLACED"] = "O guerreiro escolhido não está em batalha.",
        ["TARGET_NOT_PLACED"] = "O guerreiro ou estrutura alvo não está em batalha.",
        ["TARGET_NOT_ENEMY"] = "O guerreiro ou estrutura alvo não é seu inimigo."
    }
}

return module