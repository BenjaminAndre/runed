extends Node2D

@export var easing : Curve
@onready var drop_zone: CollisionShape2D = $"Drop Zone/CollisionShape2D"

var z_offset : int = 0

var selected_card : Node
var offcenter_click : Vector2
var card_origin : Vector2
var drop_point : Vector2 

var is_holding_card : bool

func _process(delta : float) -> void :
    if selected_card != null :
        selected_card.global_position = get_global_mouse_position() + offcenter_click


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
        if event.is_pressed() and !is_holding_card:
            selected_card = _pickup_card()
            if selected_card != null :
                card_origin = selected_card.global_position
        if !event.is_pressed():
            _release_card()
        
func _custom_order(a,b):
    return a.collider.get_parent().z_index > b.collider.get_parent().z_index

func _pickup_card():
    var space_state = get_world_2d().direct_space_state
    var parameters = PhysicsPointQueryParameters2D.new()
    parameters.position = get_global_mouse_position()
    parameters.collide_with_areas = true
    parameters.collision_mask = 1
    var result = space_state.intersect_point(parameters)
    if !result.is_empty() :
        is_holding_card = true
        result.sort_custom(_custom_order)
        var card = result[0].collider.get_parent() as Node
        offcenter_click = card.global_position - parameters.position
        remove_child(card)
        z_offset += 1
        card.z_index = z_offset
        add_child(card)
        return card 

    
func _release_card():
    if selected_card == null :
        return
    print("Card " + selected_card.name + " was moved from " + str(card_origin) + " to " + str(selected_card.global_position))
    
    var rect = drop_zone.shape.get_rect()
    rect.position += drop_zone.global_position
    rect.position += Vector2(40,60) #card hald size
    selected_card.global_position.x = clampi(selected_card.global_position.x, rect.position.x, rect.end.x)
    selected_card.global_position.y = clampi(selected_card.global_position.y, rect.position.y, rect.end.y)
    var resolution = 25
    selected_card.global_position.x = roundi(selected_card.global_position.x / resolution) * resolution
    selected_card.global_position.y = roundi(selected_card.global_position.y / resolution) * resolution
    
    is_holding_card = false
    selected_card = null
