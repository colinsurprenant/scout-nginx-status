require 'open-uri'

class NginxReport < Scout::Plugin

  def build_report	  
    add_report(parse_nginx_status)
  end
  
  def parse_nginx_status
    parsers = [
      lambda { |line, status| status[:total] = $1 if line =~ /^Active connections:\s+(\d+)/ },
      lambda { |line, status| nil },
      lambda { |line, status| status[:requests] = $3 if line =~ /^\s+(\d+)\s+(\d+)\s+(\d+)/ },
      lambda do |line, status| 
        if line =~ /^Reading:\s+(\d+).*Writing:\s+(\d+).*Waiting:\s+(\d+)/
          status[:reading] = $1; status[:writing] = $2; status[:waiting] = $3
        end
      end  
    ]
    url = option(:url) || 'http://127.0.0.1/nginx_status'
    result = {}

    open(url) do |f|
      f.each_line do |line|
        parsers.shift.call(line, result)
      end
    end
    
    return result
  end
end





