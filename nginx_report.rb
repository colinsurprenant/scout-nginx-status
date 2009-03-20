require 'open-uri'

class NginxReport < Scout::Plugin

  def build_report	  
    add_report(parse_nginx_status)
  end
  
  def parse_nginx_status
    parsers = [
      lambda { |line, status| status[:total] = $1.to_i if line =~ /^Active connections:\s+(\d+)/ },
      lambda { |line, status| nil },
      lambda { |line, status| status[:requests] = $3.to_i if line =~ /^\s+(\d+)\s+(\d+)\s+(\d+)/ },
      lambda do |line, status| 
        if line =~ /^Reading:\s+(\d+).*Writing:\s+(\d+).*Waiting:\s+(\d+)/
          status[:reading] = $1.to_i; status[:writing] = $2.to_i; status[:waiting] = $3.to_i
        end
      end  
    ]
    url = option(:url) || 'http://127.0.0.1/nginx_status'

    result = {}
    t = Time.now
    
    open(url) { |f| f.each_line { |line| parsers.shift.call(line, result) }}

    if (last_run_time = memory(:last_run_time))
      duration = t - last_run_time
      requests = result[:requests] - memory(:last_run_requests)
      result[:requests_per_s] = round_to(requests / duration, 1)
    else
      result[:requests_per_s] = 0.0
    end

    remember(:last_run_time => t, :last_run_requests => result[:requests])

    return result
  end
  
  def round_to(f, x)
    (f * 10**x).round.to_f / 10**x
  end

end





