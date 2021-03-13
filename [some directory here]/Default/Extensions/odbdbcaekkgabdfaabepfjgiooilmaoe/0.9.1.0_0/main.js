var VERSION = chrome.i18n.getMessage("websigner_version");
var NAMESPACE = "WebSigner." + VERSION + ".";

console.log("Extension", chrome.runtime.getManifest().name, "initialized, version =", VERSION);


var configuration = {
    // Name of the installed native messaging host
    hostName: "sk.disig.websigner." + VERSION,

    // Native messaging host is started when the first message is received from some page.    
    // Scope specifies when it will be closed:
    //   "page" - when the page is reloaded.
    //   "tab" - when the associated tab is closed.
    //   "global" - when the browser is closed.
    scope: "page",

    // Close an instance of native messaging host 
    // when no messages are sent for given duration.
    timeoutMilliseconds: 0,
    
    // The content of messages sent between a page and a native messaging host
    // is not inspected by default.
    // By providing a message handler class, you can customize the processing
    // of method calls. The message handler can block some existing methods
    // or it can provide a new methods.
    messageHandler: null,
        
    // Mapping from incoming host type (specified by JavaScript wrapper)
    // to a list of specific host types.
    //
    // When starting a native messaging host, we will use the first 
    // installed host type from the list.
    hostTypeMapping: {
        "net":  ["net"],        
        "java": ["java"],
        "auto": ["net", "java"]
    }
}

var nativeHostManager = new NativeHostManager(configuration);

chrome.runtime.onConnect.addListener(function (contentScriptPort) {
    contentScriptPort.onMessage.addListener(function (msg) {        
        nativeHostManager.sendToNativeHost(contentScriptPort, msg);
    });    
});

chrome.tabs.onRemoved.addListener(function (tabId) {
    nativeHostManager.onTabRemoved(tabId);
});

chrome.tabs.onUpdated.addListener(function (tabId, changeInfo) {
    // Without additional permissions, changeInfo is just {status:"loading"} or {status:"complete"}    
});

injectContentScriptIntoMatchingTabs();



// When a page is opened and it matches pattern defined in the manifest,
// the content script is automatically injected.
// 
// However, when the extension is reloaded/updated, we need to inject content script
// manually, otherwise the matching pages that are already opened 
// won't be able to communicate. See comment in content-script.js for more details.
function injectContentScriptIntoMatchingTabs() {
    var manifest = chrome.runtime.getManifest();
    var contentScript = manifest.content_scripts[0];
    
    chrome.tabs.query({ url: contentScript.matches }, function (tabs) {

        console.log('Found', tabs.length, 'tabs that match url pattern', contentScript.matches);

        tabs.forEach(function (tab) {
            chrome.tabs.executeScript(tab.id, {
                file: contentScript.js[0],
                runAt: contentScript.runAt
            }, function () {
                console.log('Content script injected into tab id =', tab.id);
            });
        });
    });
}


