#include "my_application.h"

#include <flutter_linux/flutter_linux.h>

#include "flutter/generated_plugin_registrant.h"

// const char* css_source = 
// " GtkLayout { "
// "   background-color: transparent; "
// " } "
// "  "
// " GtkViewport { "
// "   background-color: transparent; "
// " } "
// ;

struct _MyApplication {
  GtkApplication parent_instance;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)


static void on_close()
{
  exit(0);
}

// gboolean supports_alpha = TRUE;

// static gboolean on_expose(GtkWidget *widget, GdkEventExpose *event, gpointer userdata)
// {   
//   GdkWindow *window = gtk_widget_get_window(widget);
//   cairo_region_t *region = gdk_window_get_visible_region(window);
//   GdkDrawingContext *context = gdk_window_begin_draw_frame (window, region);
//   cairo_t *cr = gdk_drawing_context_get_cairo_context (context);

//   // cairo_t *cr = gdk_cairo_create(gdk_window);

//   // if (supports_alpha)
//       cairo_set_operator (cr, CAIRO_OPERATOR_SOURCE);
//       cairo_set_source_rgba (cr, 1.0, 1.0, 1.0, 0.0); /* transparent */
//   // else
//   //     cairo_set_source_rgb (cr, 1.0, 1.0, 1.0); /* opaque white */

//   /* draw the background */
//   cairo_set_operator (cr, CAIRO_OPERATOR_SOURCE);
//   cairo_paint (cr);

//   // cairo_destroy(cr);
//   gdk_window_end_draw_frame(window, context);

//   return FALSE;
// }

// static void on_screen_changed(GtkWidget *widget, GdkScreen *old_screen, gpointer userdata) {
//   gtk_widget_set_app_paintable (widget, TRUE); // important or you will get solid color
//   GdkScreen *screen = gtk_widget_get_screen (widget);
//   GdkVisual *visual = gdk_screen_get_rgba_visual (screen);
//   gtk_widget_set_visual(widget, visual);
//   gtk_widget_show_all(widget);
// }

// static void screen_changed(GtkWidget *widget, GdkScreen *old_screen, gpointer userdata)
// {
//     /* To check if the display supports alpha channels, get the colormap */
//     GdkScreen *screen = gtk_widget_get_screen(widget);
//     GdkColormap *colormap = gdk_screen_get_rgba_colormap(screen);

//     if (!colormap)
//     {
//         colormap = gdk_screen_get_rgb_colormap(screen);
//         supports_alpha = FALSE;
//     }
//     else
//     {
//         supports_alpha = TRUE;
//     }
// }


// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  // GtkWindow* window =
  //     GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));
  // GtkHeaderBar *header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
  // gtk_widget_show(GTK_WIDGET(header_bar));
  // gtk_header_bar_set_title(header_bar, "lite");
  // gtk_header_bar_set_show_close_button(header_bar, TRUE);
  // gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  // gtk_window_set_default_size(window, 1280, 720);
  // gtk_widget_show(GTK_WIDGET(window));

  g_object_set(gtk_settings_get_default(),
               "gtk-application-prefer-dark-theme", TRUE,
               NULL);

  GtkWindow *window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // GtkCssProvider *css = gtk_css_provider_new();
  // bool ok = gtk_css_provider_load_from_data (css, 
  //                                css_source,
  //                                strlen(css_source),
  //                                nullptr);
  // printf("ok: %d", ok);
  

  g_signal_connect(window, "delete_event", G_CALLBACK(on_close), NULL);
  // g_signal_connect(G_OBJECT(window), "expose-event", G_CALLBACK(on_expose), NULL);
  // g_signal_connect(G_OBJECT(window), "screen-changed", G_CALLBACK(on_screen_changed), NULL);

  gtk_window_set_title(window, "Terminal Lite");
  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));
  // gtk_widget_set_opacity (GTK_WIDGET (window), 0.85);


  g_autoptr(FlDartProject) project = fl_dart_project_new();

  FlView* view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     nullptr));
}
