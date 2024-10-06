extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

const ENEMY_1 = preload("res://scenes/enemy.tscn")
const ENEMY_2 = preload("res://scenes/enemy.tscn")

@export var enemy_odds = 0.1
@export var spawn_radius_modifier = 0.01 # Increase/Decrease spawn radius

func spawn_enemy():
    # Choose a random spawn point outside the window
    var width = get_viewport().size.x
    var height = get_viewport().size.y
    var safe_spawn_radius = sqrt(width * width + height * height) * spawn_radius_modifier
    var camera_position = get_viewport().get_camera_3d().global_position
    camera_position.y = 0
    var spawn_point = camera_position + Vector3(safe_spawn_radius, 0, safe_spawn_radius).rotated(Vector3(0, 1, 0), randf_range(0, 2 * PI))

    # Choose enemy to spawn
    var enemy = 0
    if randf_range(0, 1) <= enemy_odds:
        enemy = ENEMY_1.instantiate()
    else:
        enemy = ENEMY_2.instantiate()

    add_child(enemy)
    enemy.global_position = spawn_point

    return

# Spawn new enemies
func _on_enemy_spawn_timer_timeout():
    spawn_enemy()
    return
