class_name CardManager
extends Node3D

var mouse_position : Vector3
var grabbed_card : Card

var alpha = 0.25

func _enter_tree() -> void:
    Global.card_manager = self

func _physics_process(delta: float) -> void:
    var collision = _check_collision(4) 
    if !collision.is_empty() :
        mouse_position = collision.position
    if grabbed_card != null :
        grabbed_card.global_position = alpha * (mouse_position + Vector3.UP * 0.05) + (1-alpha) * grabbed_card.global_position

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton :
        if !event.pressed:
            if grabbed_card == null : return
            var collision = _check_collision(8)
            if !collision.is_empty():
                var other_card = collision.collider.get_parent() as Card
                grabbed_card.get_parent().remove_child(grabbed_card)
                other_card.stacking_anchor.add_child(grabbed_card)
                grabbed_card.position = Vector3.ZERO
            else :
                var gp = grabbed_card.global_position
                grabbed_card.get_parent().remove_child(grabbed_card)
                add_child(grabbed_card)
                grabbed_card.global_position = gp
            grabbed_card.process_mode = Node.PROCESS_MODE_INHERIT
            grabbed_card = null
        else :
            var collision = _check_collision(2)
            if !collision.is_empty() :
                grabbed_card = collision.collider.get_parent()
                grabbed_card.process_mode = Node.PROCESS_MODE_DISABLED
            

func _check_collision(mask : int, exception : Array = []) -> Dictionary :
    var camera = get_viewport().get_camera_3d()
    var pos = get_viewport().get_mouse_position()
    var direction = camera.project_ray_normal(pos)
    var start = camera.global_position
    var end = camera.global_position + direction * 10
    var query = PhysicsRayQueryParameters3D.create(start, end, mask)
    query.collide_with_areas = true
    return get_world_3d().direct_space_state.intersect_ray(query)    