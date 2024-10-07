extends Bullet

func _ready() -> void:
    $Animation.play("Ready")
    

func action() -> void:
    speed = 0.0
    if !$Animation.is_playing():
        $Animation.play("Blow")
