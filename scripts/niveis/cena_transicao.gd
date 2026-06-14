class_name CenaTransicao extends CanvasLayer

var path_cena_alvo: String = ""

@export var animador: AnimationPlayer


func mudar_cena(cena_alvo: String) -> void:
	path_cena_alvo = cena_alvo
	animador.play('fade_in')
	
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'fade_out':
		get_tree().call_group('personagem', 'congelar', false)
		
	if anim_name == 'fade_in':
		# fazendo dessa forma por causa desse erro:
		# E 0:00:02:367   portal.gd:8 @ _on_body_entered(): Removing a CollisionObject node during a 
		# physics callback is not allowed and will cause undesired behavior. 
		# Remove with call_deferred() instead. Player tem fisica, 
		# get_tree().call_deferred("change_scene_to_file", _cena_alvo)
		# antes era assim
		get_tree().change_scene_to_file(path_cena_alvo)
		animador.play('fade_out')
