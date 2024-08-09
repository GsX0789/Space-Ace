extends Node

const SAVE_PATH : String = "user://b34na2d.hsc"

var playerScore : int = 0
var playerHighScore : int = 0

func IncrementScore(score: int) -> void:
	playerScore += score
	if(playerScore > playerHighScore):
		playerHighScore = playerScore
	SignalManager.on_player_scored.emit(playerScore)

func ResetScore() -> void:
	playerScore = 0
	
func GetScore() -> int:
	return playerScore
	
func GetHighScore() -> int:
	return playerHighScore
	
func LoadHighScore() -> void:
	if !FileAccess.file_exists(SAVE_PATH):
		return #We do not have a file to load
		
	var loadFile = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var jsonHighScore = loadFile.get_var()
	
	playerHighScore = JSON.parse_string(jsonHighScore)
	print("HighScore Loaded: %s" % playerHighScore)
	
func SaveHighScore() -> void:
	var saveFile = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var json_highScore = JSON.stringify(playerHighScore)
	saveFile.store_var(json_highScore)
	print("Saving game")
	pass
