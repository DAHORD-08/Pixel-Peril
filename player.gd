extends Area2D
signal hit

@export var speed = 400
var screen_size
var touch_position = Vector2.ZERO
var is_touching = false


func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _input(event):
	# Gestion du tactile
	if event is InputEventScreenTouch:
		if event.pressed:
			is_touching = true
			touch_position = event.position
		else:
			is_touching = false
	elif event is InputEventScreenDrag:
		is_touching = true
		touch_position = event.position


func _process(delta):
	var velocity = Vector2.ZERO
	
	# Contrôles tactiles
	if is_touching:
		var direction = (touch_position - position).normalized()
		var distance = position.distance_to(touch_position)
		
		# Se déplacer vers la position du doigt si elle est assez loin
		if distance > 20:  # Zone morte de 20 pixels
			velocity = direction * speed
	
	# Garder aussi les contrôles clavier pour tester sur PC
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"


func _on_body_entered(_body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.set_deferred("disabled", false)
	is_touching = false
