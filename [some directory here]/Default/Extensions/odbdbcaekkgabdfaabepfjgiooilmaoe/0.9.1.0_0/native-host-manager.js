function NativeHostManager(configuration) {

    var nativeHosts = [];
    var messageQueues = [];
    var nextNativeHostId = 1;

    function createNativeHost(contentScriptPort, triggerMessage) {

        // Creation of a native host is triggered by a method call
        var match = triggerMessage.method.match(NAME_REGEX);
        if (!match)
            return Promise.reject(new Error("Incorrect message received."));

        var requestedHostType = match[2];

        function tryCreateNativeHost(hostTypes) {
            if (hostTypes.length === 0) {
                return Promise.reject(new Error("Cannot find a valid native host."));
            }

            var hostName = configuration.hostName + "." + hostTypes[0];

            return tryCreateNativeMessagingPort(hostName)
                .then(function (nativeMessagingPort) {
                    console.log("Connect to native host", hostName, "succeeded.");
                    return new NativeHost(nextNativeHostId++, contentScriptPort, configuration, nativeMessagingPort, requestedHostType, hostTypes[0]);
                })
                .catch(function () {
                    console.log("Connect to native host", hostName, "failed.");
                    return tryCreateNativeHost(hostTypes.slice(1));
                });
        }

        var hostTypesToTry = configuration.hostTypeMapping[requestedHostType];

        if (!hostTypesToTry) {
            throw new Error("Invalid host type: " + requestedHostType + ". Use one of: " + Object.keys(configuration.hostTypeMapping).join(", "));
        }
        
        return tryCreateNativeHost(hostTypesToTry);
    }

    // chrome.runtime.connectNative() does not fail immediately when the requested native messaging host
    // does not exist. So the only way to determine that a native host exists, is to
    // wait some time and check that onDisconnect event was not raised.
    function tryCreateNativeMessagingPort(hostName) {
        return new Promise(function (resolve, reject) {
            var nativeMessagingPort = chrome.runtime.connectNative(hostName);
            
            nativeMessagingPort.onDisconnect.addListener(reject);
            
            setTimeout(function() {
                resolve(nativeMessagingPort);
            }, 100);
        });
    }
    
    function findAlreadyConnected(contentScriptPort) {
        return nativeHosts.filter(function (nh) { return nh.isInState("connected") && nh.isConnectedWith(contentScriptPort); })[0];
    }

    function findPartiallyConnectedForTab(tabId) {
        return nativeHosts.filter(function (nh) { return nh.isInState("partially-connected") && nh.isConnectedWith(tabId); })[0];
    }

    function findPartiallyConnectedGlobal() {
        return nativeHosts.filter(function (nh) { return nh.isInState("partially-connected") && nh.isConnectedWith(null); })[0];
    }

    function sendToNativeHost(contentScriptPort, message) {
        // remove disconnected hosts
        nativeHosts = nativeHosts.filter(function (c) { return !c.isInState("disconnected"); });

        var existingNativeHost = findAlreadyConnected(contentScriptPort)
                              || findPartiallyConnectedForTab(contentScriptPort.sender.tab.id)
                              || findPartiallyConnectedGlobal();

        if (existingNativeHost) {

            // if we have found a partially connected native host, 
            // connect it with the calling page
            if (!existingNativeHost.isInState("connected")) {
                existingNativeHost.connectPage(contentScriptPort);
            }

            existingNativeHost.processMessageFromContentScript(message);
        } else {

            // If there is a message queue for the originating page,
            // enqueue the incoming message.
            for (var i = 0; i < messageQueues.length; i++) {
                var q = messageQueues[i];

                if (q.contentScriptPort === contentScriptPort) {
                    q.messages.push(message);
                    return;
                }
            }
            
            var queue = {
                contentScriptPort: contentScriptPort,
                messages: [message]
            };

            messageQueues.push(queue);
            
            createNativeHost(contentScriptPort, message)
                .then(function(nativeHost) {
                    // If we successfully created a native host, 
                    // it must now process all queued messages
                    queue.messages.forEach(function(msg) {
                        nativeHost.processMessageFromContentScript(msg);
                    });

                    // native host will now process messages directly, so remove the queue
                    messageQueues.splice(messageQueues.indexOf(queue), 1);

                    nativeHosts.push(nativeHost);
                })
                .catch(function () {
                    var message = {
                        event: NAMESPACE + 'Internal.HostNotInstalled',
                        args: []
                    };

                    console.debug('P <--  E      N | EVENT  |', message.event);

                    // remove the queue, because there is no native host to process the messages
                    messageQueues.splice(messageQueues.indexOf(queue), 1);

                    contentScriptPort.postMessage(message);                    
                });            
        }
    }

    function onTabRemoved(tabId) {
        var nativeHost = nativeHosts.filter(function(nh) { return nh.isConnectedWith(tabId); })[0];
        if (nativeHost) {
            nativeHost.onTabRemoved();
        }
    }

    this.sendToNativeHost = sendToNativeHost;
    this.onTabRemoved = onTabRemoved;
}