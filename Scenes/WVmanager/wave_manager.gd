extends Node2D

const ANIM_FRAMES = {
	GameData.ENEMY_TYPE.ZIPPER : ["zipper1", "zipper2", "zipper3"],
	GameData.ENEMY_TYPE.BIO:  ["biomech_1", "biomech_2", "biomech_3", "biomech_4"],
	GameData.ENEMY_TYPE.BOMBER : ["bomber1", "bomber2", "bomber3"]
}

const ENEMY_SCENES = {
	GameData.ENEMY_TYPE.ZIPPER : preload("res://Scenes/EnemyBasics/enemy_zipper.tscn"),
	GameData.ENEMY_TYPE.BIO : preload("res://Scenes/EnemyBasics/enemy_bio.tscn"),
	GameData.ENEMY_TYPE.BOMBER : preload("res://Scenes/EnemyBasics/enemy_bomber.tscn")
	
}

const ENEMY_DATA = {
	GameData.ENEMY_TYPE.ZIPPER : {
		"speed" : 0.10, "gap" : 0.6, "min" : 6,"max" : 10
	},
	GameData.ENEMY_TYPE.BIO : {
		"speed" : 0.08, "gap" : 0.7, "min" : 6, "max" : 8
	},
	GameData.ENEMY_TYPE.BOMBER : {
		"speed" : 0.07, "gap" : 0.9, "min" : 4, "max" : 6
	}
}

@onready var paths: Node2D = $Paths
@onready var spawn_timer: Timer = $SpawnTimer

var paths_list : Array = []
var speed_factor : float = 1
var wave_counter : int = 0
var last_index : int = -1
var wave_gap : float = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paths_list = paths.get_children()
	print(len(paths_list))
	SpawnWave()

func CreateEnemy(speed: float, animName : String, enemyType : GameData.ENEMY_TYPE):
	var newEnemy = ENEMY_SCENES[enemyType].instantiate()
	newEnemy.Setup(speed, animName)
	return newEnemy

func UpdateSpeeds() -> void:
	#only will happen if wave counter is 11(last path)
	if wave_counter % len(paths_list) == 0 and wave_counter != 0:
		speed_factor *= 1.05
		wave_gap *= 0.80
		print("update_speeds(): _wave_count:%s _speed_factor:%s _wave_gap:%s" % [
			wave_counter, speed_factor, wave_gap])

func StartSpawnTimer() -> void:
	spawn_timer.wait_time = wave_gap
	spawn_timer.start()

func GetRandomPathIndex() -> int:
	var randomIndex = randi_range(0, len(paths_list) - 1)
	while randomIndex == last_index:
		randomIndex = randi_range(0, len(paths_list) - 1)
	last_index = randomIndex
	return randomIndex

func SpawnWave() -> void:
	var randomPath = paths_list[GetRandomPathIndex()]
	var en_type = GameData.ENEMY_TYPE.values().pick_random()
	var anim = ANIM_FRAMES[en_type].pick_random()
	var spawnData = ENEMY_DATA[en_type]
	
	print("\nspawn_wave()\n_last_path_index:", last_index)
	print("spawn_data:", spawnData)

	for num in range(spawnData.min, spawnData.max):
		randomPath.add_child(CreateEnemy(spawnData.speed * speed_factor,anim, en_type))
		await get_tree().create_timer(spawnData.gap).timeout
		
	print("Wave() -> wave_counter = %s" % wave_counter)
	print("Waiting time is: %s" % wave_gap)
	wave_counter += 1
	await get_tree().create_timer(wave_gap).timeout
	UpdateSpeeds()
	StartSpawnTimer()

func _on_spawn_timer_timeout() -> void:
	SpawnWave()
