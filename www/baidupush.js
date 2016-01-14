/**
 * Author: xyz
 * Create-Date: 2015-06-24
 * Description: the Js part of BaiduPush plugin
 */
var cordova = require('cordova'),
    exec = require('cordova/exec');

function BaiduPush() {

}

function failureCallback() {
    console.log('BaiduPush got an error.');
}

BaiduPush.prototype.startWork = function (apiKey, successCallback) {
    exec(successCallback, failureCallback, 'BaiduPush', 'startWork', [apiKey]);
};


BaiduPush.prototype.stopWork = function (successCallback) {
    exec(successCallback, failureCallback, 'BaiduPush', 'stopWork', []);
};

BaiduPush.prototype.resumeWork = function (successCallback) {
    exec(successCallback, failureCallback, 'BaiduPush', 'resumeWork', []);
};


BaiduPush.prototype.setTags = function (tags, successCallback) {
    exec(successCallback, failureCallback, 'BaiduPush', 'setTags', [tags]);
};


BaiduPush.prototype.delTags = function (tags, successCallback) {
    exec(successCallback, failureCallback, 'BaiduPush', 'delTags', [tags]);
};

BaiduPush.prototype.listTags = function (successCallback) {
    exec(successCallback, failureCallback, 'BaiduPush', 'listTags', []);
};

BaiduPush.prototype.listenNotificationClicked = function(successCallback){
    exec(successCallback, failureCallback, 'BaiduPush', 'listenNotificationClicked', []);
};


BaiduPush.prototype.listenNotificationArrived = function(successCallback){
    exec(successCallback, failureCallback, 'BaiduPush', 'listenNotificationArrived', []);
};

//Only for Android
BaiduPush.prototype.listenMessage = function(successCallback){
    exec(successCallback, failureCallback, 'BaiduPush', 'listenMessage', []);
};

var baidupush = new BaiduPush();

module.exports = baidupush;


