class_name CenaDialogo extends Control

var informacoes_dialogo: Dictionary
var dialogo_atual: String
var indice_dialogo: int

@onready var _dialogo = $TexturaFundo/Dialogo
@onready var _foto = $TexturaFundo/Foto
@onready var _nome_npc = $TexturaFundo/Titulo
@onready var _container_questao = $TexturaFundo/ContainerVertical
@onready var _dialogo_questao = $TexturaFundo/ContainerVertical/DialogoEscolha
@onready var _container_escolhas = $TexturaFundo/ContainerVertical/ContainerHorizontal


func _ready() -> void:
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
