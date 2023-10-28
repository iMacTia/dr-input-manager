require "smaug/dr_spec/lib/dr_spec/dragon_specs"

$gtk.reset(100)

def require_specs(current_dir = 'spec')
  files = $gtk.exec("ls #{current_dir}").split("\n")
  return unless files.is_a?(Array)

  files.each do |file|
    path, ext = file.split('.')
    if ext
      require "#{current_dir}/#{path}" if path.end_with?('_spec')
    else
      require_specs("#{current_dir}/#{path}")
    end
  end
end

alias :be_a :be_kind_of

require_specs 
puts "running tests"
