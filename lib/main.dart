import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'utils/awesome_notifications_helper.dart';

import 'app/data/local/my_hive.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/data/models/user_model.dart';
import 'app/routes/app_pages.dart';
import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';

Future<void> main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  // initialize local db (hive) and register our custom adapters
  await MyHive.init(
      registerAdapters: (hive) {
        hive.registerAdapter(UserModelAdapter());
        //myHive.registerAdapter(OtherAdapter());
      }
  );

  // init shared preference
  await MySharedPref.init();


  // initialize local notifications service
  await AwesomeNotificationsHelper.init();

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    ///注册异常上报平台
    SentryFlutter.init(
            (options) {
          options.autoAppStart = false;
          // options.beforeSend = (SentryEvent event, Hint hint) async {
          //   final bytes = await WebViewFactory.instance.createWebView()
          //       .captureScreenshot();
          //   if (bytes != null) {
          //     hint.screenshot = SentryAttachment.fromScreenshotData(bytes);
          //   }
          //   return event;
          // };
          options.dsn =
          'https://d8647af36674b068c016d9b2bf9a8a05@o4507146122887168.ingest.us.sentry.io/4507146124656640';
          // To set a uniform sample rate
          options.tracesSampleRate = 1.0;
        },
        appRunner: () =>
            runApp(
              ScreenUtilInit(
                designSize: const Size(375, 812),
                minTextAdapt: true,
                splitScreenMode: true,
                useInheritedMediaQuery: true,
                rebuildFactor: (old, data) => true,
                builder: (context, widget) {
                  return GetMaterialApp(
                    // todo add your app name
                    title: "我的flutter模板",
                    useInheritedMediaQuery: true,
                    debugShowCheckedModeBanner: false,
                    builder: (context, widget) {
                      bool themeIsLight = MySharedPref.getThemeIsLight();
                      return Theme(
                        data: MyTheme.getThemeData(isLight: themeIsLight),
                        child: MediaQuery(
                          // prevent font from scalling (some people use big/small device fonts)
                          // but we want our app font to still the same and dont get affected
                          data: MediaQuery.of(context).copyWith(
                              textScaleFactor: 1.0),
                          child: widget!,
                        ),
                      );
                    },
                    initialRoute: AppPages.INITIAL,
                    // first screen to show when app is running
                    getPages: AppPages.routes,
                    // app screens
                    locale: MySharedPref.getCurrentLocal(),
                    // app language
                    translations: LocalizationService
                        .getInstance(), // localization services in app (controller app language)
                  );
                },
              ),
            )
    );
  }, (dynamic error, StackTrace stackTrace) async {
    Logger().e("$error\r\n$stackTrace");
    await Sentry.captureException(error, stackTrace: stackTrace);
  });
}
