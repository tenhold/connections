require_relative '../lib/connections'

describe Connections do
  let(:game) { described_class.new }

  context '#board' do
    let(:option) { '00' }
    let(:word) { 'POPPY' }
    let(:selected_color) { "\e[0;39;106m#{word}\e[0m" }
    let(:col) { option.split('').map(&:to_i).first }
    let(:row) { option.split('').map(&:to_i).last }
    let(:selected_word) { game.board[col][row] }

    it 'should be a 4x4 matrix' do
      expect(game.board.class).to be(Array)
      expect(game.board.size).to eq(4)

      game.board.each do |row|
        expect(row.class).to be(Array)
        expect(row.size).to eq(4)
      end
    end

    it 'should select word' do
      game.update(option)

      expect(selected_word[:selected]).to be(true)
      expect(selected_word[:word]).to eq(selected_color)
    end

    it 'should unselect selected word' do
      # update same option twice
      game.update(option)
      game.update(option)

      expect(selected_word[:selected]).to be(false)
      expect(selected_word[:word]).to eq(word)
    end
  end

  context '#update' do
    it 'should only allow input from 00 to 33' do
      expect(game.update('00')).to be(true)
      expect(game.update('31')).to be(true)
      expect(game.update('nope')).to be(false)
    end
  end
end
