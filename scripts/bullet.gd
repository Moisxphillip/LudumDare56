extends Area3D

var direction: Vector2 = Vector2.ZERO
var speed: float = 6.0

func _ready() -> void:
    pass # Replace with function body.


func setup(dir: Vector2, spd: float):
    direction = dir
    speed = spd
    
    
func _physics_process(delta: float) -> void:
    var dir = direction*speed*delta
    global_position.x+=dir.x
    global_position.z+=dir.y


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
    #print("outside screen")
    queue_free()


func _on_body_entered(_body: Node3D) -> void:
    #print("body entered")
    #print(_body.name)
    queue_free()
