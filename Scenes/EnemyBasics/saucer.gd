extends PathFollow2D

@onready var state_machine = $AnimationTree["parameters/playback"]
@onready var missile_scene = preload("res://Scenes/Lasers/homing_missile.tscn")
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var booms: Node2D = $Booms

const SPEED : float = 0.08
const SHOOT_PROGRESS : float = 0.02
const FIRE_OFFSET = [0.25, 0.5, 0.75]
const BOOM_DELAY : float = 0.15
const DAMAGE_TAKEN : int = 10
const SCORE : int = 125

var isShooting : bool = false
var shootsFired : int = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_ratio = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isShooting == false:
		progress_ratio += delta * SPEED
		TryShoot()
	
func UpdateShootsFired() -> void:
	shootsFired += 1
	if shootsFired >= len(FIRE_OFFSET):
		shootsFired = 0
	
func TryShoot() -> void:
	if abs(progress_ratio - FIRE_OFFSET[shootsFired]) < SHOOT_PROGRESS:
		state_machine.travel("shoot")
		UpdateShootsFired()

func SetShooting(v : bool) -> void:
	isShooting = v

func Shoot() -> void:
	var newMissile = missile_scene.instantiate()
	newMissile.global_position = global_position
	get_tree().current_scene.add_child(newMissile)

func Die() -> void:
	health_bar.hide()
	ScoreManager.IncrementScore(SCORE)
	queue_free()

func CreateBooms():
	for boom in booms.get_children():
		ObjectMaker.create_boom_explosion(boom.global_position)
		await get_tree().create_timer(BOOM_DELAY).timeout	

func _on_health_bar_died() -> void:
	health_bar.disconnect("died", _on_health_bar_died)
	state_machine.travel("death")

func _on_area_2d_area_entered(area: Area2D) -> void:
	health_bar.TakeDamage(DAMAGE_TAKEN)
