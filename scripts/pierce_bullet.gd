extends Bullet

var pierceCounter: int = 4


    
func action() -> void:
    if pierceCounter == 0:
        queue_free()
    pierceCounter-=1
