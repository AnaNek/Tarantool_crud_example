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
## Использование crud.select()

Выборка всех записей спейса song.

```lua
app_crud.router> res = crud.select('song')
---
...

app_crud.router> res
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [1, 12477, 'Whatever it takes', 'Imagine dragons', 13]
  - [2, 21401, 'Warriors', 'Imagine dragons', 13]
  - [3, 11804, 'In the End', 'Linkin Park', 187]
  - [4, 28161, 'Radioactive', 'Imagine dragons', 123]
  - [5, 1172, 'Glory', 'Hollywood undead', 123]
  - [6, 13064, 'Sell your soul', 'Hollywood undead', 185]
  - [7, 6693, 'Delish', 'Hollywood undead', 180]
...

```

Использование параметра after. Получение объектов после определенного кортежа.

```lua
app_crud.router> crud.select('song', nil, { after = res.rows[3] })
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [4, 28161, 'Radioactive', 'Imagine dragons', 123]
  - [5, 1172, 'Glory', 'Hollywood undead', 123]
  - [6, 13064, 'Sell your soul', 'Hollywood undead', 185]
  - [7, 6693, 'Delish', 'Hollywood undead', 180]
...

```

Использование параметра first. Получение первых N строк запроса.

```lua
app_crud.router> crud.select('song', nil, { first = 4 })
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [1, 12477, 'Whatever it takes', 'Imagine dragons', 13]
  - [2, 21401, 'Warriors', 'Imagine dragons', 13]
  - [3, 11804, 'In the End', 'Linkin Park', 187]
  - [4, 28161, 'Radioactive', 'Imagine dragons', 123]
...

```

### Пагинация 

```lua
app_crud.router> crud.select('song', nil, { after = res.rows[0], first = 2 })
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [1, 12477, 'Whatever it takes', 'Imagine dragons', 13]
  - [2, 21401, 'Warriors', 'Imagine dragons', 13]
...

app_crud.router> crud.select('song', nil, { after = res.rows[2], first = 2 })
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [3, 11804, 'In the End', 'Linkin Park', 187]
  - [4, 28161, 'Radioactive', 'Imagine dragons', 123]
...

```

### Обратная пагинация

```lua
app_crud.router> crud.select('song', nil, { after = res.rows[6], first = -2 })
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [4, 28161, 'Radioactive', 'Imagine dragons', 123]
  - [5, 1172, 'Glory', 'Hollywood undead', 123]
...

app_crud.router> crud.select('song', nil, { after = res.rows[4], first = -2 })
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [2, 21401, 'Warriors', 'Imagine dragons', 13]
  - [3, 11804, 'In the End', 'Linkin Park', 187]
...
```
### Использование фильтров

Выборка записей из спейса song с длительностью композиции >= 100.

```lua
app_crud.router> crud.select('song', {{'>=', 'duration', 100}})
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [3, 11804, 'In the End', 'Linkin Park', 187]
  - [4, 28161, 'Radioactive', 'Imagine dragons', 123]
  - [5, 1172, 'Glory', 'Hollywood undead', 123]
  - [6, 13064, 'Sell your soul', 'Hollywood undead', 185]
  - [7, 6693, 'Delish', 'Hollywood undead', 180]
...
```

Выборка записей из спейса song с длительностью композиции >= 100 и исполнителем Hollywood undead.

```lua
app_crud.router> crud.select('song', {{'>=', 'duration', 100}, {'==', 'artist', 'Hollywood undead'}})
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [5, 1172, 'Glory', 'Hollywood undead', 123]
  - [6, 13064, 'Sell your soul', 'Hollywood undead', 185]
  - [7, 6693, 'Delish', 'Hollywood undead', 180]
...
```

## Использование crud.replace()

```lua
app_crud.router> crud.replace_object('song', {song_id = 7, name = 'Medicine',artist = 'Hollywood undead', duration = 180})
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [7, 6693, 'Medicine', 'Hollywood undead', 180]
...

app_crud.router> crud.replace_object('song', {song_id = 8, name = 'Undead',artist = 'Hollywood undead', duration = 180})
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows:
  - [8, 3185, 'Undead', 'Hollywood undead', 180]
...

```

## Использование crud.upsert()

```lua
app_crud.router> crud.upsert_object('song', {song_id = 9, name = 'Mine',artist = 'Arctic Monkey', duration = 180}, {{'+', 'duration', 2}})
---
- metadata: [{'name': 'song_id', 'type': 'unsigned'}, {'name': 'bucket_id', 'type': 'unsigned'},
    {'name': 'name', 'type': 'string'}, {'name': 'artist', 'type': 'string'}, {'name': 'duration',
      'type': 'unsigned'}]
  rows: []
...
```


