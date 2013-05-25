module UtilModule

  # 判断string是否是url。
  # 必须是http或https开头，现不支持直接填写网址方式。
  def is_url(string)
    puts "this's is_url..........."
    urlRegexp = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
    result = urlRegexp.match(string) ? true : false
    return result
  end

  module_function
  
end