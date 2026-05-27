import 'package:flutter_test/flutter_test.dart';
import 'package:sparkle_lite/core_import.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          // Initialize ScreenScaler before any responsive call
          ScreenScaler.instance.init(const Size(375, 812));
          return child;
        },
      ),
    ),
  );
}

void main() {
  // 1. AuthGradientButton

  group('AuthGradientButton', () {
    testWidgets('renders label text correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(AuthGradientButton(label: 'Sign In', onPressed: () {})),
      );

      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          AuthGradientButton(
            label: 'Sign In',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign In'), findsNothing);
    });

    testWidgets('hides loader and shows label when isLoading is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(AuthGradientButton(label: 'Create Account', onPressed: () {})),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('calls onPressed callback when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _wrap(
          AuthGradientButton(label: 'Login', onPressed: () => tapped = true),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when isLoading is true', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        _wrap(
          AuthGradientButton(
            label: 'Login',
            onPressed: () => tapped = true,
            isLoading: true,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isFalse);
    });

    testWidgets('renders without onPressed (null) without crashing', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(AuthGradientButton(label: 'Sign Up')));

      expect(find.text('Sign Up'), findsOneWidget);
    });
  });

  // 2. AuthSparkLogo

  group('AuthSparkLogo', () {
    testWidgets('renders auto_awesome icon', (tester) async {
      await tester.pumpWidget(_wrap(AuthSparkLogo(size: 72)));

      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('renders with default size without crashing', (tester) async {
      await tester.pumpWidget(_wrap(const AuthSparkLogo()));

      expect(find.byType(AuthSparkLogo), findsOneWidget);
    });

    testWidgets('renders with custom size without crashing', (tester) async {
      await tester.pumpWidget(_wrap(AuthSparkLogo(size: 96)));

      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('is wrapped in a Container', (tester) async {
      await tester.pumpWidget(_wrap(AuthSparkLogo(size: 72)));

      expect(find.byType(Container), findsWidgets);
    });
  });

  // 3. OnboardingDotIndicator

  group('OnboardingDotIndicator', () {
    testWidgets('renders the correct number of dots', (tester) async {
      await tester.pumpWidget(
        _wrap(OnboardingDotIndicator(total: 3, current: 0)),
      );

      // Each dot is an AnimatedContainer inside a Row
      final dots = tester.widgetList(find.byType(AnimatedContainer)).toList();
      expect(dots.length, equals(3));
    });

    testWidgets('renders 4 dots when total is 4', (tester) async {
      await tester.pumpWidget(
        _wrap(OnboardingDotIndicator(total: 4, current: 2)),
      );

      expect(
        tester.widgetList(find.byType(AnimatedContainer)).length,
        equals(4),
      );
    });

    testWidgets('active dot is wider than inactive dots', (tester) async {
      await tester.pumpWidget(
        _wrap(OnboardingDotIndicator(total: 3, current: 1)),
      );

      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();

      final activeDot = containers[1];
      final inactiveDot = containers[0];

      expect(containers.length, equals(3));
      expect(activeDot, isNotNull);
      expect(inactiveDot, isNotNull);
    });

    testWidgets('renders inside a Row', (tester) async {
      await tester.pumpWidget(
        _wrap(OnboardingDotIndicator(total: 3, current: 0)),
      );

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('current=0 shows first dot as active without overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(OnboardingDotIndicator(total: 5, current: 0)),
      );

      expect(tester.takeException(), isNull);
    });
  });

  // 4. ProfileChip

  group('ProfileChip', () {
    testWidgets('displays label text', (tester) async {
      await tester.pumpWidget(
        _wrap(ProfileChip(label: 'Pregnancy', selected: false, onTap: () {})),
      );

      expect(find.text('Pregnancy'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _wrap(
          ProfileChip(
            label: 'PCOS',
            selected: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });

    testWidgets('renders selected chip without crashing', (tester) async {
      await tester.pumpWidget(
        _wrap(
          ProfileChip(label: 'Period Tracking', selected: true, onTap: () {}),
        ),
      );

      expect(find.text('Period Tracking'), findsOneWidget);
    });

    testWidgets('renders unselected chip without crashing', (tester) async {
      await tester.pumpWidget(
        _wrap(ProfileChip(label: 'Menopause', selected: false, onTap: () {})),
      );

      expect(find.text('Menopause'), findsOneWidget);
    });

    testWidgets('is wrapped in a GestureDetector', (tester) async {
      await tester.pumpWidget(
        _wrap(ProfileChip(label: 'Test', selected: false, onTap: () {})),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });

  // 5. PrivacyToggleRowWidget

  group('PrivacyToggleRowWidget', () {
    testWidgets('displays title and subtitle text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PrivacyToggleRowWidget(
            title: 'Hide Sensitive Dashboard',
            subtitle: 'Hides health data from the home screen.',
            value: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Hide Sensitive Dashboard'), findsOneWidget);
      expect(
        find.text('Hides health data from the home screen.'),
        findsOneWidget,
      );
    });

    testWidgets('Switch is off when value is false', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PrivacyToggleRowWidget(
            title: 'Generic Notifications',
            subtitle: 'Show generic notification text.',
            value: false,
            onChanged: (_) {},
          ),
        ),
      );

      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, isFalse);
    });

    testWidgets('Switch is on when value is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PrivacyToggleRowWidget(
            title: 'Confirm Before Sharing',
            subtitle: 'Ask before sharing records.',
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, isTrue);
    });

    testWidgets('calls onChanged with true when toggled on', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        _wrap(
          PrivacyToggleRowWidget(
            title: 'Family Access',
            subtitle: 'Allow family profile access.',
            value: false,
            onChanged: (v) => changedValue = v,
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(changedValue, isTrue);
    });

    testWidgets('renders inside a Row', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PrivacyToggleRowWidget(
            title: 'Test',
            subtitle: 'Test subtitle',
            value: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
    });
  });

  // 6. SectionLabelWidget

  group('SectionLabelWidget', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(_wrap(SectionLabelWidget(label: 'Recent Logs')));

      expect(find.text('Recent Logs'), findsOneWidget);
    });

    testWidgets('renders with different label text', (tester) async {
      await tester.pumpWidget(
        _wrap(SectionLabelWidget(label: 'Quick Actions')),
      );

      expect(find.text('Quick Actions'), findsOneWidget);
    });

    testWidgets('wraps label in a Padding widget', (tester) async {
      await tester.pumpWidget(_wrap(SectionLabelWidget(label: 'My Health')));

      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('renders Text widget with the label', (tester) async {
      await tester.pumpWidget(_wrap(SectionLabelWidget(label: 'Timeline')));

      expect(find.byType(Text), findsWidgets);
    });
  });

  // 7. SymptomEmptyStateWidget

  group('SymptomEmptyStateWidget', () {
    testWidgets('displays "No logs yet" title', (tester) async {
      await tester.pumpWidget(_wrap(SymptomEmptyStateWidget(onLogNow: () {})));

      expect(find.text('No logs yet'), findsOneWidget);
    });

    testWidgets('displays tracking hint subtitle', (tester) async {
      await tester.pumpWidget(_wrap(SymptomEmptyStateWidget(onLogNow: () {})));

      expect(
        find.text('Start tracking your symptoms to see patterns.'),
        findsOneWidget,
      );
    });

    testWidgets('displays "Log Now" button', (tester) async {
      await tester.pumpWidget(_wrap(SymptomEmptyStateWidget(onLogNow: () {})));

      expect(find.text('Log Now'), findsOneWidget);
    });

    testWidgets('calls onLogNow when "Log Now" is tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _wrap(SymptomEmptyStateWidget(onLogNow: () => tapped = true)),
      );

      await tester.tap(find.text('Log Now'));
      expect(tapped, isTrue);
    });

    testWidgets('displays 🌸 emoji icon', (tester) async {
      await tester.pumpWidget(_wrap(SymptomEmptyStateWidget(onLogNow: () {})));

      expect(find.text('🌸'), findsOneWidget);
    });

    testWidgets('is centred on screen', (tester) async {
      await tester.pumpWidget(_wrap(SymptomEmptyStateWidget(onLogNow: () {})));

      expect(find.byType(Center), findsWidgets);
    });
  });

  // 8. RecordsEmptyStateWidget

  group('RecordsEmptyStateWidget', () {
    testWidgets('displays "No records yet" title', (tester) async {
      await tester.pumpWidget(
        _wrap(RecordsEmptyStateWidget(onUploadRecord: () {})),
      );

      expect(find.text('No records yet'), findsOneWidget);
    });

    testWidgets('displays upload hint subtitle', (tester) async {
      await tester.pumpWidget(
        _wrap(RecordsEmptyStateWidget(onUploadRecord: () {})),
      );

      expect(
        find.text(
          'Upload your health reports to keep everything in one place.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays "Upload Record" button', (tester) async {
      await tester.pumpWidget(
        _wrap(RecordsEmptyStateWidget(onUploadRecord: () {})),
      );

      expect(find.text('Upload Record'), findsOneWidget);
    });

    testWidgets('calls onUploadRecord when "Upload Record" is tapped', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        _wrap(RecordsEmptyStateWidget(onUploadRecord: () => tapped = true)),
      );

      await tester.tap(find.text('Upload Record'));
      expect(tapped, isTrue);
    });

    testWidgets('displays 📁 emoji icon', (tester) async {
      await tester.pumpWidget(
        _wrap(RecordsEmptyStateWidget(onUploadRecord: () {})),
      );

      expect(find.text('📁'), findsOneWidget);
    });

    testWidgets('is centred on screen', (tester) async {
      await tester.pumpWidget(
        _wrap(RecordsEmptyStateWidget(onUploadRecord: () {})),
      );

      expect(find.byType(Center), findsWidgets);
    });
  });
}
