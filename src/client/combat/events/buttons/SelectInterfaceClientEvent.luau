local module = {}

export type SelectUnitButtonClicked = {
    delay : number,
    eventType : "SelectUnitButtonClickedClient",
    btnSelected : boolean
}

return module