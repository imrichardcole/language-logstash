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
