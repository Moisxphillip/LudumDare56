extends Bullet

func _ready() -> void:
    $Animation.play("Ready")
    

func action() -> void:
    if !$Animation.is_playing():
        $Animation.play("Blow")
