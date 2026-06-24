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
var _personagem_no_alcanse: bool = false
var dialogo_aberto := false
var _personagem: PersonagemBase = null
var _indice_dialogo: int = 0

@export var _npc_selecionado: Npcs
@export var _tempo_direcao: Timer
@export var _tempo_mudar_direcao: float = 5
@export var _nome_npc: String = ""
@export var _interface: CanvasLayer

#@export var _indicador_fala: Sprite2D
#ou assim
@onready var _indicador_fala: Sprite2D = $IndicadorFala


func _ready() -> void:
	# iniciando aqui pq o congelar chama a animacao fazendo o char olhar para a direcao correta
	_prefixo_animacao = gerenciador_portais.direcao_alvo
	
	_textura.texture = load(
		"res://assets/actors/npcs/" + _codigo_personagem[_npc_selecionado] + "/spritesheet.png"
	)
	
	_tempo_direcao.start(_tempo_mudar_direcao)


func _physics_process(_delta: float) -> void:
	# se tiver personagem no alcance, ele nao se movimenta
	if _personagem_no_alcanse:
		if Input.is_action_just_pressed("interagir") && !dialogo_aberto:
			var _cena_dialogo: CenaDialogo = load("res://scenes/ui/dialog/cena_dialogo.tscn").instantiate()
			_cena_dialogo.informacoes_dialogo = gerenciador_dialogos.lista_dialogos[_nome_npc]
			_cena_dialogo.indice_dialogo = _indice_dialogo
			_cena_dialogo.npc_atual = self
			_cena_dialogo.personagem_atual = _personagem
			
			_interface.add_child(_cena_dialogo)
			dialogo_aberto = true
			_personagem.congelar(true)
			
		velocity = Vector2.ZERO
		_animar()
		return
		
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
	_tempo_mudar_direcao = randi_range(1, 6)
	_tempo_direcao.start(_tempo_mudar_direcao)	
	
	# se tiver personagem no alcance, ele nao se movimenta
	if _personagem_no_alcanse:
		return
		
	if _direcao == Vector2.ZERO:
		_direcao = Vector2(
			randi_range(-1,1), randi_range(-1,1)
		).normalized()
		print(_direcao)
	else:
		_direcao = Vector2.ZERO


func _on_area_dialogo_body_entered(body: Node2D) -> void:
	# msm que fazer a verificacao abaixo, deixei pq usa o self
	# if body is NpcBase: 
	#	return 
	if body is PersonagemBase:
		if body == self:
			return 
			
		_personagem_no_alcanse = true
		_personagem = body
		body.esta_no_alcance(self)
		_indicador_fala.show()


func _on_area_dialogo_body_exited(body: Node2D) -> void:
	# msm que fazer a verificacao abaixo, deixei pq usa o self
	if body is NpcBase: 
		return 
		
	# deixado assim pra variar o codigo com a func de entered
	if body is PersonagemBase:
		_personagem_no_alcanse = false
		_personagem = null
		body.esta_no_alcance(null)
		_indicador_fala.hide()
