local cartridge = require('cartridge')

local function init_space()
    local space = box.schema.space.create(
         'song', -- имя спейса
         {
             format = {
                 {'song_id', 'unsigned'}, -- id песни
                 {'bucket_id', 'unsigned'}, -- id сегмента
                 {'name', 'string'}, -- название
                 {'artist', 'string'}, -- исполнитель
                 {'duration', 'unsigned'} -- длительность
             },
             
             if_not_exists = true,
         }
     )
     
     -- индекс по id песни
     space:create_index('song_id', {
         parts = {'song_id'},
         if_not_exists = true,
     })
     
     -- индекс по id сегмента
     space:create_index('bucket_id', {
         parts = {'bucket_id'},
         unique = false,
         if_not_exists = true, 
     })
end

local function init(opts)
    if opts.is_master then
        init_space()
    end
end

return {
        role_name = 'storage',
        init = init,
        dependencies = {'cartridge.roles.crud-storage'},
    }
