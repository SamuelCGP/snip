class_name CardEffectData

enum Type {
	DAMAGE, GAIN_ELEMENTAL_ENERGY
}

enum EffectTriggerEvent {
	SUMMON, CHAIN, RETURN_TO_HAND, ATTACK, DESTROY, SCHEDULE
}

var source: CardNode

var type: Type
var typeParams: Dictionary

var targetFilters: Array[CardFilter] = []

var triggerEvent: EffectTriggerEvent
var triggerParams: Dictionary

var requirements: EffectRequirements

var cost := {
	will = 0,
	energy = 0
}

func hasCost() -> bool:
	if cost.will > 0:
		return true

	if cost.energy > 0:
		return true

	return false

static func deserialize(effectData: Dictionary) -> CardEffectData:
	var effect: CardEffectData = CardEffectData.new()
	
	effect.type = Type.get(effectData.type)
	effect.typeParams = effectData.params

	if effectData.has("target"):
		var targetData : Array = effectData.target
		var filters: Array[CardFilter] = CardFilter.deserialize(targetData)
		effect.targetFilters = filters

	effect.triggerEvent = EffectTriggerEvent.get(effectData.trigger.event)

	if effectData.trigger.has("params"):
		effect.triggerParams = effectData.trigger.params
	
	if effectData.has("cost"):
		if effectData.cost.has("energy"):
			effect.cost.energy = effectData.cost.energy
		if effectData.cost.has("will"):
			effect.cost.will = effectData.cost.will

	if effectData.has("requirements"):
		effect.requirements = EffectRequirements.deserialize(effectData.requirements)
	
	return effect
