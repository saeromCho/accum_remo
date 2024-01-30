class Path {
  String path;
  String name;

  Path({required this.path, required this.name});
}

class RemoPath {
  static final Path login = Path(path: '/login', name: '/login');
  static final Path register = Path(path: 'register', name: 'register');
  static final Path memos = Path(path: 'memos', name: 'memos');
}
