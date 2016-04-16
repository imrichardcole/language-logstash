'use babel';

import LanguageLogstashView from './language-logstash-view';
import { CompositeDisposable } from 'atom';

export default {

  languageLogstashView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.languageLogstashView = new LanguageLogstashView(state.languageLogstashViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.languageLogstashView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'language-logstash:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.languageLogstashView.destroy();
  },

  serialize() {
    return {
      languageLogstashViewState: this.languageLogstashView.serialize()
    };
  },

  toggle() {
    console.log('LanguageLogstash was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
