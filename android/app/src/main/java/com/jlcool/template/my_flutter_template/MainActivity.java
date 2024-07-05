package com.jlcool.template.my_flutter_template;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        flutterEngine.getPlugins().add(new UmengPushHelperPlugin());
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
