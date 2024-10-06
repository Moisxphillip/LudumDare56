extends RigidBody3D

var hitpoints: float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
    return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # Run towards the player
    var player_position = get_parent().get_node("Player").position
    var dir = position.direction_to(player_position)
    
    move_and_collide(dir * delta)
    
    pass

func hit(damage: float):
    hitpoints -= damage
    if hitpoints <= 0:
        die()
    return

func die():
    queue_free()
    return

# Take damage
func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
    if area.name == "Bullet":
        hit(33.5)
        print("HP: ", hitpoints)
    return
