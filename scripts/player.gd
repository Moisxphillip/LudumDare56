extends CharacterBody3D


const SPEED = 8.0
var bullet = preload("res://scenes/bullet.tscn")
var pierce = preload("res://scenes/pierce_bullet.tscn")
var bomb = preload("res://scenes/bomb_bullet.tscn")

#var hitpoints = 3
var can_shoot = true
var shoot_interval = 0.3

var shootMode = 1

func _physics_process(_delta: float) -> void:
    if UI.lives <= 0:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
        return
        
    if Input.is_action_just_pressed("Normal"):
        shootMode = 1
        pass
    elif Input.is_action_just_pressed("Pierce"):
        shootMode = 2
        pass
    elif Input.is_action_just_pressed("Bomb"):
        shootMode = 3
        pass
    
    if Input.is_action_pressed("Shoot") and can_shoot:
        var success:bool = false
        var shot = null
        var speed  = 7.0
        if shootMode == 1:
            success = UI.shoot_normal()
            if success:
                shot = bullet.instantiate()
        elif shootMode == 2:
            success = UI.shoot_pierce()
            if success:
                shot = pierce.instantiate()
                speed = 9.0
        elif shootMode == 3:
            success = UI.shoot_bomb()
            if success:
                shot = bomb.instantiate()
                speed = 4.0
        if shot == null:
            return
        $Pew.play(0.0)
        #var shot = bullet.instantiate()
        var direct = global_position.direction_to(global_position+ray_query())
        shot.setup(Vector2(direct.x, direct.z).normalized(), speed)
        get_parent().add_child(shot)
        shot.global_position = global_position
        shot.global_position.y = direct.y
        can_shoot = false
        $ShootTimer.start(shoot_interval)
        
    #ray_query()

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
    if UI.lives <= 0:
        return
        
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


var played:bool = false

func _on_area_3d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
    if area.name == "EnemyArea":
        #hit(self_damage)
        UI.lose_live()
        if UI.lives == 0:
            $Sprite.visible = false
            if !played:
                $Dead.play()
                played = true



func _on_shoot_timer_timeout():
    can_shoot = true
    pass # Replace with function body.
