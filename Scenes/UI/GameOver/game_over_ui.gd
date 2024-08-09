extends Control

@onready var gm_timer: Timer = $GMTimer
@onready var score_info: Label = $ColorRect/MC/ScoreInfo
@onready var info_1: Label = $ColorRect/MC/Info1


var can_shoot : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_1.hide()
	hide()
	SignalManager.on_player_death.connect(OnPlayerDeath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (can_shoot and Input.is_action_just_pressed("Shoot")):
		GameManager.LoadMainScene()
	
func OnPlayerDeath() -> void:
	show()
	gm_timer.start()
	score_info.text = "Score: %s - (Best: %s)" % [
		ScoreManager.GetScore(), 
		ScoreManager.GetHighScore()
	]

func _on_gm_timer_timeout() -> void:
	can_shoot = true
	info_1.show()
