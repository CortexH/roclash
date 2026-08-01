local module = {}

export type CardAttackButtonClick = {
    delay : number,
    eventType : "CardAttackButtonClickedClient",
    data : {
        btnSelected : boolean,
        unitId : string
    }
}

return module