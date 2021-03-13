// Regex for full names of methods and events
var NAME_REGEX = /^WebSigner\.(\d+\.\d+\.\d+)\.([a-zA-Z0-9_]+)\.(.+)$/;

function replaceHostType(msg, hostTypeToMatch, newHostType) {

    function replace(name) {
        var match = name.match(NAME_REGEX);

        if (!match)
            throw new Error("Incorrect name: " + name);

        var version = match[1];
        var hostType = match[2];
        var methodOrEventName = match[3];

        if (hostType === hostTypeToMatch) {            
            return "WebSigner." + version + "." + newHostType + "." + methodOrEventName;
        } else {
            return name;
        }
    }

    if (msg.event) {
        msg.event = replace(msg.event);
    } else if (msg.method) {
        msg.method = replace(msg.method);
    }    
}

/*
 * NativeHost class wraps an instance of native messaging host and handles its lifecycle.
 */
function NativeHost(id, contentScriptPort, configuration, nativeMessagingPort, requestedHostType, actualHostType) {
        
    var scope = configuration.scope || "page";
    var messageHandler = configuration.messageHandler;    
    var timeoutMilliseconds = configuration.timeoutMilliseconds || 0;

    var tabId = contentScriptPort.sender.tab.id;    
    var timerId = null;
            
    nativeMessagingPort.onMessage.addListener(processMessageFromNativeMessagingHost);
    nativeMessagingPort.onDisconnect.addListener(onNativeMessagingPortDisconnected);

    var dispatcher = createDispatcher();

    log('Created new instance. Configuration:', {
        tabId: tabId,
        timeoutMilliseconds: timeoutMilliseconds,
        hostName: configuration.hostName + "." + actualHostType,
        messageHandler: messageHandler,
        scope: scope
    });

    function log() {
        console.log.apply(console, ["Native host ID=" + id + ": "].concat(Array.prototype.slice.call(arguments, 0)));
    }
    
    function createDispatcher() {
        disconnectDispatcher();
                                
        contentScriptPort.onDisconnect.addListener(onContentScriptDisconnected);
        
        function sendMessageToNativeMessagingHost(msg) {
            fixMessageToNativeMessagingHost(msg);
            resetTimeout();
            nativeMessagingPort.postMessage(msg);
        }

        function sendMessageToContentScriptPort(msg) {
            resetTimeout();
            contentScriptPort.postMessage(msg);
        }

        return new Dispatcher(sendMessageToNativeMessagingHost, sendMessageToContentScriptPort, messageHandler, NAMESPACE + requestedHostType + ".");
    }

    var parts = [];

    function fixMessageFromNativeMessagingHost(msg) {
        replaceHostType(msg, actualHostType, requestedHostType);        
    }

    function fixMessageToNativeMessagingHost(msg) {
        replaceHostType(msg, requestedHostType, actualHostType);        
    }

    function processMessageFromNativeMessagingHost(msg) {   
        resetTimeout();

        if ("part" in msg && "isFinal" in msg) {            
            parts.push(msg.part);

            if (msg.isFinal) {
                var completeMessage = JSON.parse(parts.join(""));

                parts = [];

                fixMessageFromNativeMessagingHost(completeMessage);
                dispatcher.processMessageFromNativeMessagingHost(completeMessage);
            }
        } else {
            fixMessageFromNativeMessagingHost(msg);
            dispatcher.processMessageFromNativeMessagingHost(msg);
        }        
    }

    function processMessageFromContentScript(msg) {        
        resetTimeout();
        dispatcher.processMessageFromContentScript(msg);
    }

    function onTimeout() {
        log("Native host will be closed. Reason: Timeout.");

        sendInternalEvent(NAMESPACE + 'Internal.HostDisconnected', ["Timeout"]);
        disconnectAll();
    }

    function resetTimeout() {
        // null check is not necessary here, clearTimeout ignores invalid parameter
        clearTimeout(timerId);
        
        if (timeoutMilliseconds > 0) {
            timerId = setTimeout(onTimeout, timeoutMilliseconds);
        }
    }
        
    function disconnectNativeMessagingPort() {
        if (nativeMessagingPort) {
            nativeMessagingPort.disconnect();
            nativeMessagingPort.onMessage.removeListener(processMessageFromNativeMessagingHost);
            nativeMessagingPort.onDisconnect.removeListener(onNativeMessagingPortDisconnected);

            nativeMessagingPort = null;
        }
    }

    function disconnectDispatcher() {
        dispatcher = null;        
    }

    function disconnectContentScriptPort() {
        if (contentScriptPort) {
          
            contentScriptPort.onDisconnect.removeListener(onContentScriptDisconnected);

            contentScriptPort = null;
        }
    }

    function disconnectAll() {
        disconnectNativeMessagingPort();        
        disconnectContentScriptPort();
        disconnectDispatcher();

        tabId = null;
    }

    function disconnectPage() {
        // Newly connected page should not receive results for calls initiated by a previous page,
        // so if there is an unfinished call we need to close the native host as well.

        if (dispatcher && dispatcher.hasUnfinishedCalls()) {            
            log("Native host will be closed, because there are unfinished calls.");
            disconnectAll();
        } else {
            disconnectContentScriptPort();
            disconnectDispatcher();
        }         
    }

    function connectPage(newContentScriptPort) {
        log('Native host is connected with a new page.');

        contentScriptPort = newContentScriptPort;
                
        dispatcher = createDispatcher();
    }

    function getState() {
        if (!nativeMessagingPort) {
            return "disconnected";
        }
        if (!contentScriptPort) {
            return "partially-connected";
        }
        return "connected";
    }
        
    function onContentScriptDisconnected() {        
        if (scope === "page") {
            log('Native host will be closed. Reason: Page was disconnected.');
            disconnectAll();
        } else if (scope === "tab") {
            log('Page was disconnected.');
            disconnectPage();            
        } else if (scope === "global") {
            log('Page was disconnected.');
            disconnectPage();
            // clear tabId so that the NativeHost
            // can be reused by a page in a different tab
            tabId = null;
        }
    }

    function onTabRemoved() {
        if (scope === "tab") {
            log('Native host will be closed. Reason: Tab ID=', tabId, ' was removed.');
            disconnectAll();
        } else if (scope === "global") {
            log('Tab was removed.');
            // clear tabId so that the NativeHost
            // can be reused by a page in a different tab
            tabId = null;
        }
    }

    function onNativeMessagingPortDisconnected() {
        var message = chrome.runtime.lastError.message;

        log("Native host will be closed. Reason: Native messaging host was disconnected. Error message: ", message);
        
        sendInternalEvent(NAMESPACE + 'Internal.HostDisconnected', ["HostProcessTerminated"]);
        disconnectAll();
    }
    
    function sendInternalEvent(event, args) {        
        if (dispatcher && contentScriptPort) {
            dispatcher.sendEvent(event, args);
        }
    }

    function isConnectedWith(contentScriptPortOrTabId) {
        if (contentScriptPortOrTabId == null) {
            return contentScriptPort == null && tabId == null;
        }
        if (contentScriptPort === contentScriptPortOrTabId) {
            return true;
        }
        if (tabId === contentScriptPortOrTabId) {
            return true;
        }
        return false;
    }

    // ================== Public functions ===================================
    
    this.isConnectedWith = isConnectedWith;
    this.isInState = function (s) { return getState() === s; }

    this.connectPage = connectPage;

    this.processMessageFromContentScript = processMessageFromContentScript;    
    this.onTabRemoved = onTabRemoved;

};