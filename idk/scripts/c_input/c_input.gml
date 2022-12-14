function c_input() {
	var i;
	var inputs = variable_struct_get_names(global.inputs);
	for (i=0; i<array_length(inputs); i++) {
		global.inputs[$inputs[i]].update();
		variable_instance_set(id, inputs[i], global.inputs[$inputs[i]]);
	} //yeah you heard me this only works on gameobjects
	
	//these guys are compounds that are per-instance of c_input
	select = jump.hit;
	back = attack.hit;
	undo = ctrl.hold & zed.hit;
	reload = lock;
}

function c_inputload() {
	nu kinput("left", ["A", vk_left]);
	nu kinput("down", ["S", vk_down]);
	nu kinput("up", ["W", vk_up]);
	nu kinput("right", ["D", vk_right]);
	
	nu kinput("jump", ["Z", mb_right]);
	nu kinput("attack", ["X", mb_left]);
	nu kinput("lock", ["C", "R"]);
	nu kinput("debug", ["F"]);
	nu kinput("shift", [vk_shift]);
	nu kinput("inventory", ["Q"]);
	
	nu kinput("ctrl", [vk_control]);
	nu kinput("zed", ["Z"]);
}

function kinput(name_, keys_) constructor {
	name = name_;
	key = keys_;
	hit = 0;
	hold = 0;
	drop = 0;
	update = function() {
		var i;
		hit = false;
		hold = false;
		drop = false;
		for (i=0; i<array_length(key); i++) {
			hit |= input_active(key[i], INPUT.PRESSED);
			hold |= input_active(key[i], INPUT.HELD);
			drop |= input_active(key[i], INPUT.RELEASED);
		}
	}
	global.inputs[$name] = self;
}

global.inputs = {};
c_inputload();



/*update = function() {
	if typeof(key) == "string" {
		hit = (hit+keyboard_check_pressed(ord(key)))*keyboard_check_pressed(ord(key));
		hold = (hold+keyboard_check(ord(key)))*keyboard_check(ord(key));
		drop = (drop+!(keyboard_check(ord(key))))*(!keyboard_check(ord(key)));
	} else {
		hit = (hit+keyboard_check_pressed(key))*keyboard_check_pressed(key); //if you can somehow hit two in a row. for buffering, maybe?
		hold = (hold+keyboard_check(key))*keyboard_check(key);
		drop = (drop+!(keyboard_check(key)))*(!keyboard_check(key)); //released is a joke
	}
}*/
	
	//problem: things will go twice as fast if multiple c_inputs at running at once
	//solution: the things increasing over one are an extreme edge case to begin with and you probably arent worrying about them when you have multiple controllables, if that is ever a good idea