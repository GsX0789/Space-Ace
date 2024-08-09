extends Area2D

var _speed := 200 as float
var _direction : Vector2 = Vector2.UP
var _damage : float = 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#moving the bullet based on the direction
	global_position += _direction * _speed * delta


func Setup(pos : Vector2, newDir : Vector2, speed: float, damage : float) -> void:
	_direction = newDir
	_speed = speed
	_damage = damage
	global_position = pos
	

func BlowUp(area: Node2D) -> void:
	#getting the global position of the laser - it owns position when added to the area(parent)
	if(!area.is_in_group(GameData.HOMING_MISSILE_GROUP)):
		var netPosition = global_position - area.global_position
		ObjectMaker.create_explosion(netPosition, area)
	set_process(false)
	queue_free()

func GetLaserDamage() -> int:
	return _damage

func _on_area_entered(area: Area2D) -> void:
	BlowUp(area)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	hide()
	queue_free()
