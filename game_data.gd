extends Node

# Paramètres
var music_volume = 0.8
var sfx_volume = 0.8

# Records
var high_score = 0

# Fichier de sauvegarde
const SAVE_FILE = "user://game_data.save"


func _ready():
	load_game()


func save_game():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		var data = {
			"music_volume": music_volume,
			"sfx_volume": sfx_volume,
			"high_score": high_score
		}
		file.store_var(data)
		file.close()


func load_game():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			var data = file.get_var()
			music_volume = data.get("music_volume", 0.8)
			sfx_volume = data.get("sfx_volume", 0.8)
			high_score = data.get("high_score", 0)
			file.close()


func update_high_score(score):
	if score > high_score:
		high_score = score
		save_game()
		return true
	return false
