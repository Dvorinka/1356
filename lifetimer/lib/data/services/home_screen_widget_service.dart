import 'package:home_widget/home_widget.dart';

class HomeScreenWidgetService {
  static const androidWidgetProvider = 'NextCountdownWidgetProvider';

  Future<void> updateNextCountdownWidget({
    required String title,
    required String timeLeft,
    String? subtitle,
  }) async {
    await HomeWidget.saveWidgetData<String>('next_title', title);
    await HomeWidget.saveWidgetData<String>('next_time_left', timeLeft);
    if (subtitle != null) {
      await HomeWidget.saveWidgetData<String>('next_subtitle', subtitle);
    }

    await HomeWidget.updateWidget(name: androidWidgetProvider);
  }
}
