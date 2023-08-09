extends Node

signal damageEffect(source: CardNode, targetsData: Array[CardData], amount: int)
signal gainElementalEnergy(player: Player, energyType: CardData.Archetype, amount: int)