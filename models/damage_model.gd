class_name DamageModel

const PHYSICAL:= 1
const MAGICAL:= 2
const PURE:= 4

var _damage := 1
var _damage_type := PHYSICAL

var damage: int:
	get:
		return _damage
	set(value):
		if ! value:
			value = 1
		_damage = round(value)
		
var damage_type:int:
	get:
		return _damage_type
	set(value):
		if value & (PHYSICAL | MAGICAL| PURE):
			_damage_type = value
		else:
			_damage_type = PHYSICAL
			
func _init(damage:int, damage_type:int)->void:
	set('damage', damage)
	set('damage_type', damage_type)
	
