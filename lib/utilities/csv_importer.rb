class CsvImporter

  # file_path can be a path to a local file or an url
  def initialize file_path, parser, options = {}
    @file_path = file_path
    @parser = parser
    # we need symbols as keys
    @options = options.deep_symbolize_keys
  end

  def run
    puts "Prepare to import #{@filepath} ..."
    count = 0
    SmarterCSV.process(@file_path, @options).each_with_index do |row, i|
      count += 1
      parse_row(row, i)
    end
    puts "Import #{@filepath} completed: #{count} rows processed."
    return count
  end

  def head size
    SmarterCSV.process(@file_path, @options.merge(chunk_size: size)).each do |chunk|
      return chunk.map { |row| parse_row(row, 0) }
    end
  end

  def parse_row row, i
    puts row
    if @parser
      @parser.parse row, i
    else
      row
    end
  end

end
