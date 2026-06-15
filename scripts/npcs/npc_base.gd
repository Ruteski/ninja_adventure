class_name NpcBase extends PersonagemBase


enum Npcs {
	boy = 0,
	inspector = 1,
	mask_frog = 2,
	master = 3,
	noble = 4,
	old_man = 5,
	princess = 6,
	samurai = 7,
	shaman = 8,
	spirit = 9,
	villager = 10,
	woman = 11
}

var _direcao: Vector2 = Vector2.ZERO

@export var _npc_selecionado: Npcs
@export var _tempo_direcao: Timer


func _ready() -> void:
	# iniciando aqui pq o congelar chama a animacao fazendo o char olhar para a direcao correta
	_prefixo_animacao = gerenciador_portais.direcao_alvo
	
	_textura.texture = load(
		"res://assets/actors/npcs/" + _codigo_personagem[_npc_selecionado] + "/spritesheet.png"
	)
	
	_tempo_direcao.start(5.0)


func _physics_process(_delta: float) -> void:
	velocity = _direcao * 32.0
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		# get_slide_collision(0) -> primeiro objeto que o npc esta colidindo
		_direcao = velocity.bounce(get_slide_collision(0).get_normal()).normalized()
		
		# sempre vai priorizar a ultima direcao disponivel(apertada) 
	if _direcao.x < 0: # is_action_pressed  -> le acao enquanto estiver sendo precionada(segurando o botao)
		_prefixo_animacao = "_esquerda"
		
	if _direcao.x > 0:
		_prefixo_animacao = "_direita"
		
	if _direcao.y > 0:
		_prefixo_animacao = "_baixo"
		
	if _direcao.y < 0:
		_prefixo_animacao = "_cima"

	_animar()


func _on_tempo_direcao_timeout() -> void:
	if _direcao == Vector2.ZERO:
		_direcao = Vector2(
			randi_range(-1,1), randi_range(-1,1)
		).normalized()
		print(_direcao)
		

		
	else:
		_direcao = Vector2.ZERO
		
	_tempo_direcao.start(5.0)
