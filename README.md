# cordova-plugin-AppUpgrade
cordova ios版本更新检查插件
  进行cordova hybrid app 开发时，不可避免的遇到检查app更新的问题，其实已经有一些类似的插件，比如org.ssgroup.sope.cordova.upgrade，但是
这些插件依赖于itunes 的api：http://itunes.apple.com/cn/lookup?id= 进行最新版本号的查询，由于我们在发布ios app，进行审核时这个接口还不
没有包含版本信息（尚未发布），因此利用这种方法开发的app在审核时可能不能正常工作。
  本插件基于后端的两个ajax接口进行最新版本号以及更新URl的查询，所以使用此插件的同时，请不要忘记开发相应的后端接口，并修改插件源码中的
接口URL地址。调用后端接口时使用AFNetWorking库。
