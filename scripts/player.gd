extends CharacterBody3D


const SPEED = 20.0
var bullet = preload("res://scenes/bullet.tscn")
var self_damage = 10.0
var hitpoints = 100.0
var can_shoot = true
var shoot_interval = 0.3

func _physics_process(_delta: float) -> void:
    if Input.is_action_pressed("Shoot") and can_shoot:
        var shot = bullet.instantiate()
        var direct = global_position.direction_to(global_position+ray_query())
        shot.setup(Vector2(direct.x, direct.z).normalized(), 8.0)
        get_parent().add_child(shot)
        shot.global_position = global_position
        shot.global_position.y = direct.y
        can_shoot = false
        $ShootTimer.start(shoot_interval)
        
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
            #if direction.x>=0:
                #$Sprite.flip_h = false
            #else:
                #$Sprite.flip_h = true
                
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

func die():
    queue_free()
    return

func hit(damage):
    hitpoints -= damage
    if hitpoints <= 0.0:
        die()
    return

func _on_area_3d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
    if area.name == "EnemyArea":
        hit(self_damage)
        print("PLAYER HP: ", hitpoints)
    return


func _on_shoot_timer_timeout():
    can_shoot = true
    pass # Replace with function body.
