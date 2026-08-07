local module = {}

export type CardMoveButtonClick = {
    delay : number,
    eventType : "CardMoveButtonClickedClient",
    data : {
        btnSelected : boolean,
        unitId : string
    }
}

return module
