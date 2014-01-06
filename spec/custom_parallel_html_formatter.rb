require_relative 'parallel_html_formatter'
require 'erb'
require_relative 'support/utilities'



class CustomParallelHtmlFormatter < ParallelHtmlFormatter
  include ERB::Util

  def initialize(output)
    super
    #  raise "output has to be a file path!" unless output.is_a?(String)
    @output_dir = File.dirname(@output)
  end

  def example_passed(example)
    example_passed_helper(example, @buffer)
  end

  def example_failed(example)
    example_failed_helper(example, @buffer)
  end

  def example_group_started(example_group)
    super(example_group)
  end

  def example_group_finished(example_group)
    super(example_group)
  end

  def example_started(example)
    super(example)
  end

  def print_screenshot(example)
    print_screenshot_helper(example, @buffer)
  end

  def example_pending(example)
    super(example)
  end

  def extra_failure_content(failure)
    content = []
    content << "<span>"
    content << ""
    content << "</span>"
    super + content.join($/)
  end

  def link_for(file_name)
    return unless file_name && File.exists?(file_name)

    description = File.extname(file_name).upcase[1..-1]
    path = Pathname.new(file_name)
    "<a href='#{path.relative_path_from(Pathname.new(@output_dir))}'>#{description}</a>&nbsp;"
  end

  # def start(example_count)
  #   lock_output do
  #     super(example_count)
  #   end
  # end
end