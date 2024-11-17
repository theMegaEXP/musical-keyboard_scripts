class_name Queue

var _head = null
var _tail = null
var _size = 0

func enqueue(value):
	var node = ListNode.new(value) 
	if _tail:
		_tail.next = node
	_tail = node
	if not _head:
		_head = _tail
	_size += 1
	
func dequeue():
	if is_empty():
		return null
	var front_value = _head.value
	_head = _head.next
	if _head == null:
		_tail = null
	_size -= 1
	return front_value
		
func peek():
	if is_empty():
		return null
	return _head.value
	
func is_empty():
	return _head == null
	
func size():
	return _size
