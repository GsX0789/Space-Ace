extends Node

#A dictionary key
enum SCENE_KEY { EXPLOSION, BOOM }

#Getting the explosion scene
const SIMPLE_SCENES = {
	SCENE_KEY.EXPLOSION: preload("res://Scenes/Explosion/explosion.tscn"),
	SCENE_KEY.BOOM : preload("res://Scenes/Explosion/boom.tscn")
}

const POWERUP_SCENE : PackedScene = preload("res://Scenes/PowerUp/power_up.tscn")
	
func add_child_deferred(child_to_add, parent : Node2D) -> void:
	parent.add_child(child_to_add)
	
func call_add_child(child_to_add, parent : Node2D) -> void:
	if(is_instance_valid(parent)):
		call_deferred("add_child_deferred", child_to_add, parent)

#creating the new explosion 
func create_simple_scene(start_pos: Vector2, key: SCENE_KEY, parent : Node2D) -> void:
	var new_exp = SIMPLE_SCENES[key].instantiate()
	new_exp.global_position = start_pos
	call_add_child(new_exp, parent)

func create_explosion(start_pos: Vector2, parent : Node2D) -> void:
	create_simple_scene(start_pos, SCENE_KEY.EXPLOSION, parent)

func GetRandomPowerUp():
	return GameData.POWER_UPS.keys().pick_random()

func CreatePowerUp(start_pos: Vector2, pu_type: GameData.POWERUP_TYPE):
	var pu = POWERUP_SCENE.instantiate()
	pu.global_position = start_pos
	pu.SetPowerUpType(pu_type)
	call_add_child(pu, get_tree().current_scene)

func CreateRandomPowerUp(start_pos : Vector2) -> void:
	CreatePowerUp(start_pos, GetRandomPowerUp())

func create_boom_explosion(start_pos : Vector2) -> void:
	#an important explanation, when we use get_tree().root it means to get everything that is running in that root
	# however when we use .currentScene, we just want to take everyNode inside that specific scene!
	create_simple_scene(start_pos, SCENE_KEY.BOOM, get_tree().current_scene)
