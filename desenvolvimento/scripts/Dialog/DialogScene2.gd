extends Node2D

# PT_BR: Função que muda a animação do sprite quando acionada 
# EN_US: Function that changes the sprite animation when activated
func change_anim(anim):
	$ChicoAnimatedSprite.animation = anim

# PT_BR: Função que define se o sprite "Computer" deve aparecer ou ficar escondido 
# EN_US: Function that defines if the sprite "Computer" should appear or stay hidden
func show_tent(show_tent):
	# PT_BR: Se o a variável for acionada, o sprite deve aparecer na tela
	# EN_US: If the variable is activated, ths sprite should appear on screen
	if show_tent:
		$Tent.show() 
	# PT_BR: Caso contrário, ele deve ficar oculto 
	# EN_US: In other case, it should stay hidden
	else:
		$Tent.hide() 
		
# PT_BR: Função que define que após o pressionar do botão, a cena é mudada
# EN_US: Function that definas that after the press of the button, the scene is changed
func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")


func _on_DialogBox_finished_dialog():
	get_tree().change_scene("res://scenes/phase2/Phase2.tscn")


