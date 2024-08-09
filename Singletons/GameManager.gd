extends Node

var levelScene : PackedScene = preload("res://Scenes/Level/level.tscn")
var mainScene : PackedScene = preload("res://Scenes/MainMenu/main_menu.tscn")
var tutorialScene : PackedScene = preload("res://Scenes/TutorialScene/tutorial.tscn")

const PLAYER_GROUP : String = "player"

func LoadMainScene() -> void:
	get_tree().change_scene_to_packed(mainScene)
	
func LoadLevelScene() -> void:
	get_tree().change_scene_to_packed(levelScene)

func LoadTutorialScene() -> void:
	get_tree().change_scene_to_packed(tutorialScene)
