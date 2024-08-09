extends Area2D

const ROTATION_SPEED : float = 200.0
const SPEED : float = 40
const SCORE : int = 5

var _playerRef : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_playerRef = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Turn(delta)
	position += transform.x.normalized() * delta * SPEED
	
func GetAngleToPlayer() -> float:
	if is_instance_valid(_playerRef):
		return rad_to_deg((_playerRef.global_position - global_position).angle())
	else:
	#takes the playerGBPos - ourGBPos in angles, after that convert from radians to degrees
		return 0.0

func GetAngleToTurn(angleToPlayer : float) -> float:
	#Works like the % but for floats, taking the angleToPlayer - ourRotations pos + 180, %360) - 180
	return fmod((angleToPlayer - global_rotation_degrees + 180.0), 360.0) -180.0

#Missile explodes when colliding with a bullet(player)
func BlowUp() -> void:
	#getting the global position of the laser - it owns position when added to the area(parent)
	ObjectMaker.create_explosion(global_position, get_tree().current_scene)
	set_process(false)
	ScoreManager.IncrementScore(SCORE)
	queue_free()

func Turn(delta : float) -> void:
	#Just saving the values in variables
	var angleToPlayer = GetAngleToPlayer()
	var angleToTurn = GetAngleToTurn(angleToPlayer)
	
	#Here it prevents the ship to spin when the angle is higher than 180
	if abs(angleToTurn) < 180:
		rotation_degrees += sign(angleToTurn) * delta * ROTATION_SPEED
	else:
		rotation_degrees += sign(angleToTurn) * -1 * delta * ROTATION_SPEED



func _on_area_entered(area: Area2D) -> void:
	BlowUp()
