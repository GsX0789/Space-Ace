extends Area2D

class_name Player

#Two reference variables, playerSprite and animationPlayer so we can alternate the animations
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var playerLaser : PackedScene
@onready var shield: Area2D = $Shield

#Global fields to help us deal with the ship movement and boundaries
var shipSpeed : float = 200
var upperLeft : Vector2
var lowerRight : Vector2
var viewPortBase : Rect2
var spawnPoint : Vector2
var laserSpeed : float = 300
var laserDamage : float = 20
var _bonusHealth : int = 35

#Margin from the corners of the screen
const MARGIN : float = 32.0

func _ready() -> void:
	SetPlayerBounds()
	SetPlayerSpawnPoint()
	SignalManager.on_powerUp_hit.connect(OnPowerUpCollected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var playerInput = GetInput() * delta * shipSpeed
	global_position += playerInput
	global_position = global_position.clamp(lowerRight, upperLeft)
	if Input.is_action_just_pressed("Shoot"):
		ShootLaser()

func OnPowerUpCollected(powerUpType : GameData.POWERUP_TYPE) -> void:
	if powerUpType == GameData.POWERUP_TYPE.SHIELD:
		shield.EnableShield()
	elif powerUpType == GameData.POWERUP_TYPE.HEALTH:
		SignalManager.on_player_life_bonus.emit(_bonusHealth)

func SetPlayerBounds() -> void:
	viewPortBase = get_viewport_rect()
	
	#setting up the limits for the ship, so it CANNOT get of the scene
	upperLeft = Vector2(
		viewPortBase.size.x - MARGIN,
		viewPortBase.size.y - MARGIN
	)
	
	lowerRight = Vector2(MARGIN,MARGIN)

func SetPlayerSpawnPoint() -> void:
	spawnPoint = Vector2(409,578)
	global_position = spawnPoint

func GetInput() -> Vector2:
	
	#The left axis is always the negative one, -1 , 1
	var input = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	
	animation_player.play("flying")
	
	if input.x > 0:
		player_sprite.flip_h = true
		animation_player.play("turning")
	if input.x < 0:
		player_sprite.flip_h = false
		animation_player.play("turning")
	
	#Here we need to normalize the input, so the speed does not increase in diagonals
	return input.normalized()

func ShootLaser() -> void:
	var newLaser = playerLaser.instantiate()
	#pos : Vector2, newDir : Vector2, speed: float, damage : float
	newLaser.Setup(
		global_position, 
		Vector2.UP, 
		laserSpeed, 
		laserDamage
		)
	get_tree().current_scene.add_child(newLaser)


func _on_area_entered(area: Area2D) -> void:
	print("Something hit us %s, %s ", [area, area.get_groups()])
	if(area.is_in_group(GameData.ENEMY_SHIP)):
		SignalManager.on_player_hit.emit(GameData.collisionDamage)
	elif(area.is_in_group(GameData.ENEMY_BULLET)):
		SignalManager.on_player_hit.emit(area.GetLaserDamage())
	elif(area.is_in_group(GameData.HOMING_MISSILE_GROUP)):
		SignalManager.on_player_hit.emit(GameData.missileDamage)
	elif(area.is_in_group(GameData.SAURCER_GROUP)):
		SignalManager.on_player_hit.emit(GameData.collisionDamage)
