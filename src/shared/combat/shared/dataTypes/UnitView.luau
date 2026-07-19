local module = {}

local unitMovement = require(script.Parent.Parent.entity.UnitClientMovement)

export type unitView = {
	unitId : string,
	unitType : string,
	model : Model,
	
	metadata : {
		modelHeight : number
	},
	visual: {
		currentMovement : unitMovement.unitMovement | nil,
		muzzleAttachment : Attachment
	}
}

return module
