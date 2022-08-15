package com.cms.easy_event;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.provider.CalendarContract;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import java.util.Map;
import java.util.TimeZone;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * EasyEventPlugin
 */
public class EasyEventPlugin implements FlutterPlugin, MethodCallHandler {

    private final Uri CALENDAR_URL = CalendarContract.Calendars.CONTENT_URI;
    private final Uri CALENDAR_EVENT_URL = CalendarContract.Events.CONTENT_URI;
    private final Uri CALENDAR_REMINDER_URL = CalendarContract.Reminders.CONTENT_URI;


    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "easy_event");
        channel.setMethodCallHandler(this);
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + Build.VERSION.RELEASE);
                break;
            case "test":
                result.success("message from Android");
                break;
            case "addEventCalendar":

                if (!(call.arguments instanceof Map)) {
                    result.error("-1", "arguments is not correct", "arguments is " + call.arguments);
                    return;
                }

                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;

                String title = (String) args.get("title");
                if (title == null || title.isEmpty()) {
                    result.error("-2", "arguments title is null", "arguments is " + call.arguments);
                    return;
                }

                if (!(args.get("colorRGB") instanceof Map)) {
                    result.error("-3", "arguments colorRGB is not Correct #1", "arguments is " + call.arguments);
                    return;
                }

                @SuppressWarnings("unchecked")
                Map<String, Integer> colorRGB = (Map<String, Integer>) args.get("colorRGB");
                assert colorRGB != null;
                Integer red = colorRGB.get("red");
                Integer green = colorRGB.get("green");
                Integer blue = colorRGB.get("blue");

                if (red == null || green == null || blue == null) {
                    result.error("-4", "arguments colorRGB is not Correct #2", "red is "+ red +" green is "+ green +" blue is " + blue);
                    return;
                }

                if (red < 0 || red > 255 || green < 0 || green > 255 || blue < 0 || blue > 255) {
                    result.error("-5", "arguments colorRGB is not Correct #3", "red is "+ red +" green is "+ green +" blue is " + blue);
                    return;
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    addEventCalendar(title, Color.valueOf(red, green, blue), result);
                    result.success(false);
                }

                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void addEventCalendar(String title, Color color, Result result) {

        if (checkPermission()) {

            addCalendarAccount();
            int oldId = checkCalendarAccount();
//            if (oldId >= 0) {
//
//            } else {
//                long addId = addCalendarAccount();
//                if (addId >= 0) {
//                    checkCalendarAccount();
//                }
//            }

            deleteCalendarAccount();
        }
    }

    @SuppressLint("Range")
    private void deleteCalendarAccount() {
        Cursor userCursor = flutterPluginBinding.getApplicationContext().getContentResolver().query(CALENDAR_URL,
                null, null, null, null);
        while (userCursor.moveToNext()) {
             Uri calendarUri = CALENDAR_URL.buildUpon()
                    .appendQueryParameter(CalendarContract.Calendars.ACCOUNT_NAME, "calendar@localhost.com")
                    .build();

            flutterPluginBinding.getApplicationContext().getContentResolver().delete(calendarUri, null, null);
        }
    }

    @SuppressLint("Range")
    private int checkCalendarAccount() {
        Cursor userCursor = flutterPluginBinding.getApplicationContext().getContentResolver().query(CALENDAR_URL,
                null, null, null, null);
        try {
            if (userCursor == null)//查询返回空值
                return -1;
            int count = userCursor.getCount();
            if (count > 0) {//存在现有账户，取第一个账户的id返回

                while (userCursor.moveToNext()) {
                    System.out.println(userCursor.getString(userCursor.getColumnIndex("ownerAccount")));
                    System.out.println(userCursor.getString(userCursor.getColumnIndex("account_name")));
                    System.out.println(userCursor.getString(userCursor.getColumnIndex("name")));
                }

                userCursor.moveToFirst();
                return userCursor.getInt(userCursor.getColumnIndex(CalendarContract.Calendars._ID));
            } else {
                return -1;
            }
        } finally {
            if (userCursor != null) {
                userCursor.close();
            }
        }
    }

    private String CALENDARS_NAME = "detonation_product_3";
    private String CALENDARS_ACCOUNT_NAME = "33333@localhost.com";
    private String CALENDARS_ACCOUNT_TYPE = "LOCAL";
    private String CALENDARS_DISPLAY_NAME = "日程321";

    private long addCalendarAccount() {
        TimeZone timeZone = TimeZone.getDefault();
        ContentValues value = new ContentValues();
        value.put(CalendarContract.Calendars.NAME, CALENDARS_NAME);

        value.put(CalendarContract.Calendars.ACCOUNT_NAME, CALENDARS_ACCOUNT_NAME);
        value.put(CalendarContract.Calendars.ACCOUNT_TYPE, CALENDARS_ACCOUNT_TYPE);
        value.put(CalendarContract.Calendars.CALENDAR_DISPLAY_NAME, CALENDARS_DISPLAY_NAME);
        value.put(CalendarContract.Calendars.VISIBLE, 1);
        value.put(CalendarContract.Calendars.CALENDAR_COLOR, Color.BLUE);
        value.put(CalendarContract.Calendars.CALENDAR_ACCESS_LEVEL, CalendarContract.Calendars.CAL_ACCESS_OWNER);
        value.put(CalendarContract.Calendars.SYNC_EVENTS, 1);
        value.put(CalendarContract.Calendars.CALENDAR_TIME_ZONE, timeZone.getID());
        value.put(CalendarContract.Calendars.OWNER_ACCOUNT, CALENDARS_ACCOUNT_NAME);
        value.put(CalendarContract.Calendars.CAN_ORGANIZER_RESPOND, 0);

        Uri calendarUri = CALENDAR_URL.buildUpon()
                .appendQueryParameter(CalendarContract.CALLER_IS_SYNCADAPTER, "true")
                .appendQueryParameter(CalendarContract.Calendars.ACCOUNT_NAME, CALENDARS_ACCOUNT_NAME)
                .appendQueryParameter(CalendarContract.Calendars.ACCOUNT_TYPE, CALENDARS_ACCOUNT_TYPE)
                .build();

        Uri result = flutterPluginBinding.getApplicationContext().getContentResolver().insert(calendarUri, value);
        return result == null ? -1 : ContentUris.parseId(result);
    }

    private boolean checkPermission() {
        //权限是否已经赋予
        if ((ActivityCompat.checkSelfPermission(flutterPluginBinding.getApplicationContext(), Manifest.permission.WRITE_CALENDAR) != PackageManager.PERMISSION_GRANTED)
                || (ActivityCompat.checkSelfPermission(flutterPluginBinding.getApplicationContext(), Manifest.permission.READ_CALENDAR) != PackageManager.PERMISSION_GRANTED)) {

            return false;
        } else {
            return true;
        }
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
