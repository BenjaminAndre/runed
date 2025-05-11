extends Node2D

@export var easing : Curve

var selected_card : Node
var card_origin : Vector2
var drop_point : Vector2 

var is_holding_card : bool

func _process(delta : float) -> void :
    if selected_card != null :
        selected_card.global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
        if event.is_pressed() and !is_holding_card:
            selected_card = _pickup_card()
            if selected_card != null :
                card_origin = selected_card.global_position
        if !event.is_pressed():
            _release_card()
        

func _pickup_card():
    var space_state = get_world_2d().direct_space_state
    var parameters = PhysicsPointQueryParameters2D.new()
    parameters.position = get_global_mouse_position()
    parameters.collide_with_areas = true
    parameters.collision_mask = 1
    var result = space_state.intersect_point(parameters)
    if !result.is_empty() :
        is_holding_card = true
        return result[0].collider.get_parent()

    
func _release_card():
    is_holding_card = false
    selected_card = null