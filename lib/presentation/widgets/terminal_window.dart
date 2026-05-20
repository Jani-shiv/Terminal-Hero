import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class TerminalWindow extends StatelessWidget {
  const TerminalWindow({
    required this.lines,
    required this.cwd,
    required this.controller,
    required this.onSubmitted,
    required this.suggestions,
    this.onChanged,
    super.key,
  });

  final List<String> lines;
  final String cwd;
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String>? onChanged;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.neon.withValues(alpha: 0.24)),
      ),
      child: Column(
        children: [
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.panelAlt.withValues(alpha: 0.95),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: const Row(
              children: [
                _Dot(color: AppTheme.danger),
                SizedBox(width: 6),
                _Dot(color: AppTheme.amber),
                SizedBox(width: 6),
                _Dot(color: AppTheme.neon),
                Spacer(),
                Text('hero@training:~', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                for (final line in lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(line,
                        style: const TextStyle(
                            color: AppTheme.neon, height: 1.25)),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('hero:$cwd\$ ',
                        style: const TextStyle(color: AppTheme.cyan)),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        cursorColor: AppTheme.neon,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (suggestions.isNotEmpty)
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                scrollDirection: Axis.horizontal,
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return ActionChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(suggestion),
                    onPressed: () {
                      controller.text = suggestion;
                      controller.selection =
                          TextSelection.collapsed(offset: suggestion.length);
                      onChanged?.call(suggestion);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
