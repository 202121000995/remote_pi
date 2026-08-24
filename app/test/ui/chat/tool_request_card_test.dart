import 'package:app/domain/session_state.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/protocol/protocol.dart';
import 'package:app/ui/chat/widgets/tool_request_card.dart';
import 'package:app/ui/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

const _bashTool = ToolEvent(
  id: 'tc1',
  toolCallId: 'tc1',
  tool: 'Bash',
  args: {'command': 'ls -la'},
);

const _editToolWithHunk = ToolEvent(
  id: 'tc2',
  toolCallId: 'tc4',
  tool: 'edit',
  args: {
    'path': 'app/test/ui/chat/tool_request_card_test.dart',
    'hunks': [
      {
        'lines': [
          {'kind': 'context', 'oldLine': 16, 'newLine': 16, 'text': 'args: {'},
          {'kind': 'remove', 'oldLine': 17, 'text': "  tool: 'Edit',"},
          {'kind': 'add', 'newLine': 17, 'text': "  tool: 'edit',"},
          {'kind': 'context', 'oldLine': 18, 'newLine': 18, 'text': '},'},
        ],
      },
    ],
  },
);

void main() {
  group('ToolRequestCard', () {
    testWidgets('shows tool name and command', (tester) async {
      await tester.pumpWidget(_wrap(const ToolRequestCard(tool: _bashTool)));
      expect(find.text('BASH'), findsOneWidget);
      expect(find.text('ls -la'), findsOneWidget);
    });

    testWidgets('edit renders rich hunks with context lines', (tester) async {
      await tester.pumpWidget(
        _wrap(const ToolRequestCard(tool: _editToolWithHunk)),
      );

      expect(
        find.textContaining('   16 args: {', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining("-  17   tool: 'Edit',", findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining("+  17   tool: 'edit',", findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('   18 },', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('pending bash without onDecide stays informational', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const ToolRequestCard(tool: _bashTool)));
      expect(find.text(appL10n.toolRunning), findsOneWidget);
      expect(find.text(appL10n.toolAllowOnce), findsNothing);
      expect(find.text(appL10n.toolAllowSession), findsNothing);
      expect(find.text(appL10n.toolAllowAlways), findsNothing);
      expect(find.text(appL10n.toolDeny), findsNothing);
      expect(find.textContaining('60s'), findsNothing);
    });

    testWidgets(
      'pending bash with onDecide shows scoped Allow/Deny actions',
      (tester) async {
        String? decidedId;
        ApproveDecision? decided;
        ApproveScope? scope;
        await tester.pumpWidget(
          _wrap(
            ToolRequestCard(
              tool: _bashTool,
              onDecide: (id, decision, nextScope) {
                decidedId = id;
                decided = decision;
                scope = nextScope;
              },
            ),
          ),
        );
        expect(find.text(appL10n.toolAwaiting), findsOneWidget);
        expect(find.text(appL10n.toolWaitingApproval), findsOneWidget);
        expect(find.text(appL10n.toolAllowOnce), findsOneWidget);
        expect(find.text(appL10n.toolAllowSession), findsOneWidget);
        expect(find.text(appL10n.toolAllowAlways), findsOneWidget);
        expect(find.text(appL10n.toolDeny), findsOneWidget);

        await tester.tap(find.text(appL10n.toolAllowOnce));
        await tester.pump();
        expect(decidedId, 'tc1');
        expect(decided, ApproveDecision.allow);
        expect(scope, ApproveScope.once);

        await tester.tap(find.text(appL10n.toolAllowSession));
        await tester.pump();
        expect(decided, ApproveDecision.allow);
        expect(scope, ApproveScope.session);

        await tester.tap(find.text(appL10n.toolAllowAlways));
        await tester.pump();
        expect(decided, ApproveDecision.allow);
        expect(scope, ApproveScope.always);

        await tester.tap(find.text(appL10n.toolDeny));
        await tester.pump();
        expect(decided, ApproveDecision.deny);
        expect(scope, ApproveScope.once);
      },
    );

    testWidgets('pending read-only tool never shows Allow/Deny', (
      tester,
    ) async {
      const read = ToolEvent(
        id: 'tc-read',
        toolCallId: 'tc-read',
        tool: 'Read',
        args: {'path': '/tmp/x'},
      );
      var called = false;
      await tester.pumpWidget(
        _wrap(ToolRequestCard(tool: read, onDecide: (_, _, _) => called = true)),
      );
      expect(find.text(appL10n.toolRunning), findsOneWidget);
      expect(find.text(appL10n.toolAllowOnce), findsNothing);
      expect(find.text(appL10n.toolDeny), findsNothing);
      expect(called, isFalse);
    });

    testWidgets('completed state shows DONE', (tester) async {
      const done = ToolEvent(
        id: 'tc1',
        toolCallId: 'tc1',
        tool: 'Bash',
        args: {'command': 'ls'},
        status: ToolEventStatus.completed,
      );
      await tester.pumpWidget(_wrap(const ToolRequestCard(tool: done)));
      expect(find.text(appL10n.toolDone), findsOneWidget);
      expect(find.textContaining(appL10n.toolOutcomeDone), findsAny);
    });

    testWidgets('denied state shows DENIED label', (tester) async {
      const denied = ToolEvent(
        id: 'tc1',
        toolCallId: 'tc1',
        tool: 'Bash',
        args: {'command': 'ls'},
        status: ToolEventStatus.denied,
        error: 'user denied',
      );
      await tester.pumpWidget(_wrap(const ToolRequestCard(tool: denied)));
      expect(find.text(appL10n.toolDenied), findsOneWidget);
    });

    testWidgets('allowed state shows RUNNING (still in flight)', (
      tester,
    ) async {
      const allowed = ToolEvent(
        id: 'tc1',
        toolCallId: 'tc1',
        tool: 'Bash',
        args: {'command': 'ls'},
        status: ToolEventStatus.allowed,
      );
      await tester.pumpWidget(_wrap(const ToolRequestCard(tool: allowed)));
      expect(find.text(appL10n.toolRunning), findsOneWidget);
      expect(find.text(appL10n.toolAllowOnce), findsNothing);
    });

    // Plan/32 — the card is colored by status: running blue, done green,
    // failed red. We assert the outcome line's color (the same _statusColor
    // drives the border / icon / tool name).
    Color? outcomeColor(WidgetTester tester, String text) =>
        tester.widget<Text>(find.text(text)).style?.color;

    testWidgets('completed → green "✓ Done"', (tester) async {
      const done = ToolEvent(
        id: 'tc1',
        toolCallId: 'tc1',
        tool: 'Bash',
        args: {'command': 'ls'},
        status: ToolEventStatus.completed,
      );
      await tester.pumpWidget(_wrap(const ToolRequestCard(tool: done)));
      expect(
        outcomeColor(tester, appL10n.toolOutcomeDone),
        AppColors.dark.success,
      );
    });

    testWidgets('failed → red "✗ {error}" + FAILED label', (tester) async {
      const failed = ToolEvent(
        id: 'tc1',
        toolCallId: 'tc1',
        tool: 'Bash',
        args: {'command': 'exit 1'},
        status: ToolEventStatus.failed,
        error: 'command failed: exit 1',
      );
      await tester.pumpWidget(_wrap(const ToolRequestCard(tool: failed)));
      expect(find.text(appL10n.toolFailed), findsOneWidget);
      expect(
        outcomeColor(tester, '✗ command failed: exit 1'),
        AppColors.dark.error,
      );
    });

    testWidgets('running → blue "⏳ Running…"', (tester) async {
      // pending defaults
      await tester.pumpWidget(_wrap(const ToolRequestCard(tool: _bashTool)));
      expect(
        outcomeColor(tester, appL10n.toolRunningEllipsis),
        AppColors.dark.accent,
      );
    });
  });
}
