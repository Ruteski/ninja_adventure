class_name CenaDialogo extends Control

var informacoes_dialogo: Dictionary
var indice_dialogo: int
var npc_atual
var personagem_atual: PersonagemBase
var dialogo_atual: String

@onready var _dialogo: Label = $TexturaFundo/Dialogo
@onready var _foto: TextureRect = $TexturaFundo/Foto
@onready var _nome_npc: Label = $TexturaFundo/Titulo
@onready var _container_questao: VBoxContainer = $TexturaFundo/ContainerVertical
@onready var _dialogo_questao: Label = $TexturaFundo/ContainerVertical/DialogoEscolha
@onready var _container_escolhas: HBoxContainer = $TexturaFundo/ContainerVertical/ContainerHorizontal
@onready var _confirmar: TextureRect = $TexturaFundo/Confirmar


#TODO corrigir problema ao usar o mouse para mudar de dialogo

func _ready() -> void:
	_confirmar.mouse_entered.connect(_quando_mouse_entrar.bind(_confirmar))
	_confirmar.mouse_exited.connect(_quando_mouse_sair.bind(_confirmar))
	_confirmar.gui_input.connect(_quando_selecionar_escolha.bind(_confirmar))
	
	for  _escolha: NinePatchRect in $TexturaFundo/ContainerVertical/ContainerHorizontal.get_children():
		_escolha.mouse_entered.connect(_quando_mouse_entrar.bind(_escolha))
		_escolha.mouse_exited.connect(_quando_mouse_sair.bind(_escolha))
		_escolha.gui_input.connect(_quando_selecionar_escolha.bind(_escolha))
		
	dialogo_atual = informacoes_dialogo["dialogo_atual"]
	_carregar_dialogo()


func _quando_mouse_entrar(_escolha: CanvasItem) -> void:
	_escolha.modulate.a = 0.5


func _quando_mouse_sair(_escolha: CanvasItem) -> void:
	_escolha.modulate.a = 1


# existe o primeiro param _event, pq o signal gui_input, por padrao ja recebe um param do tipo InputEvent 
func _quando_selecionar_escolha(_event, _escolha: Control):
	if _event is InputEventMouseButton:
		if _event.button_index == 1 && _event.pressed == true:
			if _escolha.name == "confirmar":
				_tratar_mudanca_dialogo()
				return
				
			match informacoes_dialogo[dialogo_atual][indice_dialogo]["pergunta"]:
				"tipo_classe_personagem":
					informacoes_personagem.classe = _escolha.get_node("Texto").text
					
			#print(_escolha)
			#print(_escolha.get_node("Texto").text)
			print(informacoes_personagem.classe)
			_tratar_mudanca_dialogo()


func _tratar_mudanca_dialogo() -> void:
	indice_dialogo += 1
	if indice_dialogo >= informacoes_dialogo[dialogo_atual].size():
		_matar_dialogo()
		return
		
	_carregar_dialogo()	


func _process(_delta: float) -> void:
	if indice_dialogo < informacoes_dialogo[dialogo_atual].size():
		if informacoes_dialogo[dialogo_atual][indice_dialogo]["tipo"] != "questao":
			$TexturaFundo/Confirmar.visible = _dialogo.visible_ratio == 1.0
	
	if _dialogo.visible_ratio < 1.0:
		_dialogo.visible_ratio += 0.01
		
	if Input.is_action_just_pressed("confirmar"):
		if _dialogo.visible_ratio < 1.0:
			_dialogo.visible_ratio = 1
		else: 
			if informacoes_dialogo[dialogo_atual][indice_dialogo]["tipo"] == "questao":
				return
			#informacoes_dialogo[dialogo_atual].keys().size()
			_tratar_mudanca_dialogo()


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
	
	if !informacoes_dialogo["foto"].is_empty():
		_foto.texture = load(informacoes_dialogo["foto"])
	else:
		_foto.texture = null
		
	_nome_npc.text = informacoes_dialogo["nome"]
	
	match _informacoes_dialogo_atual["tipo"]:
		"mensagem":
			_dialogo.text = _informacoes_dialogo_atual["texto"]
			_dialogo.visible_ratio = 0.0
			_container_questao.hide()
			_dialogo.show()
		"questao":
			$TexturaFundo/Confirmar.hide()
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
