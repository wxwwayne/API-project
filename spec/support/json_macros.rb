module JsonMacros
  def parse_file(response)
    JSON.parse(response, symbolize_names: true)
  end
end
