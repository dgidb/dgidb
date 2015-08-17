class String
  def sanitize
    self.gsub(/<.*?>/, '')
  end
end