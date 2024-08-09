extends PathFollow2D

@export var canShoot : bool = false
@export var aimAtPlayer : bool = false
@export var bulletScene : PackedScene
@export var bullet_speed : float
@export var bullet_damage : float
@export var bullet_direcion : Vector2
@export var bullet_waiting_time : float = 1.5
@export var time_variation : float = 0.05

@export var kill_me_score : int = 10
@export var damage_taken : int = 20

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var laser_timer: Timer = $LaserTimer
@onready var booms: Node2D = $Booms
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var laser_sound: AudioStreamPlayer2D = $LaserSound


var _playerRef : Player
var _enemySpeed : float = 30.0
var _animSprite : String
var _isDead : bool = false
var _powerUpDropRate : float = 0.8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_playerRef = get_tree().get_first_node_in_group(GameManager.PLAYER_GROUP)
	#there is a possibility to load and the player be already dead so we need to check it
	if !_playerRef:
		queue_free()
	animated_sprite_2d.play(_animSprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += _enemySpeed * delta
	
	if progress_ratio > 0.99:
		queue_free()
		

func UpdateBulletDirection() -> void:
	if (!aimAtPlayer or is_instance_valid(_playerRef) != true):
		return
	
	bullet_direcion = global_position.direction_to(_playerRef.global_position)

func StartShootingTimer() -> void:
	Utils.SetAndStartTimer(laser_timer, bullet_waiting_time, time_variation)

func MakeBoom() -> void:
	for boom in booms.get_children():
		ObjectMaker.create_boom_explosion(boom.global_position)

func DropPowerUp() -> void:
	var randomValue = randf_range(0.3,1.8)
	if randomValue < _powerUpDropRate:
		ObjectMaker.CreateRandomPowerUp(global_position)

func Die() -> void:
	if _isDead:
		return
	_isDead = true
	set_process(false)
	DropPowerUp()
	MakeBoom()
	ScoreManager.IncrementScore(kill_me_score)
	queue_free()

func SetupLaser() -> void:
	var newLaser = bulletScene.instantiate()
	UpdateBulletDirection()
	newLaser.Setup(global_position, bullet_direcion, bullet_speed, bullet_damage)
	get_tree().current_scene.add_child(newLaser)
	StartShootingTimer()
	SoundManager.play_laser_random(laser_sound)

func Setup(enemySpeed : float, animName : String) -> void:
	_enemySpeed = enemySpeed
	_animSprite = animName

func _on_laser_timer_timeout() -> void:
	SetupLaser()

#Here we will need the screen entered, to know if the enemy is already in the screen to shoot
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if canShoot:
		StartShootingTimer()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	set_process(false)
	queue_free()


func _on_collision_area_area_entered(area: Area2D) -> void:
	#TODO : Adjust to decrease the damage based on what collided with
	health_bar.TakeDamage(damage_taken)


func _on_health_bar_died() -> void:
	Die()
