module HTMLReport
  def example_passed_helper(example, output_buffer)
    move_tmp_to_final(example)
    @printer.move_progress(percent_done)

    description = example.metadata[:description_args].join('')
    run_time = example.execution_result[:run_time]
    formatted_run_time = sprintf("%.5f", run_time)
    output_buffer.puts "    <dd class=\"example passed\"><span class=\"passed_spec_name\">#{h(description)}</span><span class='duration'>#{formatted_run_time}s</span>"

    output_buffer.puts "<div class=\"screenshots\">"
    print_screenshot(example)
    output_buffer.puts "</div>"

    output_buffer.puts "</dd>"
  end

  def example_failed_helper(example, output_buffer)
    move_tmp_to_final(example)
    unless @header_red
      @header_red = true
      @printer.make_header_red
    end

    unless @example_group_red
      @example_group_red = true
      @printer.make_example_group_header_red(example_group_number)
    end

    @printer.move_progress(percent_done)

    exception = example.metadata[:execution_result][:exception]
    exception_details = if exception
    {
      :class => exception.class.to_s,
      :message => exception.message,
      :backtrace => format_backtrace(exception.backtrace, example).join("\n")
    }
    else
      false
    end
    extra = extra_failure_content(exception)

    pending_fixed = example.execution_result[:pending_fixed]
    description = example.description
    run_time = example.execution_result[:run_time]
    failure_id = @failed_examples.size
    exception = exception_details
    extra_content = (extra == "") ? false : extra
    escape_backtrace = true
    formatted_run_time = sprintf("%.5f", run_time)

    output_buffer.puts "    <dd class=\"example #{pending_fixed ? 'pending_fixed' : 'failed'}\">"
    output_buffer.puts "      <span class=\"failed_spec_name\">#{h(description)}</span>"
    output_buffer.puts "      <span class=\"duration\">#{formatted_run_time}s</span>"
    output_buffer.puts "      <div class=\"failure\" id=\"failure_#{failure_id}\">"
    if exception
      output_buffer.puts "        <div class=\"class\"><pre>#{h(exception[:class])}</pre></div>"
      output_buffer.puts "        <div class=\"message\"><pre>#{h(exception[:message])}</pre></div>"
      if escape_backtrace
        output_buffer.puts "        <div class=\"backtrace\"><pre>#{h exception[:backtrace]}</pre></div>"
      else
        output_buffer.puts "        <div class=\"backtrace\"><pre>#{exception[:backtrace]}</pre></div>"
      end
    end
    output_buffer.puts extra_content if extra_content
    output_buffer.puts "      </div>"

    output_buffer.puts "<div class=\"rerun_command\">bundle exec rspec " + example.metadata[:file_path] + ":" + example.metadata[:line_number].to_s + $local_run_args + "</div>"
    output_buffer.puts "<div class=\"screenshots\">"
    output_buffer.puts "</div>"
    print_screenshot(example)
    output_buffer.puts "    </dd>"
  end

  def print_screenshot_helper(example, output_buffer)
    file_count = Dir[File.join(example.metadata[:screenshot_path], '*.html')].count
    max_columns = 8
    curr_column = 0

    if file_count > 0 then output_buffer.puts "<table>" end

    Dir[File.join(example.metadata[:screenshot_path], '*.html')].sort_by{|filename| File.mtime(filename) }.each do |path|
      if curr_column == 0 then output_buffer.puts "<tr>" end
      output_buffer.puts "  <td>"

      path_to_html = Pathname.new(path).relative_path_from(Pathname.new(@output_dir))
      file_name_no_extension = File.basename(path_to_html.basename, '.*')
      directory = Pathname.new(path).dirname
      relative_path_to_img = File.join(path_to_html.dirname, file_name_no_extension) + '.png'
      absolute_path_to_img = File.join(directory, file_name_no_extension) + '.png'
      
      if File.file?(absolute_path_to_img)
        output_buffer.puts "    <a href=\"#{relative_path_to_img}\" style=\"text-decoration: none;\">"
        output_buffer.puts "      <img src=\"#{relative_path_to_img}\" alt=\"#{item}\" height=\"100\" width=\"100\">"
        output_buffer.puts "    </a>"
        output_buffer.puts "    </br>"
      end
      output_buffer.puts "    <a href=\"#{path_to_html}\" style=\"text-decoration: none;\">"
      output_buffer.puts "      <pre align=\"center\">#{File.basename(path, '.*')}</pre>"
      output_buffer.puts "    </a>"
      output_buffer.puts "  </td>"
      if curr_column == (max_columns - 1) then output_buffer.puts "</tr>" end
      curr_column = (curr_column + 1) % (max_columns - 1)
    end

    if (curr_column != 0) then output_buffer.puts("</tr>") end
    if (file_count > 0) then output_buffer.puts("</table>") end
  end

  def move_tmp_to_final(example)
  if path_to_tmp(example) != path_to_screenshot(example)
      FileUtils.mv(path_to_tmp(example), path_to_screenshot(example))
    end
end
end

