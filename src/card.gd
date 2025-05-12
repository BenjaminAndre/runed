extends Node2D

@onready var sprite_2d: Sprite2D = $StaticBody2D/Sprite2D
@export var model : Card

func _ready() -> void:
    sprite_2d.texture = model.sprite
