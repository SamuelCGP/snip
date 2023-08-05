extends Object
class_name JsonHelper


static func jsonToDict(pathToJson: String) -> Dictionary:
	var jsonString = FileAccess.open(pathToJson, FileAccess.READ).get_as_text()
	var json = JSON.new()
	var error = json.parse(jsonString)
	assert(
		error == OK,
		(
			"JSON Parse Error: "
			+ str(json.get_error_message())
			+ " at line "
			+ str(json.get_error_line())
		)
	)
	return json.data as Dictionary
