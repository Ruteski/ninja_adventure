class_name Portal extends Area2D

@export var _cena_alvo: String = ""
@export var _titulo_alvo: String = ""
@export var _direcao_alvo: String = ""
@export var _posicao_alvo: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body is PersonagemBase:
		body.congelar(true)
		gerenciador_portais.direcao_alvo = _direcao_alvo
		gerenciador_portais.posicao_alvo = _posicao_alvo
		cena_transicao.mudar_cena(_cena_alvo, _titulo_alvo)
		
		
