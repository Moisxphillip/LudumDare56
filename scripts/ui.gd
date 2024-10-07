extends Control


var time:float = 0.0
var lives:int = 3
var kills:int = 0

func start()->void:
    GlobalData.curr_enemy_count = 0
    $Lost.visible = false
    time = 0.0
    lives = 3
    $Lives/Quantity.text = str(lives)
    kills = 0
    $KillCount/Quantity.text = str(kills)
    $Shots/NormalShot/Quantity.text = "10"
    $Shots/PierceShot/Quantity.text = "3"
    $Shots/BombShot/Quantity.text = "1"
    $Shots/NormalShot/Active.visible = true
    $Shots/PierceShot/Active.visible = false
    $Shots/BombShot/Active.visible = false


func update_time()->void:
    var sec = int(time)%60
    $Time/Minutes.text = str(int(time)/60)
    $Time/Seconds.text = "0" + str(sec) if sec<=9 else str(sec)


func _process(delta: float) -> void:
    if $Lost.visible && Input.is_action_just_pressed("Esc"):
        get_tree().change_scene_to_file("res://scenes/menu.tscn")
    time+=delta
    if lives != 0:
        update_time()
    
    if Input.is_action_just_pressed("Normal"):
        $Shots/NormalShot/Active.visible = true
        $Shots/PierceShot/Active.visible = false
        $Shots/BombShot/Active.visible = false
        pass
    
    elif Input.is_action_just_pressed("Pierce"):
        $Shots/NormalShot/Active.visible = false
        $Shots/PierceShot/Active.visible = true
        $Shots/BombShot/Active.visible = false
        pass
    
    elif Input.is_action_just_pressed("Bomb"):
        $Shots/NormalShot/Active.visible = false
        $Shots/PierceShot/Active.visible = false
        $Shots/BombShot/Active.visible = true
        pass
    
    
func killed_enemy()->void:
    kills+=1
    $KillCount/Quantity.text = str(kills)
  

func lose_live()->void:
    if lives == 0:
        return
    lives-=1
    $Lives/Quantity.text = str(lives)
    if lives == 0:
        $Lost.visible = true

    
func shoot_normal()->bool:
    var qty = int($Shots/NormalShot/Quantity.text)
    if qty < 1:
        return false
    else:
        $Shots/NormalShot/Quantity.text = str(qty-1)
    return true
    
            
func shoot_pierce()->bool:
    var qty = int($Shots/PierceShot/Quantity.text)
    if qty < 1:
        return false
    else:
        $Shots/PierceShot/Quantity.text = str(qty-1)
    return true
    
    
func shoot_bomb()->bool:
    var qty = int($Shots/BombShot/Quantity.text)
    if qty < 1:
        return false
    else:
        $Shots/BombShot/Quantity.text = str(qty-1)
    return true


func add_normal_shot(qty:int)->void:
    $Shots/NormalShot/Quantity.text = str(int($Shots/NormalShot/Quantity.text)+qty)


func add_pierce_shot(qty:int)->void:
    $Shots/PierceShot/Quantity.text = str(int($Shots/PierceShot/Quantity.text)+qty)
    
    
func add_bomb_shot(qty:int)->void:
    $Shots/BombShot/Quantity.text = str(int($Shots/BombShot/Quantity.text)+qty)


func _on_return_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/menu.tscn")
