class AppState {
  bool mutliSelect = false;

  AppState({this.mutliSelect});

  log() {
    print('multiSelect:$mutliSelect');
  }
}
