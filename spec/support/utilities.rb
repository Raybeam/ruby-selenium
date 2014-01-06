def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def save_snapshot(example,filename)
    save_html_to_file(example, filename)

    if example.metadata[:js]
      save_screenshot_to_file(example, filename)
    end
end

def save_html_to_file(example, filename)
  File.open("#{path_to_tmp(example)}/#{filename}.html", 'w') {|f| f.write(page.html) }
end

def save_screenshot_to_file(example, filename)
  page.save_screenshot("#{path_to_tmp(example)}/#{filename}.png")
end

def path_to_tmp(example)
  if example.metadata[:tmp_path]
    return example.metadata[:tmp_path]
  end
  example.metadata[:tmp_path] = path_to_screenshot(example)
  example.metadata[:tmp_path]
end

def path_to_screenshot(example)
  if example.metadata[:screenshot_path]
    return example.metadata[:screenshot_path]
  end
	desc = example.metadata[:description_args].empty? ? example.metadata[:id] : example.metadata[:description_args].first.gsub('"',"'").gsub('|', '')
	example.metadata[:screenshot_path] = path_of_example_groups(example, desc)
  example.metadata[:screenshot_path]
end

def path_of_example_groups(example, desc)
  # metadata maintains example_group structure as nested example_groups from inner to outer
  # so we build array from inner to outer and then reverse it
  groups = []
  groups << desc
  current_group = example.metadata[:example_group]
  while (!current_group.nil?) do
    groups << current_group[:description]
    current_group = current_group[:example_group]
  end

  groups << $base_screenshot_dir

  groups.reverse.join('/')
  
end

