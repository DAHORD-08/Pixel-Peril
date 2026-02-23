extends CanvasLayer
signal start_game

@onready var settings_panel = $SettingsPanel
@onready var credits_panel = $CreditsPanel
@onready var main_menu = $MainMenu


func _ready():
	settings_panel.hide()
	credits_panel.hide()
	main_menu.hide()
	$Message.show()
	main_menu.show()


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over():
	show_message("GAME OVER")
	await $MessageTimer.timeout
	
	$Message.text = "DODGE THE ENEMIES !"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	show_main_menu()


func show_main_menu():
	main_menu.show()
	$StartButton.show()
	update_high_score_display()


func hide_main_menu():
	main_menu.hide()
	$StartButton.hide()


func update_score(score):
	$ScoreLabel.text = str(score)


func update_high_score_display():
	$MainMenu/HighScoreLabel.text = "BEST SCORE: " + str(GameData.high_score)


# Bouton Start
func _on_start_button_pressed():
	hide_main_menu()
	start_game.emit()


# Bouton Settings
func _on_settings_button_pressed():
	settings_panel.show()
	$SettingsPanel/MusicSlider.value = GameData.music_volume
	$SettingsPanel/SFXSlider.value = GameData.sfx_volume


# Bouton Credits
func _on_credits_button_pressed():
	credits_panel.show()


# Fermer Settings
func _on_close_settings_pressed():
	settings_panel.hide()


# Fermer Credits
func _on_close_credits_pressed():
	credits_panel.hide()


# Sliders de volume
func _on_music_slider_value_changed(value):
	GameData.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	GameData.save_game()


func _on_sfx_slider_value_changed(value):
	GameData.sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	GameData.save_game()


func _on_message_timer_timeout():
	$Message.hide()
