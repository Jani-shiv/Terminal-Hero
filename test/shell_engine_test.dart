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

  test('suggests known commands for typos', () {
    final engine = ShellEngine.seeded();

    final result = engine.run('lss');

    expect(result.success, isFalse);
    expect(result.suggestion, 'ls');
  });
}
