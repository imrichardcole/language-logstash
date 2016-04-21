describe "Logstash grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-logstash")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.logstash")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.logstash"

  describe "separators", ->
    it "tokenizes attribute separator", ->
      {tokens} = grammar.tokenizeLine("beats {")
      expect(tokens[0]).toEqual value: 'beats', scopes: ['source.logstash', 'text.logstash', 'entity.name.function.logstash']

    it "tokenizes if statement", ->
      {tokens} = grammar.tokenizeLine("if \"apache\" in [tags]")
      expect(tokens[0]).toEqual value: 'if', scopes: ['source.logstash', 'keyword.control.logstash']
      expect(tokens[2]).toEqual value: '"apache"', scopes: ['source.logstash', 'string.text.logstash']
      expect(tokens[4]).toEqual value: 'in', scopes: ['source.logstash', 'keyword.operator.logstash']
      expect(tokens[6]).toEqual value: 'tags', scopes: ['source.logstash', 'entity.name.function.logstash']

    it "tokensizes number variables on same line", ->
      {tokens} = grammar.tokenizeLine("port => 1223")
      expect(tokens[0]).toEqual value: 'port', scopes: ['source.logstash', 'variable.text.logstash']
      expect(tokens[2]).toEqual value: '=>', scopes: ['source.logstash', 'keyword.operator.logstash']
      expect(tokens[4]).toEqual value: '1223', scopes: ['source.logstash', 'constant.numeric.logstash']
    it "tokensizes number variables on same line with {}", ->
      {tokens} = grammar.tokenizeLine("beats { port => 1223 }")
      expect(tokens.length).toEqual 8
      expect(tokens[0]).toEqual value: 'port', scopes: ['source.logstash', 'single.line.number.variable.logstash', 'variable.text.logstash']
      expect(tokens[1]).toEqual value: 'port', scopes: ['source.logstash', 'single.line.number.variable.logstash', 'variable.text.logstash']
      expect(tokens[3]).toEqual value: '=>', scopes: ['source.logstash', 'single.line.number.variable.logstash', 'keyword.operator.logstash']
      expect(tokens[5]).toEqual value: '1223', scopes: ['source.logstash', 'single.line.number.variable.logstash', 'constant.numeric.logstash']
