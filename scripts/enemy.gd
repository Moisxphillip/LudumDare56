extends RigidBody3D

var hitpoints: float = 100

@onready var animation = $AnimatedSprite3D;

# Called when the node enters the scene tree for the first time.
func _ready():
    animation.play("walk")
    return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if get_parent().get_node("Player") == null:
        return

    # Run towards the player
    var player_position = get_parent().get_node("Player").position
    var dir = position.direction_to(player_position)
    
    move_and_collide(dir * delta)
    
    return

func hit(damage: float):
    hitpoints -= damage
    if hitpoints <= 0:
        die()
    return

func die():
    GlobalData.curr_enemy_count -= 1
    queue_free()
    return

# Take damage
func _on_area_3d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
    if area.name == "Bullet":
        hit(33.5)
        print("ENEMY HP: ", hitpoints)
    return
