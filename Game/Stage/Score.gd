extends RichTextLabel

var score: int = 0
var good_hits: int = 0
var multiplier: int = 1

func increase_score(amount: int = 5):
	if good_hits > 30:
		multiplier = 8
	elif good_hits > 20:
		multiplier = 4
	elif good_hits > 10:
		multiplier = 2
	else:
		multiplier = 1
	
	score += amount * multiplier
	set_score_text()
	
func hit(key_state: Enums.KeyState = Enums.KeyState.POOR):
	match key_state:
		Enums.KeyState.POOR:	
			good_hits += 1
			increase_score(1)
		Enums.KeyState.GOOD:
			good_hits += 1
			increase_score(2)
		Enums.KeyState.GREAT:
			good_hits += 1
			increase_score(3)
		Enums.KeyState.EXCELLENT:
			good_hits += 1
			increase_score(5)
		_:
			reset_good_hits()
			
func reset_good_hits():
	good_hits = 0
	
func set_score_text():
	text = "[b]Score: [/b]" + str(score)
	
	
