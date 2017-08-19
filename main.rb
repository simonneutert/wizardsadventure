$allowed_commands = ["look", "walk", "pickup", "inventory"]

$location = "living-room"

$nodes = {}

$nodes["living-room"] = "You are in the living-room. A wizard is snoring loudly on the couch."
$nodes["garden"] = "You are in a beautiful garden. There is a well in front of you."
$nodes["attic"] = "You are in the attic. There is a giant welding torch in the corner."

$edges = {}

$edges["living-room"] = [
                          ["garden", "west", "door"],
                          ["attic", "upstairs", "ladder"]
                        ]
$edges["garden"] = [
                    ["living-room", "east", "door"]
                   ]
$edges["attic"] = [
                  ["living-room", "downstairs", "ladder"]
                  ]

$objects = ["whiskey", "bucket", "frog", "chain"]

$object_locations = {}
$object_locations["whiskey"] = "living-room"
$object_locations["bucket"] = "living-room"
$object_locations["frog"] = "garden"
$object_locations["chain"] = "garden"

def describe_location
  puts $nodes[$location]
  return
end

def describe_path
  $edges[$location].each do |edge|
    puts "There is a #{edge[2]} going #{edge[1]} from here."
  end
  return
end

def describe_objects_at(loc = $location)
  obj_at_loc = []
  $objects.each do |obj|
    obj_at_loc << obj if $object_locations[obj] == loc
  end
  if obj_at_loc.empty?
    puts "Nothing to pick up."
  else
    puts "Objects: #{obj_at_loc.join(', a ')}"
  end
  return
end

def look
  describe_location
  describe_path
  describe_objects_at
  return
end

def walk(direction)
  if $edges[$location].select { |e| e.include?(direction) }.empty?
    puts "Sorry not possible"
  else
    $location = $edges[$location].select { |e| e.include?(direction) }.flatten[0]
    look
  end
  return
end

def pickup(object)
  # if object is in location
  # object location = "body"
  if $objects.include?(object) && $object_locations[object] == $location
    $object_locations[object] = "body"
    puts "Picked up #{object}"
  else
    puts "Sorry, not possible."
  end
  return
end

def inventory
  describe_objects_at "body"
  return
end

def game_eval(exp)
  exp = exp.split(" ")
  fun = exp[0]
  attri = exp[1]
  if $allowed_commands.include?(fun) && !attri.nil?
    send(fun, attri)
    return
  elsif $allowed_commands.include?(fun) && attri.nil?
    send(fun)
    return
  else
    puts "Sorry, not possible. I do not know the command."
  end
  return
end

def game_repl
  puts ""
  input = gets.chomp
  puts ""
  # This is a desaster for security, I know ;)
  game_eval input
  puts ""
  game_repl
end

p "Get started"
p "Your commands: #{$allowed_commands.join(", ")}"
game_repl()
