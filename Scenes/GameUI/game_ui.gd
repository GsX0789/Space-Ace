extends Control

@onready var health_bar: TextureProgressBar = $HeadUp/MC/HBPlayerINF/HealthBar
@onready var score_label: Label = $HeadUp/MC/HBPlayerINF/ScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_player_hit.connect(OnPlayerHit)
	SignalManager.on_player_life_bonus.connect(OnLifeBonus)
	SignalManager.on_player_scored.connect(OnPlayerScored)

func OnLifeBonus(bonusAmount : int):
	health_bar.IncrementBar(bonusAmount)

func OnPlayerHit(damage : int) -> void:
	health_bar.TakeDamage(damage)

func OnPlayerScored(score : int) -> void:
	score_label.text = "%06d" % score

func _on_health_bar_died() -> void:
	ScoreManager.SaveHighScore()
	SignalManager.on_player_death.emit()
