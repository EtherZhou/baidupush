package com.xyz.plugins.baidupush;

import java.util.List;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushMessageReceiver;

/**
 * Author: xyz
 * Create-Date: 2015-06-24
 * Description: the Android part of BaiduPush plugin
 */
public class BaiduPushMessageReceiver extends PushMessageReceiver {
    /**
     * LOG TAG，用于调试
     */
    private static final String LOG_TAG = "BaiduPushMsgReceiver";

    /**
     * 枚举，用于标示回调函数返回的参数的类型
     */
    private enum CB_TYPE {
        onBind,
        onUnbind,
        onSetTags,
        onDelTags,
        onListTags,
        onMessage,
        onNotificationClicked,
        onNotificationArrived
    }

    public static JSONObject result = null;

    /**
     * 接收百度云推送绑定的请求返回数据的函数
     *
     * @param context   上下文
     * @param errorCode 错误代码，0表示成功，非0表示失败
     * @param appId     应用的appId
     * @param userId    绑定的百度云推送用户的Id
     * @param channelId 绑定的百度云推送的频道Id
     * @param requestId 百度云推送绑定请求的Id
     */
    @Override
    public void onBind(Context context, int errorCode, String appId, String userId, String channelId, String requestId) {
        synchronized (BaiduPushPlugin.cbLock) {
            try {
                result = new JSONObject();
                JSONObject data = new JSONObject();
                data.put("appId", appId);
                data.put("userId", userId);
                data.put("channelId", channelId);
                data.put("requestId", requestId);
                data.put("errorCode", errorCode);
                data.put("deviceType", 3);

                result.put("data", data);
                result.put("type", CB_TYPE.onBind);

                BaiduPushPlugin.cbLock.notify();
            } catch (Exception e) {
                Log.e(LOG_TAG, e.getMessage(), e);
            }
        }
    }


    /**
     * 接收百度云推送解除绑定请求的返回数据的函数
     *
     * @param context   上下文
     * @param errorCode 错误代码，0表示成功，非0表示失败
     * @param requestId 请求的Id
     */
    @Override
    public void onUnbind(Context context, int errorCode, String requestId) {
        synchronized (BaiduPushPlugin.cbLock) {
            try {
                result = new JSONObject();

                JSONObject data = new JSONObject();
                data.put("errorCode", errorCode);
                setStringData(data, "requestId", requestId);

                result.put("data", data);
                result.put("type", CB_TYPE.onUnbind);

                BaiduPushPlugin.cbLock.notify();
            } catch (Exception e) {
                Log.e(LOG_TAG, e.getMessage(), e);
            }
        }
    }

    /**
     * 接收百度云推送绑定Tag请求的返回数据的函数
     *
     * @param context     上下文
     * @param errorCode   错误代码，0表示成功，非0表示失败
     * @param successTags 绑定成功的Tag
     * @param failTags    绑定失败的Tag
     * @param requestId   请求的Id
     */
    @Override
    public void onSetTags(Context context, int errorCode, List<String> successTags, List<String> failTags, String requestId) {
        synchronized (BaiduPushPlugin.cbLock) {
            try {
                result = new JSONObject();

                JSONObject data = new JSONObject();
                data.put("errorCode", errorCode);
                setStringData(data, "requestId", requestId);
                if (successTags != null && successTags.size() > 0) {
                    JSONArray successTagArr = new JSONArray();
                    for (String successTag : successTags) {
                        successTagArr.put(successTag);
                    }
                    data.put("successTags", successTagArr);
                }
                if (failTags != null && failTags.size() > 0) {
                    JSONArray failTagArr = new JSONArray();
                    for (String failTag : failTags) {
                        failTagArr.put(failTag);
                    }
                    data.put("failTags", failTagArr);
                }

                data.put("errorCode", errorCode);
                data.put("requestId", requestId);
                result.put("data", data);
                result.put("type", CB_TYPE.onSetTags);

                BaiduPushPlugin.cbLock.notify();
            } catch (Exception e) {
                Log.e(LOG_TAG, e.getMessage(), e);
            }
        }
    }

    /**
     * 接收解除已绑定的Tag请求的返回数据的函数
     *
     * @param context     上下文
     * @param errorCode   错误代码，0表示成功，非0表示失败
     * @param successTags 解除绑定成功的Tag
     * @param failTags    解除绑定失败的Tag
     * @param requestId   请求的Id
     */
    @Override
    public void onDelTags(Context context, int errorCode, List<String> successTags, List<String> failTags, String requestId) {
        synchronized (BaiduPushPlugin.cbLock) {
            try {
                result = new JSONObject();

                JSONObject data = new JSONObject();
                data.put("errorCode", errorCode);
                setStringData(data, "requestId", requestId);
                if (successTags != null && successTags.size() > 0) {
                    JSONArray successTagArr = new JSONArray();
                    for (String successTag : successTags) {
                        successTagArr.put(successTag);
                    }
                    data.put("successTags", successTagArr);
                }
                if (failTags != null && failTags.size() > 0) {
                    JSONArray failTagArr = new JSONArray();
                    for (String failTag : failTags) {
                        failTagArr.put(failTag);
                    }
                    data.put("failTags", failTagArr);
                }


                data.put("errorCode", errorCode);
                data.put("requestId", requestId);
                result.put("data", data);
                result.put("type", CB_TYPE.onDelTags);

                BaiduPushPlugin.cbLock.notify();
            } catch (JSONException e) {
                Log.e(LOG_TAG, e.getMessage(), e);
            }
        }

    }

    /**
     * 接收展示当前用户已绑定Tag列表的请求的返回数据的函数
     *
     * @param context   上下文
     * @param errorCode 错误代码，0表示成功，非0表示失败
     * @param tags      当前用户已经绑定的Tag列表
     * @param requestId 请求的Id
     */
    @Override
    public void onListTags(Context context, int errorCode, List<String> tags, String requestId) {
        synchronized (BaiduPushPlugin.cbLock) {
            try {
                result = new JSONObject();

                JSONObject data = new JSONObject();
                data.put("errorCode", errorCode);
                setStringData(data, "requestId", requestId);
                if (tags != null && tags.size() > 0) {
                    JSONArray tagArr = new JSONArray();
                    for (String tag : tags) {
                        tagArr.put(tag);
                    }
                    data.put("tags", tagArr);
                }

                data.put("errorCode", errorCode);
                data.put("requestId", requestId);
                result.put("data", data);
                result.put("type", CB_TYPE.onListTags);

                BaiduPushPlugin.cbLock.notify();
            } catch (JSONException e) {
                Log.e(LOG_TAG, e.getMessage(), e);
            }
        }

    }

    /**
     * 透穿消息的接收函数
     *
     * @param context             上下文
     * @param message             透穿消息
     * @param customContentString 用户自定义内容,为空或者为json字符串
     */
    @Override
    public void onMessage(Context context, String message, String customContentString) {
        try {
            JSONObject jsonObject = new JSONObject();

            JSONObject data = null;
            if (customContentString != null && !"".equals(customContentString)) {
                data = new JSONObject(customContentString);
            } else {
                data = new JSONObject();
            }
            setStringData(data, "message", message);

            jsonObject.put("data", data);
            jsonObject.put("type", CB_TYPE.onMessage);

            sendPushData(jsonObject, BaiduPushPlugin.MessageArriveCallbackContext);
        } catch (JSONException e) {
            Log.e(LOG_TAG, e.getMessage(), e);
        }

    }

    /**
     * 通知消息点击事件的回调函数
     *
     * @param context             上下文
     * @param title               通知的标题
     * @param description         通知的描述
     * @param customContentString 用户自定义的内容，为空或者为json字符串
     */
    @Override
    public void onNotificationClicked(Context context, String title, String description, String customContentString) {
        try {
            JSONObject jsonObject = new JSONObject();

            JSONObject data = null;
            if (customContentString != null && !"".equals(customContentString)) {
                data = new JSONObject(customContentString);
            } else {
                data = new JSONObject();
            }
            setStringData(data, "title", title);
            setStringData(data, "description", description);

            jsonObject.put("data", data);
            jsonObject.put("type", CB_TYPE.onNotificationClicked);

            sendPushData(jsonObject, BaiduPushPlugin.NotificationClickCallbackContext);
        } catch (JSONException e) {
            Log.e(LOG_TAG, e.getMessage(), e);
        }

    }

    /**
     * 通知消息到达事件的回调函数
     *
     * @param context             上下文
     * @param title               通知的标题
     * @param description         通知的描述
     * @param customContentString 用户自定义的内容，为空或者为json字符串
     */
    @Override
    public void onNotificationArrived(Context context, String title, String description, String customContentString) {
        try {
            JSONObject jsonObject = new JSONObject();

            JSONObject data = null;
            if (customContentString != null && !"".equals(customContentString)) {
                data = new JSONObject(customContentString);
            } else {
                data = new JSONObject();
            }
            setStringData(data, "title", title);
            setStringData(data, "description", description);

            jsonObject.put("data", data);
            jsonObject.put("type", CB_TYPE.onNotificationArrived);

            sendPushData(jsonObject, BaiduPushPlugin.NotificationArriveCallbackContext);
        } catch (JSONException e) {
            Log.e(LOG_TAG, e.getMessage(), e);
        }
    }


    /**
     * 接收推送内容并返回给前端JS
     * @param jsonObject JSON对象
     */
    private void sendPushData(JSONObject jsonObject, CallbackContext callbackContext) {
        if (callbackContext != null) {
            PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
            result.setKeepCallback(true);
            callbackContext.sendPluginResult(result);
        }
    }

    /**
     * 设定字符串类型JSON对象，如值为空时不设定
     *
     * @param jsonObject JSON对象
     * @param name       关键字
     * @param value      值
     * @throws JSONException JSON异常
     */
    private void setStringData(JSONObject jsonObject, String name, String value) {
        try {
            if (value != null && !"".equals(value)) {
                jsonObject.put(name, value);
            }
        }
        catch(JSONException e){
            e.printStackTrace();
        }
    }

}
