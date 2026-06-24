class_name CenaDialogo extends Control

var informacoes_dialogo: Dictionary
var indice_dialogo: int
var npc_atual: NpcBase
var personagem_atual: PersonagemBase
var dialogo_atual: String

@onready var _dialogo: Label = $TexturaFundo/Dialogo
@onready var _foto: TextureRect = $TexturaFundo/Foto
@onready var _nome_npc: Label = $TexturaFundo/Titulo
@onready var _container_questao: VBoxContainer = $TexturaFundo/ContainerVertical
@onready var _dialogo_questao: Label = $TexturaFundo/ContainerVertical/DialogoEscolha
@onready var _container_escolhas: HBoxContainer = $TexturaFundo/ContainerVertical/ContainerHorizontal


func _ready() -> void:
	dialogo_atual = informacoes_dialogo["dialogo_atual"]
	_carregar_dialogo()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("confirmar"):
		#informacoes_dialogo[dialogo_atual].keys().size()
		indice_dialogo += 1
		
		if indice_dialogo >= informacoes_dialogo[dialogo_atual].size() :
			_matar_dialogo()
			return
			
		_carregar_dialogo()


func _matar_dialogo() -> void :
	if dialogo_atual == "primeiro_dialogo":
		if informacoes_dialogo.has("segundo_dialogo"):
			informacoes_dialogo["dialogo_atual"] = "segundo_dialogo"
			
	elif dialogo_atual == "segundo_dialogo":
		if informacoes_dialogo.has("terceiro_dialogo"):
			informacoes_dialogo["dialogo_atual"] = "terceiro_dialogo"
			
		elif informacoes_dialogo["tipo_dialogo"] == "loop":
			informacoes_dialogo["dialogo_atual"] = "primeiro_dialogo"			
			
	elif dialogo_atual == "terceiro_dialogo":
		if informacoes_dialogo["tipo_dialogo"] == "loop":
			informacoes_dialogo["dialogo_atual"] = "primeiro_dialogo"
	
	npc_atual.dialogo_aberto = false
	personagem_atual.congelar(false)
	queue_free()


func _carregar_dialogo() -> void:
	var _informacoes_dialogo_atual: Dictionary = informacoes_dialogo[dialogo_atual][indice_dialogo]
	
	_foto.texture = load(informacoes_dialogo["foto"])
	_nome_npc.text = informacoes_dialogo["nome"]
	
	match _informacoes_dialogo_atual["tipo"]:
		"mensagem":
			_dialogo.text = _informacoes_dialogo_atual["texto"]
			_container_questao.hide()
			_dialogo.show()
		"questao":
			_dialogo.hide()
			_container_questao.show()
			_dialogo_questao.text = _informacoes_dialogo_atual["texto"]
			
			# desabilita a visualizacao nos filhos do container horizontal
			# (botoes de escolha)
			for _escolha in _container_escolhas.get_children():
				_escolha.hide()
			
			var _indice: int = 0
			for resposta in _informacoes_dialogo_atual["respostas"]:
				var _container_escolha: NinePatchRect = _container_escolhas.get_child(_indice)
				_container_escolha.get_node("Texto").text = resposta
				_container_escolha.show()
				_indice += 1
