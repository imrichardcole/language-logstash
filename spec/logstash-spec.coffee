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
      {tokens} = grammar.tokenizeLine('ensure => present')
      expect(tokens[1]).toEqual value: '=>', scopes: ['source.puppet', 'punctuation.separator.key-value.puppet']

    it "tokenizes attribute separator with string values", ->
      {tokens} = grammar.tokenizeLine('ensure => "present"')
      expect(tokens[1]).toEqual value: '=>', scopes: ['source.puppet', 'punctuation.separator.key-value.puppet']
