# Recursively scans MP3 files starting from a current folder,
# and creates a table of contents with folders opposed by 
# a starting track number found in them.

track_no = 1
last_seen_folder = nil

def get_folder(path)
  path_elements = path.split("\/")
  path_elements.pop
  folder = File.join(path_elements)
end

File.open("mp3-toc.txt", "w") do |file|

  Dir.glob("**/*.mp3") do |track_path|
    track_folder = get_folder(track_path)

    if track_folder != last_seen_folder
      file.write "#{track_folder}: #{track_no}\n"
      last_seen_folder = track_folder
    end

    track_no += 1
  end
end

