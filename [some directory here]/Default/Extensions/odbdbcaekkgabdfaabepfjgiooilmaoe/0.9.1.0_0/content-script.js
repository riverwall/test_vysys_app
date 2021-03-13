(function() {
    
    var VERSION = chrome.i18n.getMessage("websigner_version");          
    var NAMESPACE = "WebSigner." + VERSION + ".";
    
    document.documentElement.setAttribute("data-websigner." + VERSION, "true");
            
    var port = chrome.runtime.connect();
        
    function processMessageFromPage(event) {    
        // We only accept messages from ourselves
        if (event.source !== window)
            return;

        var message = event.data;

        if (message && hasCorrectNamespace(message) && isFromPage(message)) {            
            port.postMessage(message);
        }
    } 

    function hasCorrectNamespace(message) {
        return (message.event  && message.event.substring(0, NAMESPACE.length) === NAMESPACE)
            || (message.method && message.method.substring(0, NAMESPACE.length) === NAMESPACE);
    }

    function isFromPage(message) {
        return ("event" in message && "result" in message)
            || ("method" in message && "args" in message);
    }
     
    window.addEventListener("message", processMessageFromPage, false);

    port.onMessage.addListener(function (msg) {        
        window.postMessage(msg, document.location.origin);
    });

    port.onDisconnect.addListener(function () {
        
        window.postMessage({ event: NAMESPACE + "Internal.HostDisconnected", args: ["ExtensionUnload"] }, document.location.origin);

        window.removeEventListener("message", processMessageFromPage, false);
        port = null;

        document.documentElement.removeAttribute("data-websigner." + VERSION);                 
    }); 

})();