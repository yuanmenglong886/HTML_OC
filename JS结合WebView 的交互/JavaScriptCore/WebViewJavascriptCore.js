globalObject = new Object();

globalObject.name = 100;
globalObject.nativeCallJS = function(parameter){
      alert(parameter);
}
blockjsCallNativeFunction({"functionName":"callnative","arguments":["age","name","xiaozhang"]});
