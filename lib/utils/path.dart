class Path {
  String path;
  String name;

  Path({required this.path, required this.name});
}

class RemoPath {
  static final Path splash = Path(path: '/splash', name: '/splash');
  static final Path login = Path(path: 'login', name: 'login');
  static final Path register = Path(path: 'register', name: 'register');
  static final Path memos = Path(path: 'memos', name: 'memos');
  static final Path webview = Path(path: 'webview', name: 'webview');
  static final Path memoWrite = Path(path: 'memo_write', name: 'memo_write');
  static final Path memoDetail = Path(path: 'memo_detail', name: 'memo_detail');
  static final Path memoEdit = Path(path: 'memo_edit', name: 'memo_edit');
}
