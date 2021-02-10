# notes

## plugins

display sections should be plugins:
* information
* time/date
* +weather

title_plugin = new TitlePlugin(this);
date_time_plugin = new DateTimePlugin(this);
weather_plugin = new WeatherPlugin(this);
...

title_plugin.display(60, 60);
date_time_plugin_dispay(60, -90);
weather_plugin.display(-60, 60);