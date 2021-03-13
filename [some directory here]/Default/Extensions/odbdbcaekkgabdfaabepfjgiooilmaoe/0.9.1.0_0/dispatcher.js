/* 
 * Generic class that handles communication between native messaging host 
 * and a web page (content script). It allows to call one or more methods asynchronously
 * (using the "call" method) and wait for their results (using "waitForResults" method).
 *
 * Method handling can be customized by providing customMethodHandlerClass.  
 * This class has to provide function 'tryProcessMethodCall(method, args)' that should
 * return true if the method call was processed or false if the call should be processed
 * in the default way (send to native messaging host).
 */ 
function Dispatcher(sendMessageToNativeMessagingHost, sendMessageToContentScript, customMethodHandlerClass, namespace) {
    
    var queue = [];
    var receivedResults = {};
    var nextResultId = 1;    
    var customMethodHandler = customMethodHandlerClass ? new customMethodHandlerClass(this, namespace) : null;    
    
    function processMethodCall(method, args) {
        console.debug('P  --> E      N | METHOD |', method);

        if (customMethodHandler && customMethodHandler.tryProcessMethodCall(method, args)) {
            return;
        }

        var id = call(method, args);
        waitForResults(function (error, results) {            
            sendMethodResult(method, error ? null : results[id], error);
        });
    }

    function sendMethodResult(method, result, error) {
        console.debug('P <--  E      N | METHOD |', method);

        sendMessageToContentScript({
            method: method,
            error: error,
            result: result
        });
    }

    function call(method, args) {
        console.debug('P      E  --> N | METHOD |', method);

        sendMessageToNativeMessagingHost({ method: method, args: args });

        var resultId = nextResultId++;

        queue.push({ method: method, id: resultId });

        return resultId;
    }

    function processMethodResult(method, result, error) {
        var item = queue.shift();

        if (error) {
            console.debug('P      E <--  N | METHOD |', method, 'error');
        } else {
            console.debug('P      E <--  N | METHOD |', method, 'success');
        }

        // expected result arrived
        if (item.method == method) {

            if (error) {
                for (var i = 0; i < queue.length; i++) {
                    var isCallback = typeof queue[i] == "function";

                    if (isCallback) {
                        var callback = queue[i];

                        callback(error, null);

                        receivedResults = {};

                        queue = queue.slice(i + 1);

                        return;
                    }
                }

                throw new Error("No callback found to handle error: " + error);
            }

            // store the result so we can pass it to the callback
            receivedResults[item.id] = result;

        } else {            
            throw new Error("Unexpected result received");
        }

        // if the next item is a callback, execute it with all results received so far.
        if (typeof queue[0] == "function") {
            var callback = queue.shift();

            callback(null, receivedResults);

            receivedResults = {};
        }
    }
    
    function processEvent(event, args) {
        console.debug('P      E <--  N | EVENT  |', event);

        sendEvent(event, args);        
    }
    
    function sendEvent(event, args) {
        console.debug('P <--  E      N | EVENT  |', event);

        sendMessageToContentScript({
            event: event,
            args: args
        });
    }

    function processEventResult(event, result) {
        console.debug('P  --> E      N | EVENT  |', event);

        sendEventResult(event, result);
    }

    function sendEventResult(event, result) {
        console.debug('P      E  --> N | EVENT  |', event);

        sendMessageToNativeMessagingHost({
            event: event,
            result: result
        });
    }
    
    function waitForResults(callback) {
        // when all previous results are received, this callback will be invoked
        queue.push(callback);
    }

    function processMessageFromNativeMessagingHost(message) {
        if (message.event) {
            processEvent(message.event, message.args);
        }
        else if (message.method) {
            processMethodResult(message.method, message.result, message.error);
        }        
    }

    function processMessageFromContentScript (msg) {
        if (msg.method && msg.args) {
            processMethodCall(msg.method, msg.args);
        }
        else if (msg.event && 'result' in msg) {
            processEventResult(msg.event, msg.result);
        }
    }

    // =================== Public methods ==============================

    // Methods for customMessageHandler
    this.call = call;
    this.waitForResults = waitForResults;
    this.sendMethodResult = sendMethodResult;
    this.sendEvent = sendEvent;

    // Methods called by NativeHost
    this.processMessageFromContentScript = processMessageFromContentScript;
    this.processMessageFromNativeMessagingHost = processMessageFromNativeMessagingHost;
    this.hasUnfinishedCalls = function() { return queue.length > 0 };

}