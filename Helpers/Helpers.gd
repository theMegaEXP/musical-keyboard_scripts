class_name Helpers

static func enum_string_to_capitalized(e: String) -> String:
	return e.replace('_', ' ').to_lower().capitalize()
	
static func enum_string_to_camel(e: String) -> String:
	return e.replace('_', '').to_lower().capitalize().replace(' ', '')
	
static func str_to_json(str: String) -> JSON:
	var json = JSON.new()
	json.data = JSON.parse_string(str)
	return json

