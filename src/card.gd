class_name Card
extends Node3D

@export var stacking_anchor : Marker3D
@export var magnetic_zone : Area3D

var alpha = 0.25

func _process(delta: float) -> void:
    if get_parent() is Marker3D && !Global.card_manager.grabbed_card == self:
        position = (1-alpha) * position