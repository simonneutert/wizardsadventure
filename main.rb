$allowed_commands = %w[help look_around walk pick_up show_inventory exit_game]

$location = 'living-room'

$nodes = {}

$nodes['living-room'] = 'You are in the living-room. A wizard is snoring loudly on the couch.'
$nodes['garden'] = 'You are in a beautiful garden. There is a well in front of you.'
$nodes['attic'] = 'You are in the attic. There is a giant welding torch in the corner.'

$edges = {}

$edges['living-room'] = [
  %w[garden west door],
  %w[attic upstairs ladder]
]
$edges['garden'] = [
  ['living-room', 'east', 'door']
]
$edges['attic'] = [
  ['living-room', 'downstairs', 'ladder']
]

$objects = %w[whiskey bucket frog chain]

$object_locations = {}
$object_locations['whiskey'] = 'living-room'
$object_locations['bucket'] = 'living-room'
$object_locations['frog'] = 'garden'
$object_locations['chain'] = 'garden'

def describe_location
  puts $nodes[$location]
  nil
end

def describe_path
  $edges[$location].each do |edge|
    puts "There is a #{edge[2]} going #{edge[1]} from here."
  end
  nil
end

def describe_objects_at(loc = $location)
  obj_at_loc = []
  $objects.each do |obj|
    obj_at_loc << obj if $object_locations[obj] == loc
  end
  if obj_at_loc.empty?
    puts 'Nothing to pick up.'
  else
    puts "Objects: #{obj_at_loc.join(', a ')}"
  end
  nil
end

def help(str=nil)
  puts "Your commands are: #{$allowed_commands.join(', ')}"
  puts str if str and str.is_a? String
end

def look_around
  describe_location
  describe_path
  describe_objects_at
  nil
end

def walk(direction=nil)
  if $edges[$location].select { |e| e.include?(direction) }.empty?
    puts "I need a direction. Your options are: #{$edges[$location].map{|d| d[1]}.join(", ")}\n\n"
    look_around
  else
    $location = $edges[$location].select { |e| e.include?(direction) }.flatten[0]
    look_around
  end
  nil
end

def pick_up(object)
  # if object is in location
  # object location = "body"
  if $objects.include?(object) && $object_locations[object] == $location
    $object_locations[object] = 'body'
    puts "Picked up #{object}"
  else
    puts 'Sorry, not possible.'
  end
  nil
end

def show_inventory
  describe_objects_at 'body'
  nil
end

def exit_game
  exit
end

def game_eval(exp)
  exp = exp.split(' ')
  fun = exp[0]
  attri = exp[1]
  if $allowed_commands.include?(fun) && !attri.nil?
    send(fun, attri)
    return
  elsif $allowed_commands.include?(fun) && attri.nil?
    send(fun)
    return
  else
    puts 'Sorry, not possible. I do not know the command.'
  end
  nil
end

def game_repl
  puts ''
  input = gets.chomp
  puts ''
  # This is a desaster for security, I know ;)
  game_eval input
  puts ''
  game_repl
end

puts 'Get started'
help <<~MEM

  to get started:

  try \"walk west\"
  there \"pick_up frog\"
  then \"show_inventory\"
MEM

game_repl
