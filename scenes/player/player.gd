extends Node2D

class_name PlayerScene

@onready var body := $CharacterBody2D

@export var body_position: Vector2:
	get:
		return body.global_position
