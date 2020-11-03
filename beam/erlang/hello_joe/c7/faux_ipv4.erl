-module(faux_ipv4).

-define(IP_VERSION, 4).
-define(IP_MIN_HDR_LEN, 5).

% How to destructure IP Headers. Will not compile.
% the interesting thing is we can match arbitrary bits,
% note that Flags are 3 and FragOff is 13, which aren't even bytes.
match_dgram(Dgram) ->
    DgramSize = byte_size(Dgram),
    case Dgram of
        <<?IP_VERSION:4, HLen:4, SrvcType:8, TotLen:16, ID:16, Flags:3, FragOff:13, TTL:8, Proto:8, HdrChkSum:16, SrcIP:32, DestIP:32, RestDgram/binary>> 
          when HLen >= 5, 4*HLen =< DgramSize -> 
            OptsLen = 4*(HLen - ?IP_MIN_HDR_LEN),
            <<Opts:OptsLen/binary,Data/binary>> = RestDgram,
            RestDgram,
        % _ -> exit(something)
    end.


