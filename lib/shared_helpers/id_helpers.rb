module SharedHelpers
  module IdHelpers
    def element_id(*segments)
      Array(segments).join('_').gsub('+', '-')
    end
  end
end