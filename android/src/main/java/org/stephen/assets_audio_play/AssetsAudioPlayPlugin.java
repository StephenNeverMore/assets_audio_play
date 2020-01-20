package org.stephen.assets_audio_play;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.media.MediaPlayer;
import android.text.TextUtils;
import android.util.Log;

import java.io.IOException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * AssetsAudioPlayPlugin
 */
public class AssetsAudioPlayPlugin implements FlutterPlugin, MethodCallHandler {

    private MediaPlayer mediaPlayer;
    private Context context;

    public AssetsAudioPlayPlugin() {
    }

    public AssetsAudioPlayPlugin(Context context) {
        mediaPlayer = new MediaPlayer();
        this.context = context;
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "assets_audio_play");
        channel.setMethodCallHandler(new AssetsAudioPlayPlugin(flutterPluginBinding.getApplicationContext()));
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "assets_audio_play");
        channel.setMethodCallHandler(new AssetsAudioPlayPlugin(registrar.activeContext()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("play")) {
            playAudio(call, result);
        } else if (call.method.equals("pause")) {
            pauseAudio(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void pauseAudio(MethodCall call, Result result) {
        mediaPlayer.pause();
        result.success(1);
    }

    private void playAudio(MethodCall call, Result result) {
        mediaPlayer.pause();
        String path = call.argument("path");
        Log.e("audioplay", "audio path = " + path);
        if (TextUtils.isEmpty(path)) {
            return;
        }
        try {
            AssetManager assets = context.getResources().getAssets();
            AssetFileDescriptor assetFileDescriptor = assets.openFd("flutter_assets/" + path);
            mediaPlayer.setDataSource(assetFileDescriptor.getFileDescriptor(),
                    assetFileDescriptor.getStartOffset(),
                    assetFileDescriptor.getLength());
            mediaPlayer.prepare();
            mediaPlayer.start();
            result.success(1);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("audioplay", "play failed = ", e);
            result.success(0);
        }
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
    }
}
