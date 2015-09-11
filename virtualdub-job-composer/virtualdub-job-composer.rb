require "pathname"

#ouch

root_folder = Pathname.new('D:/Temp/video')
avi_list = root_folder + 'in' + 'list.csv'

JOBS_FILE = root_folder.to_s + '/VirtualDubMod.jobs'
COMPRESSION = '0x75796668,0,10000,0'

def create_new_jobs_file
  File.new(JOBS_FILE, 'w')
  lines = <<EOF
// VirtualDub job list (Sylia script format)
//
// $numjobs 0
//
EOF
  add_lines_to_jobs_file lines
end

def add_lines_to_jobs_file(lines)
  current_contents = File.read(JOBS_FILE)
  File.open JOBS_FILE, 'w' do |f|
    f.write current_contents + lines
  end
end

def increment_jobs_count
  contents = File.read(JOBS_FILE)
  new_jobs_count = /(\$numjobs\s)(\d+)/.match(contents)[2].to_i + 1
  contents = contents.gsub(/(\$numjobs\s)(\d+)/, '$numjobs ' + new_jobs_count.to_s)
  File.open JOBS_FILE, 'w' do |f|
    f.write contents
  end
end

def close_jobs_file
  lines = <<EOF
//
// $done
EOF
  add_lines_to_jobs_file lines
end

def add_job(avi)
  lines = <<EOF
//
// $job "#{avi}"
// $input ""
// $output ""
// $state 0
// $start_time 0 0
// $end_time 0 0
// $script
//
EOF
  add_lines_to_jobs_file lines
  increment_jobs_count
end

def close_job(avi)
  lines = <<EOF
VirtualDub.SaveAVI("D:\\\\Temp\\\\video\\\\out\\\\#{avi}");
VirtualDub.Close();
//
// $endjob
//-------------------------------------
EOF
  add_lines_to_jobs_file lines
end

def open_avi(avi)
  lines = <<EOF
VirtualDub.Open("D:\\\\Temp\\\\video\\\\misc\\\\30f.avi","",0);
VirtualDub.Append("D:\\\\Temp\\\\video\\\\in\\\\#{avi}");
VirtualDub.Append("D:\\\\Temp\\\\video\\\\misc\\\\30f.avi");
VirtualDub.RemoveInputStreams();
VirtualDub.stream[0].SetSource(0x73647561,0);
VirtualDub.stream[0].DeleteComments(1);
VirtualDub.stream[0].AdjustChapters(1);
VirtualDub.stream[0].SetMode(0);
VirtualDub.stream[0].SetInterleave(1,500,1,0,1000);
VirtualDub.stream[0].SetClipMode(1,1);
VirtualDub.stream[0].SetConversion(0,0,0,0,0);
VirtualDub.stream[0].SetVolume();
VirtualDub.stream[0].SetCompression();
VirtualDub.stream[0].EnableFilterGraph(0);
VirtualDub.stream[0].filters.Clear();
VirtualDub.video.DeleteComments(1);
VirtualDub.video.AdjustChapters(1);
VirtualDub.video.SetDepth(24,24);
VirtualDub.video.SetMode(3);
VirtualDub.video.SetFrameRate(0,1);
VirtualDub.video.SetIVTC(0,0,-1,0);
VirtualDub.video.SetCompression(#{COMPRESSION});
EOF
  add_lines_to_jobs_file lines
end

def apply_deshaker(avi)
  lines = <<EOF
VirtualDub.video.filters.Clear();
VirtualDub.video.filters.Add("Deshaker v2.4");
VirtualDub.video.filters.instance[0].Config("12|1|10|4|1|0|1|0|640|480|0|1|1|200|200|200|2000|4|1|2|2|20|40|300|4|D:\\\\Temp\\\\video\\\\misc\\\\Deshaker.log|0|0|0|0|0|0|0|0|0|0|0|0|0|1|10|10|10|10|1|1|30|30|0|0|0|0|1|1|0|20|1|15|1000|1|88");
VirtualDub.SaveAVI("D:\\\\Temp\\\\video\\\\temp\\\\#{avi}");
VirtualDub.video.filters.Clear();
VirtualDub.video.filters.Add("Deshaker v2.4");
VirtualDub.video.filters.instance[0].Config("12|2|10|4|1|0|1|0|640|480|0|1|1|200|200|200|2000|4|1|0|2|20|40|300|4|D:\\\\Temp\\\\video\\\\misc\\\\Deshaker.log|0|0|0|0|0|0|0|0|0|0|0|0|0|1|10|10|10|10|1|1|30|30|0|0|0|0|1|1|0|20|1|15|1000|1|88");
VirtualDub.SaveAVI("D:\\\\Temp\\\\video\\\\temp\\\\#{avi}");
VirtualDub.Close();
VirtualDub.Open("D:\\\\Temp\\\\video\\\\temp\\\\#{avi}","",0);
VirtualDub.RemoveInputStreams();
VirtualDub.stream[0].SetSource(0x73647561,0);
VirtualDub.stream[0].DeleteComments(1);
VirtualDub.stream[0].AdjustChapters(1);
VirtualDub.stream[0].SetMode(0);
VirtualDub.stream[0].SetInterleave(1,500,1,0,0);
VirtualDub.stream[0].SetClipMode(1,1);
VirtualDub.stream[0].SetConversion(0,0,0,0,0);
VirtualDub.stream[0].SetVolume();
VirtualDub.stream[0].SetCompression();
VirtualDub.stream[0].EnableFilterGraph(0);
VirtualDub.stream[0].filters.Clear();
VirtualDub.video.DeleteComments(1);
VirtualDub.video.AdjustChapters(1);
VirtualDub.video.SetDepth(24,24);
VirtualDub.video.SetMode(3);
VirtualDub.video.SetFrameRate(0,1);
VirtualDub.video.SetIVTC(0,0,-1,0);
VirtualDub.video.SetCompression(#{COMPRESSION});
VirtualDub.video.SetRange(2000,1);
EOF
  add_lines_to_jobs_file lines
end

def apply_the_rest(options)
  noiseware = options[0]
  levels_black = convert_levels_to_hex(options[1])
  levels_grey = convert_levels_grey_to_hex(options[2])
  levels_white = convert_levels_to_hex(options[3])
  saturation = convert_saturation_to_something(options[4])
  lines = <<EOF
VirtualDub.video.filters.Clear();
VirtualDub.video.filters.Add("Neat Video");
VirtualDub.video.filters.instance[0].Config("C:\\\\Program Files\\\\Neat Video for VirtualDub\\\\Profiles\\\\RecentProfile.dnp", "C:\\\\Program Files\\\\Neat Video for VirtualDub\\\\PRESETS\\\\No filtration.nfp", "1.000000", "#{noiseware}");
VirtualDub.video.filters.Add("levels");
VirtualDub.video.filters.instance[1].Config(#{levels_black},#{levels_white},#{levels_grey},0x0000,0xFFFF, 1);
VirtualDub.video.filters.Add("HSV adjust");
VirtualDub.video.filters.instance[2].Config(0,#{saturation},0);
VirtualDub.video.filters.Add("resize");
VirtualDub.video.filters.instance[3].SetClipping(10,5,10,5);
VirtualDub.video.filters.instance[3].Config(720,480,7);
EOF
  add_lines_to_jobs_file lines
end

def convert_levels_to_hex(str)
  level_hex = "0x"+ (str.to_i * 257).to_s(16).upcase
end

def convert_levels_grey_to_hex(str)
  integer_part = str.split(".")[0]
  fraction_part_hex = (str.split(".")[1].to_i * 16777).to_s(16).upcase
  fraction_part_normalized = '0'*(6 - fraction_part_hex.size) + fraction_part_hex
  level_grey_hex = "0x0#{integer_part}" + fraction_part_normalized
end

def convert_saturation_to_something(str)
  something = (str.to_i - 100) * 656 + 65536
end

if File.exists?(JOBS_FILE)
#  raise "Can't create new jobs file, remove existing one first."
  File.delete(JOBS_FILE)
  create_new_jobs_file
else
  create_new_jobs_file
end

avis = File.read(avi_list).split("\n")[2..-1]
avis.each do |line|
  avi = line.split(";")[0]
  options = line.split(";")[1..-1]
  add_job avi
  open_avi avi
  apply_deshaker avi
  apply_the_rest options
  close_job avi
end

close_jobs_file





