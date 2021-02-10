/*
valac --pkg gmodule-2.0 -C weather.vala plugin-interface.vala
clang -shared -fPIC $(pkg-config --cflags --libs glib-2.0 gmodule-2.0) -o libweather.so weather.c
*/
class WeatherPlugin : Object, TestPlugin {
    public void hello () {
        stdout.printf ("Hello weather!\n");
    }
}

public Type register_plugin (Module module) {
    // types are registered automatically
    return typeof (WeatherPlugin);
}