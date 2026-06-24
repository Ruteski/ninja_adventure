class_name CenaTransicao extends CanvasLayer

var path_cena_alvo: String = ""
var titulo_cena_alvo: String = "Vilarejo"

@export var animador: AnimationPlayer
@export var titulo: Label
@export var animador_titulo: AnimationPlayer


func mudar_cena(cena_alvo: String, _titulo_cena: String) -> void:
	path_cena_alvo = cena_alvo
	titulo_cena_alvo = _titulo_cena
	animador.play('fade_in')
	
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'fade_out':
		get_tree().call_group('personagem', 'congelar', false)
		titulo.text = titulo_cena_alvo
		animador_titulo.play('exibir_titulo')
		
	if anim_name == 'fade_in':
		# fazendo dessa forma por causa desse erro:
		# E 0:00:02:367   portal.gd:8 @ _on_body_entered(): Removing a CollisionObject node during a 
		# physics callback is not allowed and will cause undesired behavior. 
		# Remove with call_deferred() instead. Player tem fisica, 
		# get_tree().call_deferred("change_scene_to_file", _cena_alvo)
		
		# antes era assim
		get_tree().change_scene_to_file(path_cena_alvo)
		animador.play('fade_out')
		# Color.DARK_MAGENTA.lerp()
