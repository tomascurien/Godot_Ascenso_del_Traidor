extends CharacterBody2D

const SPEED = 300
const JUMP_VELOCITY = -400
const GRAVITY = 1000
var inventory = []

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

func _ready():
	anim.animation_finished.connect(_on_anim_finished)
	attack_area.monitoring = false

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Salto
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
		print("Animación: JUMP")

	# Ataque
	if Input.is_action_just_pressed("move_attack"):
		anim.play("attack")
		attack_area.monitoring = true
		move_and_slide()
		return

	# Movimiento lateral
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED
		if is_on_floor() and anim.animation not in ["attack", "jump"]:
			anim.play("walk")

		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and anim.animation not in ["attack", "jump"]:
			anim.play("IDLE")


	move_and_slide()

func _on_anim_finished():
	print("Terminó animación: ", anim.animation)
	if anim.animation == "attack":
		attack_area.monitoring = false
	if anim.animation in ["attack", "jump"]:
		anim.play("IDLE")


func add_to_inventory(item_name):
	inventory.append(item_name)
	print(inventory)
