class_name EffectRequirements

var cardsExist: Array[CardFilter]
		

static func deserialize(requirementsData: Dictionary) -> EffectRequirements:
	var requirements := EffectRequirements.new()

	if requirementsData.cardsExist:
		requirements.cardsExist = CardFilter.deserialize(requirementsData.cardsExist)

	return requirements