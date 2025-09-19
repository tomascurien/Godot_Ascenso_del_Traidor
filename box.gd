extends StaticBody2D

@export var health: int = 1

func _ready():
	$Area2D.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	# Solo dañamos si el área es el ataque del jugador y está activa
	if area.name == "AttackArea" and area.monitoring:
		take_damage(1)

func take_damage(amount: int) -> void:
	health -= amount
	print("Caja dañada, vida restante: ", health)
	if health <= 0:
		queue_free()
