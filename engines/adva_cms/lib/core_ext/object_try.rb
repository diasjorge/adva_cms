class Object
  # thx chris wanstrath, http://ozmm.org/posts/try.html
  def try(method, *args)
    send method, *args if respond_to? method
  end
  
  def in?(*array)
    array.include?(self)
  end
  
  def not_nil?
    !nil?
  end

  def not_blank?
    !blank?
  end
end

