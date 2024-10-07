extends RigidBody3D
class_name Enemy

@export var hitpoints: int = 1
@export var type: int = 1
@export var speed:float = 2

@onready var animation = $AnimatedSprite3D;

# Called when the node enters the scene tree for the first time.
func _ready():
    animation.play("walk")
    return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var pl = get_parent().get_node("Player")
    if pl == null:
        return

    # Run towards the player
    var player_position = pl.position
    var dir = position.direction_to(player_position).normalized()
    
    move_and_collide(dir*speed* delta)
    
    return

func hit():
    hitpoints -= 1
    if hitpoints <= 0:
        die()
    return

func die():
    UI.killed_enemy()
    GlobalData.curr_enemy_count -= 1
    
    if type == 1:
        UI.add_normal_shot(2)
    elif type == 2:
        UI.add_pierce_shot(2)
    elif type == 3:
        UI.add_bomb_shot(2)
        
    queue_free()
    
    return

# Take damage
func _on_area_3d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
    if area.name == "Bullet":
        hit()
    return
