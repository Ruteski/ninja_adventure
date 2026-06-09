class_name PersonagemBase extends CharacterBody2D

@onready var speed: float = 64.0

var _prefixo_animacao: String = "_baixo"

@export_category("Objects")
@export var _animador: AnimationPlayer

func _physics_process(_delta: float) -> void:
	# get_vector ja normaliza a direcao diracao nas diagonais
	var direcao: Vector2 = Input.get_vector(
		"mover_esquerda",
		"mover_direita",
		"mover_cima",
		"mover_baixo"
	)
	
	# sempre vai priorizar a ultima direcao disponivel(apertada) 
	if Input.is_action_just_pressed("mover_esquerda"):
		_prefixo_animacao = "_esquerda"
		
	if Input.is_action_just_pressed("mover_direita"):
		_prefixo_animacao = "_direita"
		
	if Input.is_action_just_pressed("mover_baixo") && direcao.y != 0:
		_prefixo_animacao = "_baixo"
		
	if Input.is_action_just_pressed("mover_cima") && direcao.y != 0:
		_prefixo_animacao = "_cima"
	
	velocity = direcao * 64.0
	move_and_slide() # sempre tem que ter esse metodo pra fazer se movimentar
	
	_animar()
	
	
func _animar() -> void:
	if velocity == Vector2.ZERO:
		_animador.play("parado" + _prefixo_animacao)
	elif velocity != Vector2.ZERO:
		_animador.play("andando" + _prefixo_animacao)
	
