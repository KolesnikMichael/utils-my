# Provides a list of empty sub-folders found under a current one,
# and then erases them, if confirmed.

require 'pry'

folders = []

def folder_empty?(folder)
  return true if (Dir.entries(folder) - ["..", "."]).size == 0
  false
end

def remove_empty_folders(folders)
  doomed_folders = []
  folders.each { |folder| doomed_folders << folder if folder_empty?(folder) }
  return "No (more) empty folders found. See you!" if doomed_folders == []
  puts "===> folders to remove:"
  puts doomed_folders
  puts "===> proceed?.."
  print "===> "
  return "As you wish, bye!" unless gets.chomp.downcase == 'yes'
  doomed_folders.each do |folder|
    Dir.delete(folder)
  end
  remove_empty_folders(folders - doomed_folders)
end

Dir.glob("**/*") do |item|
  folders << item unless File.file?(item)
end

puts remove_empty_folders(folders)
