extends Object
class_name CSVHelper

static func csvToDictById(pathToCSV: String, lineId: String) -> Dictionary:
	var file := FileAccess.open(pathToCSV, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var lines := content.split("\n")

	var headers: PackedStringArray
	var data := {}
	for i in lines.size():
		var line = lines[i].replace("\r", "")
		var fields := line.split(",")

		if i == 0:
			headers = fields
			continue

		if(fields[0] == lineId):
			for j in fields.size():
				data[headers[j]] = fields[j]

	return data
