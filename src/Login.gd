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

func _on_FirebaseAuth_login_succeeded():
	print("Success!")

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
