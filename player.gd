extends Node2D

@onready var body := $CharacterBody2D

@export var body_position: Vector2:
	get:
		return body.global_position
