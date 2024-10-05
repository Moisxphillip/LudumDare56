extends CharacterBody3D


const SPEED = 5.0
var bullet = preload("res://scenes/bullet.tscn")

func _physics_process(_delta: float) -> void:
    if Input.is_action_just_pressed("Shoot"):
        var shot = bullet.instantiate()
        print(ray_query())
        var direct = global_position.direction_to(ray_query())
        shot.setup(Vector2(direct.x, direct.z), 8.0)
        get_parent().add_child(shot)
        shot.global_position = global_position
        

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


var lastWasDown: bool = false

func animation(direction: Vector2)->void:
    if direction == Vector2.ZERO:
        $Animation.stop()
        $Sprite.frame = 0
        return
        
    if !$Animation.is_playing():
            if direction.y>=0:
                $Animation.play("Down")
            else:
                $Animation.play("Up")
    elif direction.y>=0 and lastWasDown:
        $Animation.play("Down")
        lastWasDown = false
    elif direction.y<0 and !lastWasDown:
        $Animation.play("Up")
        lastWasDown = true
    pass

func ray_query() -> Vector3:
    var mousePos = get_viewport().get_mouse_position()
    print(mousePos)#todo find better method
    var rayOrigin = $Camera3D.project_ray_origin(mousePos)
    var rayDir = rayOrigin+$Camera3D.project_ray_normal(mousePos)*500
    var rayQuery = PhysicsRayQueryParameters3D.create(rayOrigin, rayDir)
    rayQuery.collide_with_bodies = true
    var spaceState = get_world_3d().direct_space_state
    var rayResult = spaceState.intersect_ray(rayQuery)
    if(!rayResult.is_empty()):
        return rayResult.position
    return Vector3.ZERO
