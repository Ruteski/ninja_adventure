class_name GerenciadorDialogos extends Node

var lista_dialogos: Dictionary = {
	"old_man_vila_inicial": {
		"foto": "res://assets/actors/character/oldman/faceset.png",
		"nome": "Homem Velho",
		"dialogo_atual": "primeiro_dialogo",
		"tipo_dialogo": "sequencial",
		"primeiro_dialogo": {
			0: {
				"tipo": "mensagem",
				"texto": "Olá, aventureiro! Sua aventura começa aqui!",
			},
			1: {
				"tipo": "questao",
				"texto": "Você apareceu nesta casa do nada. Me diga, qual a sua classe?",
				"respostas": ["Guerreiro", "Ladino", "Mago"],
			},
			2: {
				"tipo": "mensagem",
				"texto": "Entendi! A direita desta casa, existe um baú... Você pode pegar nele alguma arma que vai te ajudar nessa jornada",
			},
		},
		"segundo_dialogo": {
			0: {
				"tipo": "mensagem",
				"texto": "Boa sorte na sua aventura! Você pode sair para explorar o mundo usando a porta abaixo."
			}
		},
		"terceiro_dialogo": {
			0: {
				"tipo": "mensagem",
				"texto": "... Você ainda está aqui? Vá explorar o mundo!"
			}
		}		
	}
}
