class_name Portal extends Area2D

@export var _cena_alvo: String = ""


func _on_body_entered(body: Node2D) -> void:
	if body is PersonagemBase:
		# fazendo dessa forma por causa desse erro:
		# E 0:00:02:367   portal.gd:8 @ _on_body_entered(): Removing a CollisionObject node during a 
		# physics callback is not allowed and will cause undesired behavior. 
		# Remove with call_deferred() instead. Player tem fisica, 
		get_tree().call_deferred("change_scene_to_file", _cena_alvo)
		# antes era assim
		# get_tree().change_scene_to_file(_cena_alvo)
