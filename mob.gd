extends RigidBody2D


func _ready():
	# Ajouter au groupe "mobs" pour pouvoir les supprimer facilement
	add_to_group("mobs")
	
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
