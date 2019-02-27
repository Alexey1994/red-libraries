Red/System []

Window!: alias struct! [
    structure_size   [integer!]
    style            [integer!]
    window_procedure [function! [return: [integer!]]]
    class            [integer!]
    window           [pointer! [integer!]]
    instance         [pointer! [integer!]]
    icon             [pointer! [integer!]]
    cursor           [pointer! [integer!]]
    background       [pointer! [integer!]]
    menu_name        [c-string!]
    class_name       [c-string!]
    small_icon       [pointer! [integer!]]
]

DEFAULT_ICON:  32512
DEFAULT_ARROW: 32512
UNIQUE_FOR_EACH_WINDOW_CONTEXT_CLASS_STYLE: 32
POPUP_WINDOW_STYLE: 2147483648 ;0x80000000
SHOW_MAXIMIZED_WINDOW: 3

#import ["kernel32.dll" stdcall [
    last_error: "GetLastError" [return: [integer!]]
    sleep: "Sleep" [time_in_milliseconds [integer!]]
]]

#import ["user32.dll" stdcall [
    register_class: "RegisterClassExA" [
        class   [Window!]
        return: [integer!]]

    create_window: "CreateWindowExA" [
        extended_style [integer!]
        class_name     [c-string!]
        window_name    [c-string!]
        style          [integer!]
        x              [integer!]
        y              [integer!]
        width          [integer!]
        height         [integer!]
        parent_window  [pointer! [integer!]]
        menu           [pointer! [integer!]]
        instance       [pointer! [integer!]]
        parameters     [pointer! [integer!]]
        return:        [integer!]]

    show_window: "ShowWindow" [
        window  [integer!]
        options [integer!]
        return: [integer!]]

    load_icon: "LoadIconA" [
        a       [integer!] 
        b       [integer!] 
        return: [pointer! [integer!]]]

    load_cursor: "LoadCursorA" [
        a       [integer!] 
        b       [integer!] 
        return: [pointer! [integer!]]]
]]

window_procedure: function [return: [integer!]] [
    print "window proc"
    1
]

window_class: declare Window!
window_class/structure_size:   size? Window!
window_class/style:            UNIQUE_FOR_EACH_WINDOW_CONTEXT_CLASS_STYLE
window_class/window_procedure: :window_procedure
window_class/class:            0
window_class/window:           null
window_class/instance:         null
window_class/icon:             load_icon 0 DEFAULT_ICON
window_class/cursor:           load_icon 0 DEFAULT_ARROW
window_class/background:       null
window_class/menu_name:        null
window_class/class_name:       "Main window class"
window_class/small_icon:       load_icon 0 DEFAULT_ICON

registered_class: register_class window_class
window:           create_window 0 "Main window class" "Window" 0 0 0 1440 900 null null window_class/instance null
                  show_window window SHOW_MAXIMIZED_WINDOW

while [true] [sleep 1]

print last_error