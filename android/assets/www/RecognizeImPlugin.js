cordova.define("cordova/plugins/recognizeim", 
  function(require, exports, module) {
    var exec = require("cordova/exec");
    var RecognizeIm = function() {};
    
    //-------------------------------------------------------------------
    RecognizeIm.prototype.match = function(client, clientKey, img, callBack) {
		var params = {
				client : client,
				clientKey : clientKey,
				img : img
			};
		
		return exec(callBack, failureCallback, 'RecognizeImPlugin', 'match' , new Array(params));
	};
	
	function failureCallback(err) {
		console.log("RecognizeImPlugin.js failed: " + err);
	}
    
    var recognizeIm = new RecognizeIm();
    module.exports = recognizeIm;

});

if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.recognizeIm) {
    window.plugins.recognizeIm = cordova.require("cordova/plugins/recognizeim");
}