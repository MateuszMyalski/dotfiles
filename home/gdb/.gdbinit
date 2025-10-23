define rr32
    p/x *(uint32_t)$arg0
end

define rw32
    set *(uint32_t)$arg0 = $arg1
end

define roc
    target extended-remote localhost:3333
end

define fl
    set confirm off
    file $arg0
    load
    set confirm on
end