extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Timer.wait_time = $Timer.wait_time + randf_range(-1.0,1.0)
    $Timer.start()
    pass # Replace with function body.


func _on_timer_timeout() -> void:
    if GlobalData.curr_enemy_count < GlobalData.max_enemy_count:
        spawn_enemy()
    $Timer.start()


var TICK = preload("res://scenes/tick.tscn")
var SPEED_TICK = preload("res://scenes/speedtick.tscn")
var SHELL_TICK = preload("res://scenes/shelltick.tscn")

func spawn_enemy():
    # Choose enemy to spawn
    var enemy = null
    var odds = randf_range(0.0, 1.0)
    if odds <= 0.6:
        enemy = TICK.instantiate()
    elif odds <= 0.75:
        enemy = SPEED_TICK.instantiate()
    else:
        enemy = SHELL_TICK.instantiate()

    get_parent().get_parent().add_child(enemy)
    enemy.global_position = global_position
    
    GlobalData.curr_enemy_count += 1
