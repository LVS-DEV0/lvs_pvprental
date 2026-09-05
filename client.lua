Bridge = {}

function Bridge.Notify(msg, type)
    lib.notify({
        title = locale('menu_title'),
        description = msg,
        type = type
    })
end
