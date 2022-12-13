COMMAND_REGEXP = /\A\$ (?<command>ls|cd)(?: (?<folder>.*))?\z/.freeze
FILE_REGEXP = /\A(?<dir_or_size>dir|\d+) (?<name>.*)\z/

input = File.readlines(ARGV[0] || "input", chomp: true)

file_tree = {}
context = "/"
processing = false

input[1..].each do |line|
  command_data = line.match COMMAND_REGEXP

  if processing && command_data.nil?
    current = context == '/' ? file_tree : file_tree.dig(*context.split('/')[1..])
    data = line.match FILE_REGEXP

    if data[:dir_or_size] == "dir"
      current[data[:name]] = {}
    else
      current[data[:name]] = data[:dir_or_size].to_i
    end
  else
    processing = false

    case command_data[:command]
    when "ls"
      processing = true
    when "cd"
      if command_data[:folder] == '..'
        context = context.split('/')[0..-2].join('/') + '/'
      else
        context += command_data[:folder] + '/'
      end
    end
  end
end

def count_size(directory, sizes = {}, context = "/")
  sizes[context] = 0

  directory.each do |name, value|
    if value.is_a? Integer
      sizes[context] += value
    else
      new_context = context + name + "/"
      sizes[context] += count_size(value, sizes, new_context)[new_context]
    end
  end

  sizes
end

sizes = count_size(file_tree)

puts sizes.values.select { |value| value <= 100000 }.sum
