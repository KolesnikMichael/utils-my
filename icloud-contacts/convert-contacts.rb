require "rubygems"
require "pry"

map = {
  "<ID>" => "VERSION:3.0\n",
  "<Position>" => "PRODID:-//Apple Inc.//iOS 7.1//EN\n",
  "<Name>" => "",
  "<LName>" => "",
  "<PhoneNo>" => "TEL;TYPE=CELL;type=pref;TYPE=VOICE:<PhoneNo>\n",
  "<HomeNo>" => "TEL;type=HOME;type=VOICE:<HomeNo>\n",
  "<OfficeNo>" => "TEL;type=WORK;type=VOICE:<OfficeNo>\n",
  "<FaxNo>" => "TEL;TYPE=WORK;TYPE=FAX:<FaxNo>\n",
  "<OtherNo>" => "TEL;TYPE=OTHER;TYPE=VOICE:<OtherNo>\n",
  "<Memo>" => "item1.ADR;type=HOME;type=pref:;;<Memo>;;;;;\n"}

vc_name_template = "N:<LName>;<Name>;;;\n"
vc_full_name_template = "FN:<Name><LName>\n"
contacts = File.read("phonebook.xml").split("</phonebook>\n")
vcf_file = File.new("phonebook.vcf", 'wb')

binding.pry

contacts.each do |contact|
  fields = contact.split("\n")
  fields.shift

  name = ""  
  last_name = ""
  
  vc = []
  vc << "BEGIN:VCARD\n"

  fields.each do |field|
    field_type = /<[[:alnum:]]+>/.match(field).to_s
    field_value = />(.+)</.match(field)[1]
    name = field_value if  field_type == "<Name>"
    last_name = field_value if  field_type == "<LName>"
    vc << vc_entry = map[field_type].gsub(field_type, field_value)
  end
  
  vc_name_entry = vc_name_template.gsub("<Name>", name).gsub("<LName>", last_name)
  vc.insert(4, vc_name_entry)

  vc_full_name_entry = vc_full_name_template.gsub("<Name>", name).gsub("<LName>", (" " + last_name)).gsub(": ", ":")
  vc.insert(5, vc_full_name_entry)

  vc << "REV:2014-04-12T19:58:50Z\nEND:VCARD\n"

  vc.each do |i|
    vcf_file << i
  end

end


vcf_file.close

