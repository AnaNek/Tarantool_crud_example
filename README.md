# Пример использования CRUD

## Использование crud.insert()

```
curl -POST -v -H "Content-Type: application/json" -d '{"key": 3, "value": {"name": "In the end", "artist": "Linkin park", "duration": 185}}' http://localhost:8081/kv
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:8081...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8081 (#0)
> POST /kv HTTP/1.1
> Host: localhost:8081
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Type: application/json
> Content-Length: 85
> 
* upload completely sent off: 85 out of 85 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 201 Created
< Content-length: 91
< Server: Tarantool http (tarantool v1.10.9-0-g720ffdd23)
< Content-type: application/json; charset=utf-8
< Connection: keep-alive
< 
* Connection #0 to host localhost left intact
[{"song_id":3,"duration":185,"bucket_id":11804,"name":"In the end","artist":"Linkin park"}]
```

## Пример использования crud.get()
```
curl -X GET -v http://localhost:8081/kv/3
Note: Unnecessary use of -X or --request, GET is already inferred.
*   Trying 127.0.0.1:8081...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8081 (#0)
> GET /kv/3 HTTP/1.1
> Host: localhost:8081
> User-Agent: curl/7.68.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 Ok
< Content-length: 91
< Server: Tarantool http (tarantool v1.10.9-0-g720ffdd23)
< Content-type: application/json; charset=utf-8
< Connection: keep-alive
< 
* Connection #0 to host localhost left intact
[{"song_id":3,"duration":185,"bucket_id":11804,"name":"In the end","artist":"Linkin park"}]
```

## Пример использования crud.update()
```
curl -X PUT -v -H "Content-Type: application/json" -d '{"value": {"name": "In the End", "artist": "Linkin Park", "duration": 187}}' http://localhost:8081/kv/3
*   Trying 127.0.0.1:8081...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8081 (#0)
> PUT /kv/3 HTTP/1.1
> Host: localhost:8081
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Type: application/json
> Content-Length: 75
> 
* upload completely sent off: 75 out of 75 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 Ok
< Content-length: 91
< Server: Tarantool http (tarantool v1.10.9-0-g720ffdd23)
< Content-type: application/json; charset=utf-8
< Connection: keep-alive
< 
* Connection #0 to host localhost left intact
[{"song_id":3,"duration":187,"bucket_id":11804,"name":"In the End","artist":"Linkin Park"}]
```

## Пример использования crud.delete()
```
curl -X DELETE -v http://localhost:8081/kv/3
*   Trying 127.0.0.1:8081...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8081 (#0)
> DELETE /kv/3 HTTP/1.1
> Host: localhost:8081
> User-Agent: curl/7.68.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 Ok
< Content-length: 91
< Server: Tarantool http (tarantool v1.10.9-0-g720ffdd23)
< Content-type: application/json; charset=utf-8
< Connection: keep-alive
< 
* Connection #0 to host localhost left intact
[{"song_id":3,"duration":187,"bucket_id":11804,"name":"In the End","artist":"Linkin Park"}]
```


