class ShellResult {
  const ShellResult({
    required this.output,
    this.path,
    this.success = true,
    this.suggestion,
  });

  final String output;
  final String? path;
  final bool success;
  final String? suggestion;
}

class ShellEngine {
  ShellEngine._(this._files, this._cwd);

  factory ShellEngine.seeded() {
    return ShellEngine._({
      '/home/hero': ['notes.txt', '.clue', 'deploy.sh', 'logs'],
      '/home/hero/logs': ['access.log', 'error.log'],
      '/etc': ['hosts', 'nginx'],
      '/var': ['log'],
    }, '/home/hero');
  }

  final Map<String, List<String>> _files;
  String _cwd;
  final List<String> history = [];

  String get cwd => _cwd;

  /// Routes user input through a simulated command table; no real shell is used.
  ShellResult run(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) return ShellResult(output: '', path: _cwd);

    history.add(input);
    final parts = input.split(RegExp(r'\s+'));
    final command = parts.first;
    final args = parts.skip(1).toList();

    return switch (command) {
      'pwd' => ShellResult(output: _cwd, path: _cwd),
      'ls' => _ls(args),
      'cd' => _cd(args),
      'mkdir' => _mkdir(args),
      'touch' => _touch(args),
      'rm' => _remove(args),
      'cp' => _copy(args),
      'mv' => _move(args),
      'cat' => _cat(args),
      'nano' => const ShellResult(
          output: 'nano opened in training mode. File saved on exit.'),
      'chmod' => _chmod(args),
      'grep' => _grep(args),
      'ps' => const ShellResult(
          output:
              'USER PID %CPU COMMAND\nhero 101 0.1 bash\nroot 318 2.4 backupd\nhero 404 0.7 dart'),
      'kill' => _kill(args),
      'ping' => _ping(args),
      'curl' => _curl(args),
      'ssh' => _ssh(args),
      'git' => _git(args),
      'clear' => const ShellResult(output: '__CLEAR__'),
      _ => ShellResult(
          output: '$command: command not found',
          path: _cwd,
          success: false,
          suggestion: _suggest(command),
        ),
    };
  }

  List<String> suggestions(String prefix) {
    const commands = [
      'ls',
      'cd',
      'pwd',
      'mkdir',
      'touch',
      'rm',
      'cp',
      'mv',
      'cat',
      'nano',
      'chmod',
      'grep',
      'ps',
      'kill',
      'ping',
      'curl',
      'ssh',
      'git status',
    ];
    if (prefix.trim().isEmpty) return commands.take(4).toList();
    return commands.where((cmd) => cmd.startsWith(prefix)).take(4).toList();
  }

  ShellResult _ls(List<String> args) {
    final includeHidden = args.any((arg) => arg.contains('a'));
    final long = args.any((arg) => arg.contains('l'));
    final entries = _files[_cwd] ?? [];
    final visible =
        entries.where((entry) => includeHidden || !entry.startsWith('.'));
    final output = long
        ? visible
            .map((entry) => '-rw-r--r-- hero hero  ${entry.padRight(12)}')
            .join('\n')
        : visible.join('  ');
    return ShellResult(output: output, path: _cwd);
  }

  ShellResult _cd(List<String> args) {
    if (args.isEmpty || args.first == '~') {
      _cwd = '/home/hero';
      return ShellResult(output: '', path: _cwd);
    }
    final target = _resolve(args.first);
    if (_files.containsKey(target)) {
      _cwd = target;
      return ShellResult(output: '', path: _cwd);
    }
    return ShellResult(
        output: 'cd: no such directory: ${args.first}',
        path: _cwd,
        success: false);
  }

  ShellResult _mkdir(List<String> args) {
    if (args.isEmpty) {
      return const ShellResult(
          output: 'mkdir: missing operand', success: false);
    }
    final name = args.first;
    final target = _resolve(name);
    if (_files.containsKey(target) || _entries(_cwd).contains(name)) {
      return ShellResult(
          output: 'mkdir: cannot create directory "$name": File exists',
          path: _cwd,
          success: false);
    }
    _files[target] = [];
    _files[_cwd] = {..._entries(_cwd), name}.toList();
    return ShellResult(output: 'created directory $name', path: _cwd);
  }

  ShellResult _touch(List<String> args) {
    if (args.isEmpty) {
      return const ShellResult(
          output: 'touch: missing file operand', success: false);
    }
    _files[_cwd] = {..._entries(_cwd), args.first}.toList();
    return ShellResult(output: 'created file ${args.first}', path: _cwd);
  }

  ShellResult _remove(List<String> args) {
    if (args.isEmpty) {
      return const ShellResult(output: 'rm: missing operand', success: false);
    }
    final target = args.last;
    if (!_entries(_cwd).contains(target)) {
      return ShellResult(
          output: 'rm: cannot remove "$target": No such file',
          path: _cwd,
          success: false);
    }
    _files[_cwd]?.remove(target);
    _files.remove(_resolve(target));
    return ShellResult(output: 'removed $target', path: _cwd);
  }

  ShellResult _copy(List<String> args) {
    if (args.length < 2) {
      return const ShellResult(
          output: 'cp: missing source or destination', success: false);
    }
    if (!_entries(_cwd).contains(args[0])) {
      return ShellResult(
          output: 'cp: cannot stat "${args[0]}": No such file',
          path: _cwd,
          success: false);
    }
    _files[_cwd] = {...?_files[_cwd], args[1]}.toList();
    return ShellResult(output: 'copied ${args[0]} to ${args[1]}', path: _cwd);
  }

  ShellResult _move(List<String> args) {
    if (args.length < 2) {
      return const ShellResult(
          output: 'mv: missing source or destination', success: false);
    }
    if (!_entries(_cwd).contains(args[0])) {
      return ShellResult(
          output: 'mv: cannot stat "${args[0]}": No such file',
          path: _cwd,
          success: false);
    }
    _files[_cwd]?.remove(args[0]);
    _files[_cwd] = {...?_files[_cwd], args[1]}.toList();
    return ShellResult(output: 'moved ${args[0]} to ${args[1]}', path: _cwd);
  }

  ShellResult _cat(List<String> args) {
    if (args.isEmpty) {
      return const ShellResult(
          output: 'cat: missing file operand', success: false);
    }
    final file = args.first;
    final output = switch (file) {
      '.clue' => 'MISSION_TOKEN=neon-penguin',
      'notes.txt' => 'Remember: hidden files begin with a dot.',
      'deploy.sh' => '#!/bin/bash\necho Deploying Terminal Hero',
      _ => 'cat: $file: No such file',
    };
    return ShellResult(
        output: output, path: _cwd, success: !output.contains('No such file'));
  }

  ShellResult _chmod(List<String> args) {
    if (args.length < 2) {
      return const ShellResult(
          output: 'chmod: missing mode or file', success: false);
    }
    return ShellResult(
        output: 'mode of ${args[1]} changed to ${args[0]}', path: _cwd);
  }

  ShellResult _grep(List<String> args) {
    if (args.length < 2) {
      return const ShellResult(
          output: 'grep: usage grep PATTERN FILE', success: false);
    }
    return ShellResult(
        output: '${args[1]}: matched "${args[0]}" on line 1', path: _cwd);
  }

  ShellResult _kill(List<String> args) {
    if (args.isEmpty) {
      return const ShellResult(
          output: 'kill: missing process id', success: false);
    }
    return ShellResult(output: 'sent SIGTERM to ${args.first}', path: _cwd);
  }

  ShellResult _ping(List<String> args) {
    final host = args.isEmpty ? 'localhost' : args.first;
    return ShellResult(
        output:
            'PING $host: 56 data bytes\n64 bytes from $host: ttl=64 time=8.2 ms',
        path: _cwd);
  }

  ShellResult _curl(List<String> args) {
    final url = args.isEmpty ? 'https://terminal.hero' : args.first;
    return ShellResult(
        output: 'HTTP/2 200\n{"status":"training-online","url":"$url"}',
        path: _cwd);
  }

  ShellResult _ssh(List<String> args) {
    if (args.isEmpty) {
      return const ShellResult(
          output: 'ssh: missing destination', success: false);
    }
    return ShellResult(
        output: 'Connected to ${args.first}. Training sandbox active.',
        path: _cwd);
  }

  ShellResult _git(List<String> args) {
    if (args.isNotEmpty && args.first == 'status') {
      return ShellResult(
          output: 'On branch main\nnothing to commit, working tree clean',
          path: _cwd);
    }
    return const ShellResult(
        output: 'git: try git status',
        success: false,
        suggestion: 'git status');
  }

  String _resolve(String path) {
    if (path.startsWith('/')) return path;
    if (path == '..') {
      final parts = _cwd.split('/')..removeLast();
      return parts.length <= 1 ? '/' : parts.join('/');
    }
    return '$_cwd/$path';
  }

  String? _suggest(String command) {
    const known = [
      'ls',
      'cd',
      'pwd',
      'mkdir',
      'touch',
      'cat',
      'chmod',
      'grep',
      'ps',
      'ping',
      'ssh'
    ];
    for (final item in known) {
      if (command.isNotEmpty && item.startsWith(command[0])) return item;
    }
    return null;
  }

  List<String> _entries(String path) => _files[path] ?? const [];
}
