import 'package:flutter_test/flutter_test.dart';
import 'package:terminal_hero/domain/services/shell_engine.dart';

void main() {
  test('lists hidden files with ls -la', () {
    final engine = ShellEngine.seeded();

    final result = engine.run('ls -la');

    expect(result.success, isTrue);
    expect(result.output, contains('.clue'));
  });

  test('creates directories without executing a real shell', () {
    final engine = ShellEngine.seeded();

    final create = engine.run('mkdir lab');
    final list = engine.run('ls');

    expect(create.success, isTrue);
    expect(list.output, contains('lab'));
  });

  test('does not create an already existing directory', () {
    final engine = ShellEngine.seeded();

    final create = engine.run('mkdir logs');

    expect(create.success, isFalse);
    expect(create.output, contains('File exists'));
  });

  test('fails file operations for missing sources', () {
    final engine = ShellEngine.seeded();

    expect(engine.run('rm missing.txt').success, isFalse);
    expect(engine.run('cp missing.txt copy.txt').success, isFalse);
    expect(engine.run('mv missing.txt moved.txt').success, isFalse);
  });

  test('suggests known commands for typos', () {
    final engine = ShellEngine.seeded();

    final result = engine.run('lss');

    expect(result.success, isFalse);
    expect(result.suggestion, 'ls');
  });
}
