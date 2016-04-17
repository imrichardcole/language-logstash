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
