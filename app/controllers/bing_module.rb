require 'open-uri'
require 'json'
require 'nokogiri'

module BingModule

  # Bing搜索API访问常量
  BING_APP_ID     = "U2PCgcGupxwnmqdz3KeX58shHWZeFtkrku1E2U4Mm6c"
  BING_SEARCH_API = "https://api.datamarket.azure.com/Bing/SearchWeb/v1/Web?$format=json&"

  # 通过Bing搜索关键词。
  # 返回JSON格式，出现异常返回nil。
  # 只调网页搜索接口，每月配额5000。
  def search_by_bing(query)
    begin
      form = URI.encode_www_form([[:Query, "'#{query}'"]]) #转义query
      uri  = "#{BING_SEARCH_API}#{form}"
      resp = open(uri, {http_basic_authentication: [BING_APP_ID, BING_APP_ID]}) #访问接口、权限验证
      json = JSON.parse(resp.read)
      return json["d"]["results"]
    rescue SocketError => e
      return nil
    end
  end

  def top_title_from_bing_results(results)
    return "" if results.empty?
    return results.first["Title"]
  end

  def top_url_from_bing_results(results)
    return "" if results.empty?
    return results.first["Url"]
  end

  module_function
  
end