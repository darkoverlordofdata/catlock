/* plugin.c generated by valac 0.40.25, the Vala compiler
 * generated from plugin.vala, do not modify */

/*valac --pkg gmodule-2.0 -C plugin.vala plugin-interface.vala*/
/*gcc -shared -fPIC $(pkg-config --cflags --libs glib-2.0 gmodule-2.0) -o libplugin.so plugin.c*/


#include <glib.h>
#include <glib-object.h>
#include <stdio.h>
#include <gmodule.h>


#define TYPE_TEST_PLUGIN (test_plugin_get_type ())
#define TEST_PLUGIN(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_TEST_PLUGIN, TestPlugin))
#define IS_TEST_PLUGIN(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_TEST_PLUGIN))
#define TEST_PLUGIN_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), TYPE_TEST_PLUGIN, TestPluginIface))

typedef struct _TestPlugin TestPlugin;
typedef struct _TestPluginIface TestPluginIface;

#define TYPE_MY_PLUGIN (my_plugin_get_type ())
#define MY_PLUGIN(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_MY_PLUGIN, MyPlugin))
#define MY_PLUGIN_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_MY_PLUGIN, MyPluginClass))
#define IS_MY_PLUGIN(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_MY_PLUGIN))
#define IS_MY_PLUGIN_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_MY_PLUGIN))
#define MY_PLUGIN_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_MY_PLUGIN, MyPluginClass))

typedef struct _MyPlugin MyPlugin;
typedef struct _MyPluginClass MyPluginClass;
typedef struct _MyPluginPrivate MyPluginPrivate;
enum  {
	MY_PLUGIN_0_PROPERTY,
	MY_PLUGIN_NUM_PROPERTIES
};
static GParamSpec* my_plugin_properties[MY_PLUGIN_NUM_PROPERTIES];

struct _TestPluginIface {
	GTypeInterface parent_iface;
	void (*hello) (TestPlugin* self);
};

struct _MyPlugin {
	GObject parent_instance;
	MyPluginPrivate * priv;
};

struct _MyPluginClass {
	GObjectClass parent_class;
};


static gpointer my_plugin_parent_class = NULL;
static TestPluginIface * my_plugin_test_plugin_parent_iface = NULL;

GType test_plugin_get_type (void) G_GNUC_CONST;
GType my_plugin_get_type (void) G_GNUC_CONST;
static void my_plugin_real_hello (TestPlugin* base);
MyPlugin* my_plugin_new (void);
MyPlugin* my_plugin_construct (GType object_type);
void test_plugin_hello (TestPlugin* self);
GType register_plugin (GModule* module);


static void
my_plugin_real_hello (TestPlugin* base)
{
	MyPlugin * self;
	FILE* _tmp0_;
	self = (MyPlugin*) base;
	_tmp0_ = stdout;
	fprintf (_tmp0_, "Hello world!\n");
}


MyPlugin*
my_plugin_construct (GType object_type)
{
	MyPlugin * self = NULL;
	self = (MyPlugin*) g_object_new (object_type, NULL);
	return self;
}


MyPlugin*
my_plugin_new (void)
{
	return my_plugin_construct (TYPE_MY_PLUGIN);
}


static void
my_plugin_class_init (MyPluginClass * klass)
{
	my_plugin_parent_class = g_type_class_peek_parent (klass);
}


static void
my_plugin_test_plugin_interface_init (TestPluginIface * iface)
{
	my_plugin_test_plugin_parent_iface = g_type_interface_peek_parent (iface);
	iface->hello = (void (*) (TestPlugin*)) my_plugin_real_hello;
}


static void
my_plugin_instance_init (MyPlugin * self)
{
}


GType
my_plugin_get_type (void)
{
	static volatile gsize my_plugin_type_id__volatile = 0;
	if (g_once_init_enter (&my_plugin_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (MyPluginClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) my_plugin_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (MyPlugin), 0, (GInstanceInitFunc) my_plugin_instance_init, NULL };
		static const GInterfaceInfo test_plugin_info = { (GInterfaceInitFunc) my_plugin_test_plugin_interface_init, (GInterfaceFinalizeFunc) NULL, NULL};
		GType my_plugin_type_id;
		my_plugin_type_id = g_type_register_static (G_TYPE_OBJECT, "MyPlugin", &g_define_type_info, 0);
		g_type_add_interface_static (my_plugin_type_id, TYPE_TEST_PLUGIN, &test_plugin_info);
		g_once_init_leave (&my_plugin_type_id__volatile, my_plugin_type_id);
	}
	return my_plugin_type_id__volatile;
}


GType
register_plugin (GModule* module)
{
	GType result = 0UL;
	g_return_val_if_fail (module != NULL, 0UL);
	result = TYPE_MY_PLUGIN;
	return result;
}



