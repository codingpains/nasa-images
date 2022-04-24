require './input-parser'
require './errors'

describe InputParser do
  describe '#parse' do

    it 'parses minimum correct input' do
      args = ['rover=curiosity', 'cam=NAVCAM']
      parser = InputParser.new(args)
      expect(parser.parse).to include(:rover => 'curiosity', :cam => 'NAVCAM')
    end

    it 'raises error with invalid argument names' do
      args = ['iminvalid=yes', 'cam=NAVCAM']
      parser = InputParser.new(args)
      expect { parser.parse }.to raise_error(BadInputError)
    end

    it 'turns asof into time' do
      args = ['rover=curiosity', 'cam=NAVCAM', 'asof=2022-04-23']
      parser = InputParser.new(args)
      expect(parser.parse[:asof]).to be_an_instance_of(Time)
    end
  end
end