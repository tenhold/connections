require_relative 'lib/connections'

# init game
game = Connections.new

# game time!
loop do
  puts 'what is your input?'
  input = gets.chomp.downcase

  case input
  when '-h'
    game.help
  when '-g'
    game.coords
  when '-b'
    game.print
  when '-s'
    game.submit
  when '-e'
    break
  else
    game.update(input)
  end
end
