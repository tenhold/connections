require 'pry'
require 'colorize'
require 'terminal-table'

class Connections
  SELECTED = :light_blue

  CATAGORIES = [
    {words: %w(COIN CREATE DEVISE INVENT),
     category: '',
     color: :yellow},
    {words: %w(FINE PRIME QUALITY STERLING),
     category: '',
     color: :green},
    {words: %w(AT DOLLER PERCENT POUND),
     category: '',
     color: :blue},
    {words: %w(BAR BUCK TIME TORCH),
     category: '',
     color: :purple},
  ]

  attr_accessor :board

  def initialize
    board
    print
  end

  def board
    @board ||= [
      [{value: 'BAR', selected: false, locked: false},
       {value: 'AT', selected: false, locked: false},
       {value: 'PRIME', selected: false, locked: false},
       {value: 'COIN', selected: false, locked: false}],
      [{value: 'CREATE', selected: false, locked: false},
       {value: 'DEVISE', selected: false, locked: false},
       {value: 'INVENT', selected: false, locked: false},
       {value: 'QUALITY', selected: false, locked: false}],
      [{value: 'DOLLAR', selected: false, locked: false},
       {value: 'BUCK', selected: false, locked: false},
       {value: 'TIME', selected: false, locked: false},
       {value: 'POUND', selected: false, locked: false}],
      [{value: 'STERLING', selected: false, locked: false},
       {value: 'TORCH', selected: false, locked: false},
       {value: 'FINE', selected: false, locked: false},
       {value: 'PERCENT', selected: false, locked: false}],
    ]
  end

  # 00 = first row first ele
  # 33 = last row last ele
  def update(index)
    col, idx = index.split('').map(&:to_i)
    raise 'Out of Bounds' if col > 3 || idx > 3

    value, selected, locked = board[col][idx].values

    if locked
      print
      return
    end

    if selected
      board[col][idx].update(selected: !selected,
                             value: value.uncolorize)
    else
      board[col][idx].update(selected: !selected,
                             value: value.colorize(background: SELECTED))
    end

    print
  rescue => e
    puts "ERROR: #{e.message}"
  end

  def submit
    values = []
    board.each do |row|
      row.each do |ele|
        if ele[:selected]
          ele.update(selected: !ele[:selected],
                     value: ele[:value].uncolorize)
          values << ele
        end
      end
    end

    found = CATAGORIES.find { |c| values.map { |v| v[:value] }.sort == c[:words] }

    if found
      values.each do |v|
        v.update(value: v[:value].colorize(background: found[:color]), locked: true)
      end
    end

    print
  end

  def commands
    system 'clear'

    puts 'exit:       -e'
    puts 'help:       -h'
    puts 'submit:     -s'
    puts 'update val: 00 to 33'
  end

  def print
    system 'clear'
    table = Terminal::Table.new(title: 'connections') do |t|
      board.each_with_index do |row, i|
        t << row.map { |r| r[:value] }
        t << :separator unless i == board.size - 1
      end
    end

    puts table
  end
end

game = Connections.new

loop do
  puts 'what is your input?'
  input = gets.chomp

  break if input.downcase == '-e'
  if input.downcase == '-s'
    game.submit
    next
  end

  game.update(input)
end
