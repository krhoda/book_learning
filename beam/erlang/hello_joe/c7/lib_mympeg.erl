-module(lib_mympeg).
-export([find_sync/2]).

% MPEG audio data is frame based.
% Every frame has a header, thus any chopped up MPEG should be able
% To be played by a player program using the header to sync.
% Example: 
% AAAAAAAA AAABBCCD EEEEFFGH IIJJKLMM
% AAAAAAAAAAA the sync word, all 1s.
% BB the MPEG Audio verson ID.
% CC layer description.
% D 1 bit of protection
% The rest is left undescribed in the text, 
% but we know it will conclude at MM
% To locate the sync point, we assume that we are correctly positioned
% at the start of a MPEG header, we attempt to leap forward to the next
% header, three things can happen:
% 1) We're correct and we're at the beginning of the next header.
% 2) We're incorrect and cannot compute the length of the frame.
% 3) We're incorrect, but land in some music data that looks like a header.

is_header(N, Bin) ->
    unpack_header(get_word(N, Bin)).

find_sync(Bin, N) -> 
    case is_header(N, Bin) of
        {ok, Len1, _} ->
            case is_header(N + Len1, Bin) of
                {ok, Len2, _} -> 
                    case is_header(N + Len1 + Len2, Bin) of
                        {ok, _, _} ->
                            {ok, N};
                        error ->
                            find_sync(Bin, N+1)
                    end;
                error ->
                    find_sync(Bin, N+1)
            end;
        error ->
            find_sync(Bin, N+1)
    end.


get_word(N, Bin) ->
    {_, <<C:4/binary,_/binary>>} = split_binary(Bin, N),
    C.

unpack_header(X) -> 
    try decode_header(X)
    catch
        _:_ -> error
    end.

% decode_header(<<2#11111111111:11,B:2,C:2,_D:1,E:4,F:2,G:1,Bits:9>>) ->
decode_header(<<2#11111111111:11,B:2,C:2,_D:1,_E:4,_F:2,_G:1,Bits:9>>) ->
    % the magic here is the statement that we will recieve a base 2 
    % figure of the value 11111111111 (11 ones) 
    % from there, the rest of the format is described.
    % if this isn't what is fed to `decode_header`, it will fallthrough
    % to the auto-fail func
    Vsn = case B of
        0 -> {2,5};
        1 -> exit(badVersion);
        2 -> 2;
        3 -> 1
    end,
    Layer = case C of 
        0 -> exit(badLayer);
        1 -> 3;
        2 -> 2;
        3 -> 1
    end,
    % No need to match against D, the protection bit.

    %% Sadly, these functions are not given
    % BitRate = bitrate(Vsn, Layer, E) * 1000,
    % SampleRate = samplerate(Vsn, F),
    % Padding = G,
    % FrameLength = framelength(Layer, BitRate, SampleRate, Padding),
    FrameLength = 21,
    if 
        FrameLength < 21 ->
            exit(frameSize);
        true ->
            % {ok, FrameLength, {Layer,BitRate,SampleRate,Vsn,Bits}}
            {ok, FrameLength, {Layer,Vsn,Bits}}
    end;
decode_header(_) -> 
    exit(badHeader).