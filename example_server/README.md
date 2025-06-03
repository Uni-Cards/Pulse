# Example Server
An example events-service server to accompany the example app provided for the events service implementation.

# APIs
The server allows following endpoints:
* `GET` `/events-config`
* `POST` `/events`
* `GET` `/events`
* `DELETE` `/events`

Any other endpoint invocation would fail with Bad Request ([HTTP 400](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400))

# Authentication
The server allows GET `/events-config` call without an authentication, but every POST `/events` call must contain an authentication key.

The authentication key is `secret` which must be included in all the POST `/events` call.

POST call to `/events` endopint without the correct authentication key in the header woud fail with Unauthorized([HTTP 401](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/401))

# Errors
The server can throw Internal Server Error([HTTP 500](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/500)) in case something goes wrong internally.