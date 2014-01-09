$base_screenshot_dir = 'spec/reports/HTML/screenshots'
$local_run_args = ' -r html_formatter.rb -f CapybaraHtmlFormatter -o spec/reports/HTML/index.html -r fail_fast.rb -r local.rb '

$grid_host = "10.242.1.187"
$grid_port = "4444"

# remote_webserver_ip
$remote_webserver_ip = "10.242.1.167"
$remote_webserver_port = 3000

# local_webserver_ip
$local_webserver_ip = "127.0.0.1"
$local_webserver_port = 3000