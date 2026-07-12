function d = ToLog_C2S(d, message)
d.logging.latestReturned = message;
d = LogCallback_C2S(d);