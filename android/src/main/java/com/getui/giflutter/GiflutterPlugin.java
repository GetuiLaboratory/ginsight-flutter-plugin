package com.getui.giflutter;

import android.os.Handler;

import com.getui.gis.sdk.GInsightManager;
import com.getui.gis.sdk.listener.IGInsightEventListener;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * GiflutterPlugin
 */
public class GiflutterPlugin implements MethodCallHandler {
    private static final String TAG = GiflutterPlugin.class.getSimpleName();

    private final Registrar registrar;
    private final Handler mainHandler;

    private GiflutterPlugin(Registrar registrar) {
        this.registrar = registrar;
        mainHandler = new Handler(registrar.context().getMainLooper());
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "giflutter");
        channel.setMethodCallHandler(new GiflutterPlugin(registrar));
    }

    @Override
    public void onMethodCall(final MethodCall call, final Result result) {
        if (call != null && result != null) {
            switch (call.method) {
                case "getPlatformVersion": {
                    result.success("Android " + android.os.Build.VERSION.RELEASE);
                    break;
                }
                case "setInstallChannel": {
                    if (call.hasArgument("channel")) {
                        String channel = call.argument("channel");
                        GInsightManager.getInstance().setInstallChannel(channel);
                    }
                    break;
                }
                case "init": {
                    if (call.hasArgument("channel")) {
                        String channel = call.argument("channel");
                        GInsightManager.getInstance().setInstallChannel(channel);
                    }
                    GInsightManager.getInstance().init(registrar.context(), new IGInsightEventListener() {
                        @Override
                        public void onSuccess(final String s) {
                            mainHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    HashMap<String, Object> ret = new HashMap<>();
                                    ret.put("isSuccess", true);
                                    ret.put("result", s);
                                    result.success(ret);
                                }
                            });
                        }

                        @Override
                        public void onError(final String s) {
                            mainHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    HashMap<String, Object> ret = new HashMap<>();
                                    ret.put("isSuccess", false);
                                    ret.put("result", s);
                                    result.success(ret);
                                }
                            });
                        }
                    });
                    break;
                }
                case "version": {
                    result.success("Android:" + GInsightManager.getInstance().version());
                    break;
                }
                default:
                    result.notImplemented();
                    break;
            }
        }
    }
}
