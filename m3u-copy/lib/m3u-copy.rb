require "fileutils"
require "pathname"

class Playlist

  def initialize arg
    check_usage arg
    @contents = pathnames_from_playlist(Pathname.new(arg))
  end

  def print_help_and_exit(error_message)
    print "\nHELP: Copies files from the specified playlist to the destination folder.\n\n"
    print "Usage: M3U-COPY \"my playlist.m3u\" \"D:\\Temp\\My Music\" \n\n"
    puts 'ERROR: ' + error_message if error_message
    exit 1
  end

  def check_usage(str)
    help_switches = [nil, '/?', '-?', '/h', '-h', '/help', '-help']
    print_help_and_exit(nil) if help_switches.include?(str)
  end

  def pathnames_from_playlist(file_pathname)
    pathnames = []
    begin
      raise file_pathname.to_s + " is not a file." unless file_pathname.file?
    rescue Exception => e
      print_help_and_exit(e.message)
    end
    file_parent_dir = Pathname.new(file_pathname.dirname)
    rows = file_pathname.read.split("\n")
    rows.each do |item|
      path = file_parent_dir + item
      pathnames << path if path.file?
    end
    pathnames
  end

  def copy_to_dir(folder)
    files_counter = 0
    puts "\nCopying files to " + folder + ": "
    @contents.each do |item|
      filename = item.expand_path.basename
      print filename.to_s.chomp('/') + '...'
      begin
        FileUtils.cp item, Pathname.new(folder) + filename
      rescue Exception => e
        puts ' ERROR!'
        print_help_and_exit(e.message)
      end
      puts ' DONE.'
      files_counter += 1
    end
    print "\nCopied " + files_counter.to_s + " files.\n"
  end

end

