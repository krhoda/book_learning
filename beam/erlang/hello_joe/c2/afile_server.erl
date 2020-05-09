-module(afile_server).
-export([start/1, loop/1]).

start(Dir) -> spawn(afile_server, loop, [Dir]).

loop(Dir) -> 
    receive
        {Client, list_dir} ->
            Client ! {self(), file:list_dir(Dir)};
        {Client, {get_file, File}} -> 
            Full = filename:join(Dir, File),
            Client ! {self(), file:read_file(Full)};
        {Client, {put_file, FileName, FileContents}} -> 
            Full = filename:join(Dir, FileName),
            Result = file:write_file(Full, FileContents),
            Client ! {self(), Result}
    end,
    loop(Dir).