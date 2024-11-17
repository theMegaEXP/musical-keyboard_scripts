class_name DoublyLinkedList

var _head = null
var _tail = null
var _size = 0

func _init(arr: Array = []):
	for item in arr:
		append(item)

func size() -> int:
	return _size

func append(value):
	var node = DoublyListNode.new(value)
	if is_empty():
		_head = node
		_tail = node
	else:
		_tail.next = node
		node.prev = _tail
		_tail = node
	_size += 1
	
func prepend(value):
	var node = DoublyListNode.new(value)
	if is_empty():
		_head = node
		_tail = node
	else:
		node.next = _head
		_head.prev = node
		_head = node
	_size += 1
	
func insert(value, index: int):
	_index_in_range(index, true)
	if index == 0:
		prepend(value)
	elif index == _size:
		append(value)
	else:
		var cur = _head
		var node = DoublyListNode.new(value)
		for i in index:
			cur = cur.next
		node.next = cur
		node.prev = cur.prev
		cur.prev.next = node
		cur.prev = node
		_size += 1
	
func contains(value) -> bool:
	var type = typeof(value)
	var cur = _head
	while cur != null:
		if type == typeof(cur.value) and cur.value == value:
			return true
		cur = cur.next
	return false
	
func get_value(index: int):
	if index < 0:
		index = _size + index
	
	_index_in_range(index)
	
	var midpoint = _size / 2
	if index < midpoint:
		var cur = _head
		for i in index:
			cur = cur.next
		return cur.value
	else:
		var cur = _tail
		for i in _size - index - 1:
			cur = cur.prev
		return cur.value
			
	
func pop_front():
	var value = _head.value
	_delete_node(_head)
	return value

func pop_back():
	var value = _tail.value
	_delete_node(_tail)
	return value

func delete(value): # Deletes the top most node containing the value if the value exists.
	var type = typeof(value)
	var cur = _head
	while cur != null:
		if type == typeof(cur.value) and cur.value == value:
			_delete_node(cur)
			return
		cur = cur.next
			
func delete_all_of(value): # Delets all nodes with this value if any exist.
	var type = typeof(value)
	var cur = _head
	while cur != null:
		if type == typeof(cur.value) and cur.value == value:
			_delete_node(cur)
		cur = cur.next
	
func _delete_node(node: DoublyListNode):
	if node == _head and node == _tail:
		_head = null
		_tail = null
	elif node == _head:
		_head = node.next
		if _head != null:
			_head.prev = null
	elif node == _tail:
		_tail = node.prev
		if _tail != null:
			_tail.next = null
	else:
		node.prev.next = node.next
		node.next.prev = node.prev
	_size -= 1
	
func is_empty():
	return _head == null	
	
func to_array() -> Array:
	var arr := []
	var cur = _head
	while cur != null:
		arr.append(cur.value)
		cur = cur.next
	return arr
	
func _index_in_range(index: int, include_next: bool = false):
	var condition
	if include_next:
		condition = index <= _size and index >= 0
	else:
		condition = index < _size and index >= 0
	assert(condition, "Index at " + str(index) + " is out of bounds of the DoublyLinkedList")
