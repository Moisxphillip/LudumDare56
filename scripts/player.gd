extends CharacterBody3D


const SPEED = 5.0
var bullet = preload("res://scenes/bullet.tscn")

func _physics_process(_delta: float) -> void:
    if Input.is_action_just_pressed("Shoot"):
        var shot = bullet.instantiate()
        var direct = global_position.direction_to(global_position+ray_query())
        shot.setup(Vector2(direct.x, direct.z).normalized(), 8.0)
        get_parent().add_child(shot)
        shot.global_position = global_position
        shot.global_position.y = direct.y
        pass
    ray_query()

    var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    animation(Vector2(direction.x, direction.z))
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:

        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()


var lastWasLeft: bool = false

func animation(direction: Vector2)->void:#change to left and right
    if direction == Vector2.ZERO:
        $Animation.play("Idle")
        return
        
    if $Animation.current_animation == "Idle":
            $Animation.play("Walk")
            if direction.x>=0:
                $Sprite.flip_h = false
            else:
                $Sprite.flip_h = true
                
    elif direction.x>0 and lastWasLeft:
        $Sprite.flip_h = false
        lastWasLeft = false
    elif direction.x<0 and !lastWasLeft:
        $Sprite.flip_h = true
        lastWasLeft = true


func ray_query() -> Vector3:
    var mousePos = get_viewport().get_mouse_position()
    mousePos.x = clamp(mousePos.x, 0, float(DisplayServer.window_get_size().x))
    mousePos.y = clamp(mousePos.y, 0, float(DisplayServer.window_get_size().y))
    mousePos/=Vector2(DisplayServer.window_get_size())

    var toScreen = (mousePos-Vector2(0.5, 0.5))*2

    var pos = toScreen*Vector2(11, 12)
    return Vector3(pos.x, 4.0, pos.y)

