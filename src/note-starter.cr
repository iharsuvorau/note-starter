require "option_parser"
require "yaml"

module NoteStarter
  VERSION = "0.1.0"

  name = ""
  title = ""
  tags = [] of String

  OptionParser.parse do |parser|
    parser.banner = "Usage: note-starter [options]"
    parser.on("-n NAME", "--name NAME", "File name without .md suffix") { |v|
      name = v + ".md"
    }
    parser.on("-t TITLE", "--title TITLE", "Title of the note") { |v| title = v }
    parser.on("-l TAGS", "--tags TAGS", "Comma-separated list of tags") { |tt|
      tags = tt.split(",").map { |t| t.strip }
    }
    parser.on("-h", "--help", "Show this help") { puts parser; exit }
  end

  if name.empty?
    puts "No file name specified"
    exit 1
  end

  note = Note.new name, title, tags

  puts note.to_yaml
  note.to_file

  class Note
    property name : String
    property title : String
    property tags : Array(String)
    getter created_at : Time
    property published : Bool

    def initialize(name, title, tags)
      @name = name
      @title = title
      @tags = tags
      @created_at = Time.local
      @published = false
    end

    def to_yaml
      {
        title:      @title,
        tags:       @tags,
        created_at: @created_at,
        published:  @published,
      }.to_yaml
    end

    def to_file
      File.open(@name, "w") { |f|
        f.print to_yaml
        f.print "---\n\n"
      }
    end
  end
end
