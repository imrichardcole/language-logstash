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

  describe "grammar", ->

    it "can pick up keywords", ->
      {tokens} = grammar.tokenizeLine("input ")
      expect(tokens.length).toBe 2
      expect(tokens[0]).toEqual value: 'input', scopes: ['source.logstash', 'entity.name.type.class.logstash']

    it "can pick up functions", ->
      {tokens} = grammar.tokenizeLine("beats {")
      expect(tokens.length).toBe 2
      expect(tokens[0]).toEqual value: 'beats', scopes: ['source.logstash', 'entity.name.function.logstash']

    it "can pick up text variable", ->
      {tokens} = grammar.tokenizeLine("file => \"sample\"")
      expect(tokens.length).toBe 5
      expect(tokens[0]).toEqual value: 'file', scopes: ['source.logstash', 'variable.text.logstash']
      expect(tokens[2]).toEqual value: '=>', scopes: ['source.logstash', 'keyword.operator.logstash']
      expect(tokens[4]).toEqual value: '"sample"', scopes: ['source.logstash', 'string.text.logstash']

    it "cant pick up number variable", ->
      {tokens} = grammar.tokenizeLine("port => 1223")
      expect(tokens[0]).toEqual value: 'port', scopes: ['source.logstash', 'variable.text.logstash']
      expect(tokens[2]).toEqual value: '=>', scopes: ['source.logstash', 'keyword.operator.logstash']
      expect(tokens[4]).toEqual value: '1223', scopes: ['source.logstash', 'constant.numeric.logstash']

    it "can pick up if statement", ->
      {tokens} = grammar.tokenizeLine("if \"apache\" in [tags]")
      expect(tokens[0]).toEqual value: 'if', scopes: ['source.logstash', 'keyword.control.logstash']
      expect(tokens[2]).toEqual value: '"apache"', scopes: ['source.logstash', 'string.text.logstash']
      expect(tokens[4]).toEqual value: 'in', scopes: ['source.logstash', 'keyword.operator.logstash']
      expect(tokens[7]).toEqual value: 'tags', scopes: ['source.logstash', 'entity.name.function.logstash']

    it "cant pick up number variable all on one line", ->
      {tokens} = grammar.tokenizeLine("beats { port => 1223 }")
      expect(tokens.length).toBe 9
      expect(tokens[0]).toEqual value: 'beats', scopes: ['source.logstash', 'entity.name.function.logstash']
      expect(tokens[3]).toEqual value: 'port', scopes: ['source.logstash', 'variable.text.logstash']
      expect(tokens[5]).toEqual value: '=>', scopes: ['source.logstash', 'keyword.operator.logstash']
      expect(tokens[7]).toEqual value: '1223', scopes: ['source.logstash', 'constant.numeric.logstash']

    it "if with many conditions", ->
      {tokens} = grammar.tokenizeLine("if [client_ip] == \"123.123.123.123\" or [client_ip] == \"122.122.122.122\"")
      expect(tokens[0]).toEqual value: 'if', scopes: ['source.logstash', 'keyword.control.logstash']
      expect(tokens[3]).toEqual value: 'client_ip', scopes: ['source.logstash', 'entity.name.function.logstash']
      expect(tokens[6]).toEqual value: '==', scopes: ['source.logstash', 'keyword.operator.logstash']
      expect(tokens[8]).toEqual value: "\"123.123.123.123\"", scopes: ['source.logstash', 'string.text.logstash']
      expect(tokens[11]).toEqual value: 'client_ip', scopes: ['source.logstash', 'entity.name.function.logstash']
      expect(tokens[14]).toEqual value: '==', scopes: ['source.logstash', 'keyword.operator.logstash']
      expect(tokens[16]).toEqual value: "\"122.122.122.122\"", scopes: ['source.logstash', 'string.text.logstash']

    it "if with special character", ->
      {tokens} = grammar.tokenizeLine("if [@client_ip]")
      expect(tokens[0]).toEqual value: 'if', scopes: ['source.logstash', 'keyword.control.logstash']
      expect(tokens[3]).toEqual value: '@client_ip', scopes: ['source.logstash', 'entity.name.function.logstash']
