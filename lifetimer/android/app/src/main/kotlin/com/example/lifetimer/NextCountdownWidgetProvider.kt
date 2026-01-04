package com.example.lifetimer

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.example.lifetimer.R
import es.antonborri.home_widget.HomeWidgetProvider

class NextCountdownWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val title = widgetData.getString("next_title", "Next goal")
            val subtitle = widgetData.getString("next_subtitle", "Open Lifetimer to see details")
            val timeLeft = widgetData.getString("next_time_left", "0 days left")

            val views = RemoteViews(context.packageName, R.layout.next_countdown_widget).apply {
                setTextViewText(R.id.text_title, title)
                setTextViewText(R.id.text_time_left, timeLeft)
                setTextViewText(R.id.text_subtitle, subtitle)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
