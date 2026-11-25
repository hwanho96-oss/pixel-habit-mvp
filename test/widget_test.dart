import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit_mvp/main.dart';
import 'package:pixel_habit_mvp/providers/app_state.dart';
import 'package:pixel_habit_mvp/data/storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app builds', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(AppStorage());
    await state.load();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const PixelHabitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PixelHabitApp), findsOneWidget);
  });
}
