# APItizer

If its generic interacting with an API server, it goes here.

If it is specific to the servers actual API it goes... there.

There are many Packages that are a better choices for underpinning an API Client in Swift. Much of what's here is more robustly executed in Vapor for example. This Package is mostly for prototyping working with a new API to learn about Swift / to get going quickly.

To use this in a project, Go to your project page / Signing & Capabilities / App Sandbox (Xcode 14) and then enable Outgoing Connections (Client) which will allow your app to make http calls.

See also [APIng](https://github.com/carlynorama/APIng), a command line tool used for quickly checking new functions that will end up in here.  

For reference a review of common API types. 

## HTTP Request-Response APIs

Polling style of interactions. 

- `Request -> <- Status {working}`
- `Request -> <- Status {working}`
- `Request -> <- Status {ready,Data}` (finally!)

### REST APIs

Representational state transfer (REST) "It means that a server will respond with the representation of a resource (today, it will most often be an HTML, XML or JSON document) and that resource will contain hypermedia links that can be followed to make the state of the system change. Any such request will in turn receive the representation of a resource, and so on." [Wikipedia](https://en.wikipedia.org/wiki/Representational_state_transfer)

That last part, the links, is rarely implemented. 

- Endpoints with standard naming conventions around nouns with adjustments to the data object data payloads/url encodings `http://server/api/resource_noun { adjective:true }`. Never verbs. 
- typically instances/instanceid type of pattern. 
- uses all [HTTP Methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods) and responses codes as part of the protocol e.g.
    - GET 
    - POST (eg new w/201 response, full replacement or partial (not idempotent) w/200 response, 
    - PUT full replacement (idempotent) 
    - DELETE
- Media type is a driver of behavior: Request `Accept` header, Response `Content-Type`
- Relatively easy to maintain because features are standardized across model objects
- Some cons: big payloads, multiple call&returns to do actions
- Best for data services that primarily need CRUD
- Note from the inventor of REST: <https://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven>
 

### RPC APIs

REST was a response to an older style, Remote Procedure Call APIs, which was about making functions run on a remote machine rather than on centering the information transfer. SOAP is an example but there are many many others. [Wikipedia](https://en.wikipedia.org/wiki/Remote_procedure_call)

- Endpoints for actions that are self descriptive and verb oriented (use nouns  `http://server/api/resource_noun.makeAdjectiveTrue`)
- uses GET (read only) and POST (everything else)
- lightweight payloads
- Some cons: difficult to discover actions, everything is a new function 
- Best if service more behavior driven than data driven

### GRAPHQL APIs
- One endpoint. `http://server/api  { some_json }`
- uses  POST (almost everything) GET (some things)
- Client can be quite specific about the wanted data. Filter happened on the server. 
- No need for versions
- Some cons: Server complexity and server load is much higher, doesn't handle file uploads without "mutations"
- Best when complex queries are the norm because large, sprawling and interrelated dataset.

 ## Event APIs
 
### WebHooks
- client makes 1 time registration request with what event interested in and callback URL (HTTP)
- server replies with an HTTP post to that URL 
- pitfalls: server manages retries, clients have to expose a URL, 1hook/event

### WebSockets
- client sends handshake (HTTP)
- server provides socket (HTTP)
- now a TCP connection, bidirectional low latency communication with very little HTTP
- pitfalls: Client has to maintain connection, hard to scale

### HTTPStreaming
- client send single request (HTTP)
- server keeps connection open by one of the following 
    - server sets [transfer encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Transfer-Encoding) to chunked (non-browser clients).
    - [Server-Sent-Events](https://en.wikipedia.org/wiki/Server-sent_events) (browser clients)  The mime type for SSE is text/event-stream
- No other protocols are necessary, with native browser support.
- Bad for bidirectional communication or streams that would benefit from buffering. 
