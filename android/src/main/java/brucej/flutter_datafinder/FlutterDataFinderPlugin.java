package brucej.flutter_datafinder;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import java.util.Map;


import com.bytedance.applog.AppLog;
import com.bytedance.applog.ILogger;
import com.bytedance.applog.InitConfig;
import com.bytedance.applog.picker.Picker;
import com.bytedance.applog.util.UriConstants;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterDatafinderPlugin
 */
public class FlutterDataFinderPlugin implements FlutterPlugin, MethodCallHandler {

    private MethodChannel channel;
    private static Application application;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_datafinder");
        channel.setMethodCallHandler(this);
        //
        application = (Application) flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        //
        application = null;
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_datafinder");
        channel.setMethodCallHandler(new FlutterDataFinderPlugin());
        //
        application = (Application) registrar.context().getApplicationContext();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("init")) {
            init(call, result);
        } else if (call.method.equals("setUid")) {
            setUid(call, result);
        } else if (call.method.equals("event")) {
            event(call, result);
        } else if (call.method.equals("pageStart")) {
            pageStart(call, result);
        } else if (call.method.equals("pageEnd")) {
            pageEnd(call, result);
        } else {
            result.notImplemented();
        }
    }


    void init(MethodCall call, Result result) {
        String appId = call.argument("appId");
        String appChannel = call.argument("appChannel");
        if (BuildConfig.DEBUG) {
            System.out.println("---- init appId=" + appId);
            System.out.println("---- init appChannel=" + appChannel);
        }

        /* 初始化开始 */
        final InitConfig config = new InitConfig(appId, appChannel);

        //上报域名只支持中国
        config.setUriConfig(UriConstants.DEFAULT);

        // 是否在控制台输出日志，可用于观察用户行为日志上报情况
        config.setLogger(new ILogger() {
            @Override
            public void log(String s, Throwable throwable) {
                Log.d("datafinderplugin", s, throwable);
            }
        });

        // 开启圈选埋点
        config.setPicker(new Picker(application, config));

        // 开启AB测试
        config.setAbEnable(false);

        config.setAutoStart(true);
        AppLog.init(application, config);
        /* 初始化结束 */

        result.success(true);
        return;
    }

    void setUid(MethodCall call, Result result) {
        String uid = call.argument("uid");
        if (BuildConfig.DEBUG) {
            System.out.println("---- setUid uid=" + uid);
        }

        AppLog.setUserUniqueID(uid);
        result.success(true);
        return;
    }

    void event(MethodCall call, Result result) {
        String eventName = call.argument("eventName");
        Map<String, Object> params = call.argument("params");
        if (BuildConfig.DEBUG) {
            System.out.println("---- event eventName=" + eventName);
            System.out.println("---- event params=" + params.toString());
        }

        String event = "event_" + eventName;
        try {
            if (params != null && !params.isEmpty()) {
                JSONObject paramsObj = new JSONObject();
                for (String k : params.keySet()) {
                    paramsObj.put(k, params.get(k));
                }
                AppLog.onEventV3(event, paramsObj);
                result.success(true);
                return;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        AppLog.onEventV3(event);
        result.success(true);
    }

    void pageStart(MethodCall call, Result result) {
        String pageName = call.argument("pageName");
        Map<String, Object> params = call.argument("params");
        if (BuildConfig.DEBUG) {
            System.out.println("---- pageStart pageName=" + pageName);
            System.out.println("---- pageStart params=" + params.toString());
        }

        String event = "event_" + pageName;

        try {
            if (params != null && !params.isEmpty()) {
                JSONObject paramsObj = new JSONObject();
                for (String k : params.keySet()) {
                    paramsObj.put(k, params.get(k));
                }
                AppLog.onEventV3(event, paramsObj);
                result.success(true);
                return;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        AppLog.onEventV3(event);
        result.success(true);
    }

    void pageEnd(MethodCall call, Result result) {
        String pageName = call.argument("pageName");
        Map<String, Object> params = call.argument("params");
        if (BuildConfig.DEBUG) {
            System.out.println("---- pageEnd pageName=" + pageName);
            System.out.println("---- pageEnd params=" + params.toString());
        }


        String event = "pageEnd_" + pageName;
        try {
            if (params != null && !params.isEmpty()) {
                JSONObject paramsObj = new JSONObject();
                for (String k : params.keySet()) {
                    paramsObj.put(k, params.get(k));
                }
                AppLog.onEventV3(event, paramsObj);
                result.success(true);
                return;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        AppLog.onEventV3(event);
        result.success(true);
    }


}
