extends Control

func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "_on_FirebaseAuth_login_failed")
	Firebase.Auth.connect("signup_succeeded", self, "_on_FirebaseAuth_signup_succeeded")
	pass # Replace with function body.

func _on_Login_button_up():
	var email = $UserName.text
	var password = $Password.text
	Firebase.Auth.login_with_email_and_password(email,password)
	pass # Replace with function body.

func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	get_tree().change_scene("res://scenes/Menu.tscn")
	Globals.userinfo = auth_info
	# Adicionar estas linhas para criar um novo documento para o usuário no Firestore
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var add_task : FirestoreTask = firestore_collection.add(Globals.userinfo.email, {'name': Globals.userinfo.email, 'score': 0})
	var addedUser : FirestoreDocument = yield(add_task, "task_finished")
	print("Added new document for user.")

func _on_FirebaseAuth_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))

func _on_Register_button_up():
	var email = $UserName.text
	var password = $Password.text
	Firebase.Auth.signup_with_email_and_password(email,password)
	pass # Replace with function body.

func _on_FirebaseAuth_signup_succeeded(auth_info):
	print("signup successful " + str(auth_info))
	Globals.userinfo = auth_info
	Firebase.Auth.send_account_verification_email()

func _on_ForgotPassword_button_up():
	var email = $UserName.text
	Firebase.Auth.send_password_reset_email(email)
	pass # Replace with function body.

func _on_GetScores_button_up():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection("userdata")
	firestore_collection.get("finepointcgi")
	var document : FirestoreDocument = yield(firestore_collection, "get_document")
	print(document)
	var add_task : FirestoreTask = firestore_collection.add(Globals.userinfo.email, {'name':Globals.userinfo.email,'score': 30})
	var addedUser : FirestoreDocument = yield(add_task, "task_finished")
	print(addedUser)
	pass # Replace with function body.

func _on_UpdateScore_button_up():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var up_task : FirestoreTask = firestore_collection.update(Globals.userinfo.email, {'name':Globals.CONNECT_DEFERREDuserinfo.email, 'score':100})
	var document : FirestoreDocument = yield(up_task, "task_finished")
	pass # Replace with function body.

func QueryDB():
	var query : FirestoreQuery = FirestoreQuery.new()
	query.from('userdata')
	query.order_by('score', FirestoreQuery.DIRECTION.DESCENDING)
	query.limit(3)
	var query_task :FirestoreTask = Firebase.Firestore.query(query)
	var result = yield(query_task,"task_finished")
	print(result)


func _on_GetTopScores_button_up():
	QueryDB()
	pass # Replace with function body.
	
func removeDocumentData():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var del_task : FirestoreTask = firestore_collection.delete(Globals.userinfo.email)
	var document : FirestoreDocument = yield(del_task, "task_finished")

func _on_DeleteRecord_button_up():
	removeDocumentData()
	pass # Replace with function body.

func _on_RemoveUser_button_up():
	Firebase.Auth.delete_user_account()
	pass # Replace with function body.


