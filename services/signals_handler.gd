extends Node

signal player_hit(player: PlayerScene, damage: DamageModel)
signal player_death(player: PlayerScene)
signal wall_hit(wall)

signal sentence_typed(sentence: Sentence)
signal key_pressed(key: InputEventKey)
