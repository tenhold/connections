require 'pry'
require 'yaml'
require 'colorize'
require 'terminal-table'

class Connections
  SELECTED = :light_cyan
  STYLE = {
    title: 'connections',
    style: { alignment: :center, width: 60, all_separators: true }
  }

  CATAGORIES = [
    { words: %w(COIN CREATE DEVISE INVENT),
      category: '',
      color: :yellow },
    { words: %w(FINE PRIME QUALITY STERLING),
      category: '',
      color: :green },
    { words: %w(AT DOLLER PERCENT POUND),
      category: '',
      color: :blue },
    { words: %w(BAR BUCK TIME TORCH),
      category: '',
      color: :magenta },
  ]

  attr_accessor :board

  def initialize
    @data ||= YAML.load_file('games.yaml', symbolize_names: true)
    build_board
    print
  end

  def build_board
    defaults = { selected: false, locked: false }
    @board ||= []
    @data[:words].each_slice(4) do |word_slice|
      @board << word_slice.map { |word| { word: word }.merge(defaults) }
    end

    # @board ||= [
    #   [{ word: 'BAR', selected: false, locked: false },
    #    { word: 'AT', selected: false, locked: false },
    #    { word: 'PRIME', selected: false, locked: false },
    #    { word: 'COIN', selected: false, locked: false }],
    #   [{ word: 'CREATE', selected: false, locked: false },
    #    { word: 'DEVISE', selected: false, locked: false },
    #    { word: 'INVENT', selected: false, locked: false },
    #    { word: 'QUALITY', selected: false, locked: false }],
    #   [{ word: 'DOLLAR', selected: false, locked: false },
    #    { word: 'BUCK', selected: false, locked: false },
    #    { word: 'TIME', selected: false, locked: false },
    #    { word: 'POUND', selected: false, locked: false }],
    #   [{ word: 'STERLING', selected: false, locked: false },
    #    { word: 'TORCH', selected: false, locked: false },
    #    { word: 'FINE', selected: false, locked: false },
    #    { word: 'PERCENT', selected: false, locked: false }],
    # ]
  end

  # 00 = first row first ele
  # 33 = last row last ele
  def update(index)
    raise 'Out of Bounds' unless index.match?(/[0-3]{2}/)

    col, idx = index.split('').map(&:to_i)
    word, selected, locked = board[col][idx].values

    if locked
      print
      return false
    end

    if selected
      board[col][idx].update(selected: !selected,
                             word: word.uncolorize)
    else
      board[col][idx].update(selected: !selected,
                             word: word.colorize(background: SELECTED))
    end

    print
    true
  rescue => e
    puts "ERROR: #{e.message}"
    false
  end

  def truth
    true
  end

  def submit
    words = []
    board.each do |row|
      row.each do |ele|
        if ele[:selected]
          ele.update(selected: !ele[:selected],
                     word: ele[:word].uncolorize)
          words << ele
        end
      end
    end

    found = CATAGORIES.find { |c| words.map { |v| v[:word] }.sort == c[:words] }

    if found
      words.each do |v|
        v.update(word: v[:word].colorize(background: found[:color]), locked: true)
      end
    end

    print
  end

  def help
    system 'clear'

    table = Terminal::Table.new(STYLE) do |t|
      t << %w(help -h)
      t << %w(exit -e)
      t << %w(submit -s)
      t << %w(grid -g)
      t << %w(board -b)
      t << %w(select_words 00)
    end

    puts table
  end

  def print
    system 'clear'
    table = Terminal::Table.new(STYLE) do |t|
      board.each_with_index do |row, i|
        t << row.map { |r| r[:word] }
      end
    end

    puts table
  end

  def coords
    system 'clear'

    grid = 4
    table = Terminal::Table.new(STYLE) do |t|
      grid.times do |i|
        row = []
        grid.times do |j|
          row << "#{i}#{j}"
        end
        t << row
      end
    end
  puts table
  end
end
