
# Dependencies

IconProxy = require('../lib/icon-proxy').IconProxy

icon = new IconProxy()

describe 'IconProxy', () ->
  describe '#init()', () ->
    icon.init source: '../prod/firefox.png'
    it 'should have icon source', () ->
      icon.should.have.property('iconSource')
    it 'should have implementation reference', () ->
      icon.should.have.property('impl')
  
  describe '#readFile()', () ->
    icon.readFile()
    it 'should have icon source', () ->
      icon.should.have.property('iconSource')

describe 'Array', () ->
  describe '#indexOf()', () ->
    it 'should return -1 when the value is not present', () ->
      [1,2,3].indexOf(5).should.equal(-1)
      [1,2,3].indexOf(0).should.equal(-1)