function d = ToError_C2S(d, message)
d = ToLog_C2S(d, "An Error occured!!!");
d.errors.latestReturned = message;
d = ErrorCallback_C2S(d);