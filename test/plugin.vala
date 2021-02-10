//valac --pkg gmodule-2.0 -C plugin.vala plugin-interface.vala
//clang -shared -fPIC $(pkg-config --cflags --libs glib-2.0 gmodule-2.0) -o libplugin.so plugin.c

class MyPlugin : Object, TestPlugin {
    public void hello () {
        stdout.printf ("Hello world!\n");
    }
}

public Type register_plugin (Module module) {
    // types are registered automatically
    return typeof (MyPlugin);
}