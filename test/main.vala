//valac --pkg gmodule-2.0 main.vala plugin-interface.vala -o main

public class PluginRegistrar<T> : Object {

    public string path { get; private set; }

    private Type type;
    private Module module;

    private delegate Type RegisterPluginFunction (Module module);

    public PluginRegistrar (string name) {
        assert (Module.supported ());
        this.path = Module.build_path (Environment.get_variable ("PWD"), name);
    }

    public bool load () {
        stdout.printf ("Loading plugin with path: '%s'\n", path);

        module = Module.open (path, ModuleFlags.BIND_LAZY);
        if (module == null) {
            return false;
        }

        stdout.printf ("Loaded module: '%s'\n", module.name ());

        void* function;
        module.symbol ("register_plugin", out function);
        unowned RegisterPluginFunction register_plugin = (RegisterPluginFunction) function;

        type = register_plugin (module);
        stdout.printf ("Plugin type: %s\n\n", type.name ());
        return true;
    }

    public T new_object () {
        return Object.new (type);
    }
}

void main () {
    test1();
    test2();
}

void test1 () {
    var registrar = new PluginRegistrar<TestPlugin> ("plugin");
    registrar.load ();

    var plugin = registrar.new_object ();
    plugin.hello ();
}

void test2 () {
    var registrar = new PluginRegistrar<TestPlugin> ("weather");
    registrar.load ();

    var plugin = registrar.new_object ();
    plugin.hello ();
}
