class_name Helpers

static func snake_to_capitalized(e: String) -> String:
	return e.replace('_', ' ').to_lower().capitalize()
	
static func snake_to_camel(e: String) -> String:
	return e.replace('_', '').to_lower().capitalize().replace(' ', '')
	
static func str_to_json(str: String) -> JSON:
	var json = JSON.new()
	json.data = JSON.parse_string(str)
	return json
	
static func json_path_to_dict(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse_string(content)
	
static func dict_keys_match(dict1: Dictionary, dict2: Dictionary) -> bool:
	var keys1 = dict1.keys()
	var keys2 = dict2.keys()
	keys1.sort()
	keys2.sort()
	return keys1 == keys2
