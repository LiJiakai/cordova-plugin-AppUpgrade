var exec = require('cordova/exec');

module.exports = {
	checkUpdate:function(success,failure){
	    exec(success,failure,"AppUpgrade","checkUpdate",[]);
	},
	getAppName:function(success, failure){
	    exec(success,failure,"AppUpgrade","getAppName",[]);
	},
	getPackageName:function(success, failure){
	    exec(success,failure,"AppUpgrade","getPackageName",[]);
	},
	getVersionNumber:function(success, failure){
	    exec(success,failure,"AppUpgrade","getVersionNumber",[]);
	},
	getVersionCode:function(success, failure){
	    exec(success,failure,"AppUpgrade","getVersionCode",[]);
	}
};