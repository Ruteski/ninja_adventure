class_name AreaObjeto extends Area2D

var _personagem_no_alcance: bool = false
var _personagem: PersonagemBase = null
var dialogo_aberto: bool = false
var _indice_dialogo: int = 0

#@onready var _indicador_fala: Sprite2D = $Indicador
@export var _indicador_fala: Sprite2D
@export var _nome_objeto: String = ""
@export var _interface: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func _physics_process(_delta: float) -> void:
	# se tiver personagem no alcance, ele nao se movimenta
	if _personagem_no_alcance:
		if Input.is_action_just_pressed("interagir") && !dialogo_aberto:
			var _cena_dialogo: CenaDialogo = load("res://scenes/ui/dialog/cena_dialogo.tscn").instantiate()
			_cena_dialogo.informacoes_dialogo = gerenciador_dialogos.lista_dialogos[_nome_objeto]
			_cena_dialogo.indice_dialogo = _indice_dialogo
			_cena_dialogo.npc_atual = self
			_cena_dialogo.personagem_atual = _personagem
			
			_interface.add_child(_cena_dialogo)
			dialogo_aberto = true
			_personagem.congelar(true)	


func _on_body_exited(body: Node2D) -> void:
	if body is NpcBase:
		return
	
	if body is PersonagemBase:
		_personagem_no_alcance = false
		_indicador_fala.hide()
		body.esta_no_alcance(null)
		_personagem = null


func _on_body_entered(body: Node2D) -> void:
	if body is NpcBase:
		return
	
	if body is PersonagemBase:
		_personagem_no_alcance = true
		_indicador_fala.show()
		body.esta_no_alcance(self)
		_personagem = body
		
