class_name Hashset

var _set = {}

func add(value):
	_set[value] = true
	
func remove(value):
	_set.erase(value)
	
func contains(value) -> bool:
	return _set.has(value)
	
func size():
	return _set.size()
	
func clear():
	_set.clear()
	
func is_empty() -> bool:
	return _set.size() == 0
	
func to_array():
	return _set.keys()

