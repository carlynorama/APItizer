# APItizer

If its generic intereacting with an API server, it goes here.

If it is specific to the servers actual API it goes... there.

There are many Packages that are a better choices for underpining an API Client in Swift. Much of what's here is more robustly executed in Vapor for example. This Package mostly gets used by me when prototyping working with a new API as repository for getting going quickly.

See also [APIng](https://github.com/carlynorama/APIng), a command line tool used for quickly checking new functions that will end up in here.  

For reference a review of common API types. 

## HTTP Request-Respose APIs

Polling style of interactions. 

- `Request -> <- Status {working}`
- `Request -> <- Status {working}`
- `Request -> <- Status {ready,Data}` (finally!)

### REST APIs
- Endpoints with standadrd naming conventions around nouns with adjustments to the data object data payloads/url encodings `http://server/api/resource_noun { adjective:true }`. Never verbs. 
- uses all HTTP Features(GET, POST, PUT and DELETE)
- Relatively easy to maintain because features are standardized across model objects
- Some cons: big payloads, multiple call&returns to do actions
- best for data services that primaryaly need CRUD

### RPC APIs
- Endpoints for actions that are self descriptive and verb oriented (use nouns  `http://server/api/resource_noun.makeAdjectiveTrue`)
- uses GET (read only) and POST (everything else)
- lightwieght payloads
- Some cons: difficult to discover actions, everything is a new function 
- Best if service more behavior driven than data driven

### GRAPHQL APIs
- One endpoint. `http://server/api  { some_json }`
- uses  POST (almost everything) GET (some things)
- Client can be quite specific about the wanted data. Filter happend on the server. 
- No need for versions
- Server complexity and load is much higher
- Best when complex queries are the norm. 

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
    - server sets [transfer encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Transfer-Encoding) to chuncked (non-browser clients).
    - [Server-Sent-Events](https://en.wikipedia.org/wiki/Server-sent_events) (browser clients)  The mime type for SSE is text/event-stream
- No other protocols are necesssary, with native browser support.
- Bad for bidirectional communication or streams that would benefit from buffering. 
