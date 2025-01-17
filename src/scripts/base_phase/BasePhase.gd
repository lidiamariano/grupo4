extends Node2D
# PT_BR: Exporta a variável para selecionar a fase
# EN_US: Exports the variable for select the phase
export(Globals.PHASES) var phase_key = Globals.PHASES.PHASE_1

# PT_BR: Inicializa variáveis de cenas importantes da fase
# EN_US: Initialize variables of important scenes of the phase
export(NodePath) var phase_progress = null
export(NodePath) var map = null

# PT_BR: Inicializa variáveis responsáveis por armazenar os slots das tarefas de cada personagem
# EN_US: Initialize variables responsible for storing the tasks slots of each character
export(NodePath) var slot_kira = null
export(NodePath) var slot_roger = null
export(NodePath) var slot_ana = null
export(NodePath) var slot_bento = null

# PT_BR: Inicializa variáveis responsáveis por armazenar os slots das fichas de perfil de cada personagem
# EN_US: Initialize variables responsible for storing the profile sheets slots of each character
export(NodePath) var profile_kira = null
export(NodePath) var profile_roger = null
export(NodePath) var profile_ana = null
export(NodePath) var profile_bento = null

# PT_BR: Inicializa variáveis que armazenam os as estrelas da pontuação
# EN_US: Initialize variables that stores the progress stars
export(NodePath) var star1 = null
export(NodePath) var star2 = null
export(NodePath) var star3 = null

# PT_BR: Armazena a referência do objeto ClickAudio
# EN_US: Stores the ClickAudio object reference
onready var click_audio = $ClickAudio

# PT_BR: Armazena a referência do objeto ClickAudio
# EN_US: Stores the ClickAudio object reference
onready var pause_scene = $Pause

# PT_BR: Armazena o score máximo da fase
# EN_US: Stores the phase max score
onready var max_score = Globals.phases_max_score[ Globals.phases_keys[phase_key] ]


func _ready():
	  # Reset total_score when the game restarts
	# Resto do código...

	get_node("UserInfoLabel").text = "Você está logado como: " + Globals.userinfo.email
	# PT_BR: Toca a música da fase
	# EN_US: Plays the phase music
	Audio.change_music(Globals.phase_musics[ Globals.phases_keys[phase_key] ])
	
	# PT_BR: Reseta a variável de pontos.
	# EN_US: Reset the points variable.
	Globals.lose_by_time = false
	Globals.set_actual_score(0)
	Globals.set_actual_phase(phase_key)
	
	# PT_BR: Armazena os objetos dos NodePaths
	# EN_US: Stores the NodePath's Objects
	phase_progress = _return_object_by_node_path(phase_progress)
	map = _return_object_by_node_path(map)
	
	slot_kira = _return_object_by_node_path(slot_kira)
	slot_roger = _return_object_by_node_path(slot_roger)
	slot_ana = _return_object_by_node_path(slot_ana)
	slot_bento = _return_object_by_node_path(slot_bento)
	
	profile_kira = _return_object_by_node_path(profile_kira)
	profile_roger = _return_object_by_node_path(profile_roger)
	profile_ana = _return_object_by_node_path(profile_ana)
	profile_bento = _return_object_by_node_path(profile_bento)
	
	star1 = _return_object_by_node_path(star1)
	star2 = _return_object_by_node_path(star2)
	star3 = _return_object_by_node_path(star3)


# PR_BR: Essa função observa a posição do mouse e aplica o hover nas fichas
# EN_US: This funcction observes the mouse position and applies the hover on the files 
func _process(_delta):
	if profile_kira != null and not profile_kira is NodePath:
		_send_hover_effect_in_file(profile_kira)
	
	if profile_roger != null:
		_send_hover_effect_in_file(profile_roger)
	
	if profile_ana != null:
		_send_hover_effect_in_file(profile_ana)
		
	if profile_bento != null:
		_send_hover_effect_in_file(profile_bento)
	
# PT_BR (1): Função para atualizar a pontuação do jogador
# PT_BR (2): Parâmetro: new_value int
# EN_US (1): Function to update the player's score
# EN_US (2): Parameter: new_value int
func _change_score(new_value): 
	Globals.set_actual_score(Globals.actual_score + new_value)
	Globals.total_score += new_value
	var actual_score = Globals.actual_score
	Globals.result = float(actual_score * 100) / float(max_score)

	if Globals.result > 73:
		star3.value = clamp((Globals.result - 73), 0, 12)
		star2.value = clamp((Globals.result - 56), 0, 17)
	elif Globals.result > 56: 
		star2.value = clamp((Globals.result - 56), 0, 17)
				
	star1.value = clamp(Globals.result, 0, 56)
	

# PT_BR (1): Função para retornar um objeto a partir do seu node path
# PT_BR (2): Parâmetro: node_path - NodePath
# EN_US (1): Function to return an object from its node path
# EN_US (2): Parameter:  node_path - NodePath
func _return_object_by_node_path(node_path):
	if node_path != null and not node_path.is_empty():
		return self.get_node(node_path)
	return null


# PT_BR: Função para mudar a cena quando o tempo do jogo acaba
# EN_US: Function to change the scene when the game time is over
func _on_TimeDisplayer_timer_is_over():
	Globals.lose_by_time = true
	var __ = get_tree().change_scene("res://scenes/Result/Result.tscn")


# PT_BR: Função para mudar a cena quando o jogador conclui todas as tarefas
# EN_US: Function to change the scene when the player concludes all tasks
func _on_PhaseProgress_completed_change():
	var __ = get_tree().change_scene("res://scenes/Result/Result.tscn")


# PT_BR (1): Sinal que é emitido quando o personagem "Ana" finaliza uma tarefa
# PT_BR (2): Parâmetro: worker - espaço que está a tarefa
# PT_BR (3): Atualiza o progresso da fase, pontuação e retira o item do slot
# EN_US (1): Signal that is sent when the character "Ana" ends a task
# EN_US (2): Parameter: worker - space where the task is
# EN_US (3): Updates the phase progress, score and removes the item from slot
func _on_Map_ana_fineshed_task(worker):
	phase_progress.increase_value()
	_change_score(worker.score)
	slot_ana._clearSlot()
	slot_ana.can_give = true


# PT_BR (1): Sinal que é emitido quando o personagem "Bento" finaliza uma tarefa
# PT_BR (2): Parâmetro: worker - espaço que está a tarefa
# PT_BR (3): Atualiza o progresso da fase, pontuação e retira o item do slot
# EN_US (1): Signal that is sent when the character "Bento" ends a task
# EN_US (2): Parameter: worker - space where the task is
# EN_US (3): Updates the phase progress, score and removes the item from slot
func _on_Map_bento_fineshed_task(worker):
	phase_progress.increase_value()
	_change_score(worker.score)
	slot_bento._clearSlot()
	slot_bento.can_give = true


# PT_BR (1): Sinal que é emitido quando o personagem "Kira" finaliza uma tarefa
# PT_BR (2): Parâmetro: worker - espaço que está a tarefa
# PT_BR (3): Atualiza o progresso da fase, pontuação e retira o item do slot
# EN_US (1): Signal that is sent when the character "Kira" ends a task
# EN_US (2): Parameter: worker - space where the task is
# EN_US (3): Updates the phase progress, score and removes the item from slot
func _on_Map_kira_fineshed_task(worker):
	phase_progress.increase_value()
	_change_score(worker.score)
	slot_kira._clearSlot()
	slot_kira.can_give = true


# PT_BR (1): Sinal que é emitido quando o personagem "Roger" finaliza uma tarefa
# PT_BR (2): Parâmetro: worker - espaço que está a tarefa
# PT_BR (3): Atualiza o progresso da fase, pontuação e retira o item do slot
# EN_US (1): Signal that is sent when the character "Roger" ends a task
# EN_US (2): Parameter: worker - space where the task is
# EN_US (3): Updates the phase progress, score and removes the item from slot
func _on_Map_roger_fineshed_task(worker):
	phase_progress.increase_value()
	_change_score(worker.score)
	slot_roger._clearSlot()
	slot_roger.can_give = true


# PT_BR (1): Função conectada ao sinal que é emitido quando o slot do personagem pega um item
# PT_BR (2): Parâmetro: slot 
# PT_BR (3): Chama a função do mapa para iniciar a tarefa do personagem
# EN_US (1): Function connected to the signal that is emitted when the character's slot picks up an item
# EN_US (2): Parameter: slot
# EN_US (3): Calls the map function to start the character's task
func _on_WorkSlotKira_get_item(slot):
	slot.can_give = false
	map.Kira_initiate_task(slot)


# PT_BR (1): Função conectada ao sinal que é emitido quando o slot do personagem pega um item
# PT_BR (2): Parâmetro: slot 
# PT_BR (3): Chama a função do mapa para iniciar a tarefa do personagem
# EN_US (1): Function connected to the signal that is emitted when the character's slot picks up an item
# EN_US (2): Parameter: slot
# EN_US (3): Calls the map function to start the character's task
func _on_WorkSlotRoger_get_item(slot):
	slot.can_give = false
	map.Roger_initiate_task(slot)


# PT_BR (1): Função conectada ao sinal que é emitido quando o slot do personagem pega um item
# PT_BR (2): Parâmetro: slot 
# PT_BR (3): Chama a função do mapa para iniciar a tarefa do personagem
# EN_US (1): Function connected to the signal that is emitted when the character's slot picks up an item
# EN_US (2): Parameter: slot
# EN_US (3): Calls the map function to start the character's task
func _on_WorkSlotBento_get_item(slot):
	slot.can_give = false
	map.Bento_initiate_task(slot)


# PT_BR (1): Função conectada ao sinal que é emitido quando o slot do personagem pega um item
# PT_BR (2): Parâmetro: slot 
# PT_BR (3): Chama a função do mapa para iniciar a tarefa do personagem
# EN_US (1): Function connected to the signal that is emitted when the character's slot picks up an item
# EN_US (2): Parameter: slot
# EN_US (3): Calls the map function to start the character's task
func _on_WorkSlotAna_get_item(slot):
	slot.can_give = false
	map.Ana_initiate_task(slot)


# PT_BR: Emite o som de click assim que o mouse é pressionado
# EN_US: Emits the click sound when the mouse is pressed
func _input(event):
	if event.is_action_pressed("click"):
		$ClickAudio.play()


# PT_BR (1): Essa função aplica o hover nas fichas
# PT_BR (2): Parâmetro: begin, que é o limite inferior da zona de entrada do mouse: Vector2
# PT_BR (3): Parâmetro: end, que é o limite superior da zona de entrada do mouse: Vector2
# PT_BR (4): Parâmetro: slot, que é um nó da cena
# EN_US (1): This function applies the hover to the files
# EN_US (2): Parameter: begin, which is the lower limit of the mouse input zone: Vector2
# EN_US (3): Parameter: end, which is the higher limit of the mouse input zone: Vector2
# EN_US (4): Parameter: slot, which is a node in the scene
func _hover_file(begin: Vector2, end: Vector2, slot:CenterContainer):
	var mouse = get_global_mouse_position()
	
	if mouse.x >= begin.x and mouse.x <= end.x and mouse.y >= begin.y and mouse.y <= end.y:
		slot.rect_scale  = Vector2(1.25,1.25)
	else:
		slot.rect_scale = Vector2(1,1)


# PT_BR (1): Essa função simplifica a chamada da função hover file
# PT_BR (2): Parâmetro: profile - Center Container
# EN_US (1): This function simplifies calling the hover file function
# EN_US (2): Parameter: profile - Center Container
func _send_hover_effect_in_file(profile):
	var begin = profile.rect_global_position
	var end = begin + profile.rect_size
	
	_hover_file(begin, end, profile)


# PT_BR: Abre a cena de pause
# EN_US: Opens the pause scene
func _on_PauseButton_pressed():
	pause_scene.open_pause_scene()
