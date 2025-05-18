extends Node3D

const alpha = 0.25

@export var rotation_to_mouse : Vector3
@export var detection_zone : CollisionShape3D

func _process(delta: float) -> void:
    var target_rotation = Vector3.ZERO
    if Global.card_manager.grabbed_card == null:
        target_rotation = _orientation_mouseover()
    elif Global.card_manager.grabbed_card == get_parent() :
        target_rotation = _orientation_mouse_velocity()
    rotation_degrees = target_rotation * alpha + rotation_degrees * (1 - alpha)
    
func _orientation_mouseover() -> Vector3 :
    var distance_to_mouse = global_position - Global.card_manager.mouse_position
    if distance_to_mouse.length() > 1 :
        return Vector3.ZERO
    var percent_x = clamp(distance_to_mouse.x / detection_zone.shape.size.x, -1, 1)
    var max_z_left = 1 - abs(percent_x)
    var percent_z = clamp(distance_to_mouse.z / detection_zone.shape.size.z, -max_z_left, max_z_left)
    return Vector3(-percent_z, 0, percent_x)  * rotation_to_mouse   

func _orientation_mouse_velocity():
    var v = Input.get_last_mouse_velocity() / 100
    return Vector3(v.y, 0, -v.x) 