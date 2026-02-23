extends Node

@export var mob_scene: PackedScene
var score


func _ready():
	DisplayServer.screen_set_keep_on(true)
	# Appliquer les volumes au démarrage
	apply_audio_settings()


func apply_audio_settings():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(GameData.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(GameData.sfx_volume))


func game_over():
	$Music.stop()
	$GameOverSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	# Vérifier et sauvegarder le record
	var is_new_record = GameData.update_high_score(score)
	
	if is_new_record:
		$HUD.show_message("NEW RECORD: " + str(score) + " !")
		await get_tree().create_timer(2.0).timeout
	
	$HUD.show_game_over()


func new_game():
	$Music.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("TAP / CLICK ON SCREEN TO MOVE !")
	
	# Supprimer tous les mobs restants
	get_tree().call_group("mobs", "queue_free")


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
