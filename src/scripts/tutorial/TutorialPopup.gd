extends Node2D

# PT_BR: Variável exportada usada para saber se o tutorial está sendo aberto pelo menu.
# EN_US: Exported variable used to know if the tutorial is being opened from the menu.
export var is_in_menu = true

# PT_BR: Váriaveis que carregam as cenas de partes específicas do tutorial.
# EN_US: ariables that load the scenes from specific tutorial parts.
var file_scene = preload("res://scenes/tutorial/File_explanning.tscn")
var task_scene = preload("res://scenes/tutorial/Task_introduction.tscn")

# PT_BR: Função usada para finalizar o tutorial e definir se deve abrir a tela de fases ou esconder o popup.
# EN_US: Function used to end the tutorial and define wheter to open the phases scee or hide the popup.
func end_tutorial():
	if is_in_menu:
		var __ = get_tree().change_scene("res://scenes/Phases.tscn")
	else:
		for child in self.get_children():
			child.hide()
		self.hide()


# PT_BR: Função para criar uma instância da variável file_scene e conectar sinais a ela.
# EN_US: Function to create an instance from the file_scene variable and connect signals to it.
func create_file():
	var file_instance = file_scene.instance()
	self.add_child(file_instance)
	file_instance.connect("back_tutorial", self,"_on_file_back_tutorial")
	file_instance.connect("next_tutorial", self, "_on_file_next_tutorial")
	
	
# PT_BR: Função para criar uma instância da variável file_task e conectar sinais a ela.
# EN_US: Function to create and instance from the file_task variable and connect signals to it.
func create_task():
	var task_instance = task_scene.instance()
	self.add_child(task_instance)
	task_instance.connect("back_tutorial", self,"_on_task_back_tutorial")
	task_instance.connect("next_tutorial", self, "_on_task_next_tutorial")


# PT_BR (1): Função chamada para decidir se irá encerrar o jogo.
# PT_BR (2): Parâmetro: event.
# EN_US (1): Function called to decide if the game will be ended. 
# EN_US (2): Parameter: event.
func _input(event):
	if event.is_action_pressed("home"):
		get_tree().quit()


# PT_BR: Sinal customizado para mostrar a introdução e ocultar o próprio node2D.
# EN_US: Custom signal to show the introduction and hide the node2D itself.
func open_tutorial():
	$introduction.show()
	self.show()


# PT_BR: Sinal customizado para ocultar a introdução e mostrar o botão de pular.
# EN_US: Custom signal to hide the introduction and show the skip button.
func _on_introduction_next_tutorial():
	$introduction.hide()
	$skip.show()


# PT_BR: Sinal customizado para ocultar a introdução e o próprio node2D.
# EN_US: Custom signal to hide the introduction and the node2D itself.
func _on_introduction_back_tutorial():
	$introduction.hide()
	self.hide()


# PT_BR: Sinal customizado para ocultar o botão de pular e mostrar a Paula.
# EN_US: Custom signal to hide the skip button and show Paula.
func _on_skip_next_tutorial():
	$skip.hide()
	$paula.show()


# PT_BR: Sinal customizado para ocultar a Paula e instanciar a ficha.
# EN_US: Custom signal to hide Paula and instantiate the file scene.
func _on_paula_next_tutorial():
	$paula.hide()
	create_file()


# PT_BR: Sinal customizado para ocultar a Paula e mostrar o botão de pular.
# EN_US: Custom signal to hide Paula and show the skip button.
func _on_paula_back_tutorial():
	$paula.hide()
	$skip.show()


# PT_BR (1): Sinal customizado para deletar a ficha e instanciar a tarefa. 
# PT_BR (2): Parâmetro: file - node2D. 
# EN_US (1): Custom signal to delete the file and instantiate the task.
# EN_US (2): Parameter: file - node2D.
func _on_file_next_tutorial(file):
	file.queue_free()
	create_task()


# PT_BR (1): Sinal customizado para deletar a ficha e mostrar a Paula.
# PT_BR (2): Parâmetro: file - node2D.
# EN_US (1): Custom signal to delete the file and show Paula.
# EN_US (2): Parameter: file - node2D.
func _on_file_back_tutorial(file):
	file.queue_free()
	$paula.show()	


# PT_BR (1): Sinal customizado para deletar a tarefa e mostrar a pontuação.
# PT_BR (2): Parâmetro: task - node2D.
# EN_US (1): Custom signal to delete the task and show the score.
# EN_US (2): Parameter: task - node2D.
func _on_task_next_tutorial(task):
	task.queue_free()
	$score.show()


# PT_BR (1): Sinal customizado para deletar a tarefa e instanciar a ficha. 
# PT_BR (2): Parâmetro: task - node2D.
# EN_US (1): Custom signal to delete the task and instantiate the file.
# EN_US (2): Parameter: task - node2D.
func _on_task_back_tutorial(task):
	task.queue_free()
	create_file()


# PT_BR: Sinal customizado para chamar a função que encerra o tutorial.
# EN_US: Custom signal to call the function to end the tutorial.
func _on_score_next_tutorial():
	end_tutorial()


# PT_BR: Sinal customizado para ocultar a pontuação e instanciar a tarefa.
# EN_US: Custom signal to hide the score and instantiate the task.
func _on_score_back_tutorial():
	$score.hide()
	create_task()


# PT_BR: Sinal customizado para chamar a função que encerra o tutorial.
# EN_US: Custom signal to call the function to end the tutorial.
func _on_skip_end_tutorial():
	end_tutorial()


# PT_BR: Sinal customizado para ocultar a cena de introdução do tutorial
# EN_US: Custom signal to hide the tutorial introduction scene
func _on_skip_back_tutorial():
	$introduction.show()
	$skip.hide()
