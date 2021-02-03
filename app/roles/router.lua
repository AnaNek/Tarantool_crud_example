local cartridge = require('cartridge')
local log = require('log')
local errors = require('errors')

local err_vshard_router = errors.new_class("Vshard routing error")
local err_httpd = errors.new_class("httpd error")

local function json_response(req, json, status) 
    local resp = req:render({json = json})
    resp.status = status
    return resp
end

local function success_response(req, json, status, key)
    local resp = json_response(req, json, status)
    log.info("%s status:%d key: %d", req.method, resp.status, key)
    return resp
end

local function http_song_add(req)    
    local body = req:json()
    
    if body == nil then
        return error_response(req, "Invalid body", 400)
    end
    
    if body.key == nil or body.value == nil then
        return error_response(req, "Invalid body", 400)
    end
    
    if body.value.name == nil or body.value.artist == nil 
    or body.value.duration == nil then
        return error_response(req, "Invalid body", 400)
    end
    
    local resp, error = crud.insert_object('song', 
    {song_id = body.key, name = body.value.name, 
    artist = body.value.artist, duration = body.value.duration})
    
    local song = crud.unflatten_rows(resp.rows, resp.metadata)
    
    return success_response(req, song, 201, tonumber(body.key))
end

local function http_song_get(req)   
    local song_id = tonumber(req:stash('song_id'))
    
    if song_id == nil then
        return error_response(req, "Invalid key", 400)
    end
        
    local resp, error = crud.get('song', song_id)
    local song = crud.unflatten_rows(resp.rows, resp.metadata)
    
    return success_response(req, song, 200, song_id)
end

local function http_song_delete(req)
    local song_id = tonumber(req:stash('song_id'))
    
    if song_id == nil then
        return error_response(req, "Invalid key", 400)
    end
    
    local resp, error = crud.delete('song', song_id)
    
    local song = crud.unflatten_rows(resp.rows, resp.metadata)
    
    return success_response(req, song, 200, song_id)
end

local function http_song_update(req)
    local song_id = tonumber(req:stash('song_id'))
    local body = req:json()
    
    if song_id == nil then
        return error_response(req, "Invalid key", 400)
    end
    
    if body == nil then
        return error_response(req, "Invalid body", 400)
    end
    
    if body.value == nil then
        return error_response(req, "Invalid body", 400)
    end
    
    if body.value.name == nil or body.value.artist == nil 
    or body.value.duration == nil then
        return error_response(req, "Invalid body", 400)
    end
    
    local resp, error = crud.update('song', song_id, {
    {'=', 'name', body.value.name},
    {'=', 'artist', body.value.artist},
    {'=', 'duration', body.value.duration}})
    
    local song = crud.unflatten_rows(resp.rows, resp.metadata)
    
    return success_response(req, song, 200, song_id)
end

local function init(opts)
    if opts.is_master then
        box.schema.user.grant('guest',
            'read,write',
            'universe',
            nil, { if_not_exists = true }
        )
    end

    local httpd = cartridge.service_get('httpd')

    if not httpd then
        return nil, errors:new("Not found")
    end
    
    httpd:route({method = 'POST', path = '/kv', public = true},
        http_song_add
    )

    httpd:route({method = 'GET', path = '/kv/:song_id', public = true},
        http_song_get
    )
    
    httpd:route({method = 'DELETE', path = '/kv/:song_id', public = true},
        http_song_delete
    )

    httpd:route({method = 'PUT', path = '/kv/:song_id', public = true},
        http_song_update
    )
    
    return true
end

return {
        role_name = 'router',
        init = init,
        dependencies = {'cartridge.roles.crud-router'},
    }
