class_name PersonagemBase extends CharacterBody2D

enum Personagens {
	egg_boy = 0,
	hunter = 1,
	mask_racoon = 2,
	monkey_boxer_blue = 3,
	robot_camouflage = 4
}

var _prefixo_animacao: String = "_baixo"
var _pode_atacar: bool = true
var _atacando: bool = false
var _ataque_selecionado: String = ""

@export_category("Objetos")
@export var _animador: AnimationPlayer
@export var _textura: Sprite2D

@export_category("Variaveis")
@export var speed: float = 64.0
@export var _personagem_selecionado: Personagens
@export var _codigo_personagem: Array[String]


func _ready() -> void:
	# iniciando aqui pq o congelar chama a animacao fazendo o char olhar para a direcao correta
	_prefixo_animacao = gerenciador_portais.direcao_alvo
	
	# inicia congelado
	congelar(true)
	
	_textura.texture = load(
		"res://assets/actors/characters/" + _codigo_personagem[_personagem_selecionado] + "/spritesheet.png"
	)
	
	if gerenciador_portais.posicao_alvo == Vector2(0,0):
		return
		
	global_position = gerenciador_portais.posicao_alvo
	
	
func _physics_process(_delta: float) -> void:
	# get_vector ja normaliza a direcao diracao nas diagonais
	var direcao: Vector2 = Input.get_vector(
		"mover_esquerda",
		"mover_direita",
		"mover_cima",
		"mover_baixo"
	)
	
	# sempre vai priorizar a ultima direcao disponivel(apertada) 
	if Input.is_action_pressed("mover_esquerda"): # is_action_pressed  -> le acao enquanto estiver sendo precionada(segurando o botao)
		_prefixo_animacao = "_esquerda"
		
	if Input.is_action_pressed("mover_direita"):
		_prefixo_animacao = "_direita"
		
	if Input.is_action_pressed("mover_baixo") && direcao.y != 0:
		_prefixo_animacao = "_baixo"
		
	if Input.is_action_pressed("mover_cima") && direcao.y != 0:
		_prefixo_animacao = "_cima"
	
	velocity = direcao * 64.0
	move_and_slide() # sempre tem que ter esse metodo pra fazer se movimentar
	
	if Input.is_action_just_pressed("ataque") && _pode_atacar: # is_action_just_pressed -> le a acao apenas uma unica vez
		set_physics_process(false) # desabilita atacar andando
		_ataque_selecionado = "ataque" + _prefixo_animacao
		_pode_atacar = false
		_atacando = true
	elif Input.is_action_just_pressed("ataque_especial_1") and _pode_atacar:
		set_physics_process(false)
		_ataque_selecionado = "ataque_especial_1"
		_pode_atacar = false
		_atacando = true
	elif Input.is_action_just_pressed("ataque_especial_2") and _pode_atacar:
		set_physics_process(false)
		_ataque_selecionado = "ataque_especial_2"
		_pode_atacar = false
		_atacando = true
		
	_animar()
	
	
func _animar() -> void:
	if _atacando:
		_animador.play(_ataque_selecionado)
	elif velocity == Vector2.ZERO:
		_animador.play("parado" + _prefixo_animacao)
	elif velocity != Vector2.ZERO:
		_animador.play("andando" + _prefixo_animacao)
	
	
func _on_animador_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("ataque"):
		_atacando = false
		_pode_atacar = true
		set_physics_process(true)  # habilita andar
	
	
func congelar(isStop: bool) -> void:
	set_physics_process(!isStop)
	
	# posso fazer dessa forma
	velocity = Vector2.ZERO
	_animar()
	
	# ou desse forma(esta é a minha forma 1)
	#_animador.stop(isStop)
	
