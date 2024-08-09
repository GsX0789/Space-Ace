extends Node2D

func _ready() -> void:
	ScoreManager.LoadHighScore()

func _on_play_button_pressed() -> void:
	GameManager.LoadLevelScene()

func _on_exit_button_pressed() -> void:
	ScoreManager.SaveHighScore()
	get_tree().quit()
	
func _on_tutorial_btt_pressed() -> void:
	GameManager.LoadTutorialScene()
