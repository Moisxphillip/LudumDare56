extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Music.play()
    UI.visible = true
    UI.start()


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
    #
    ## Finish if player is dead
    #if get_node("Player") == null:
        #queue_free()
    #pass

var TICK = preload("res://scenes/tick.tscn")
var SPEED_TICK = preload("res://scenes/speedtick.tscn")
var SHELL_TICK = preload("res://scenes/shelltick.tscn")

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
    var odds = randf_range(0, 1)
    if odds <= 0.45:
        enemy = TICK.instantiate()
    elif odds <= 0.7:
        enemy = SPEED_TICK.instantiate()
    else:
        enemy = SHELL_TICK.instantiate()

    add_child(enemy)
    enemy.global_position = spawn_point
    
    GlobalData.curr_enemy_count += 1

    return

# Spawn new enemies
func _on_enemy_spawn_timer_timeout():
    #if GlobalData.curr_enemy_count < GlobalData.max_enemy_count:
        #spawn_enemy()
    return
