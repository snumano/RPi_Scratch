require "faraday"
# TCPSocket を使うため socket ライブラリを読み込みます
require "socket"

# localhost の TCP 番号 42001 番に接続します
socket = TCPSocket.open("localhost", 42001)

# for API
bridge_ip = ["192.168.11.3", "192.168.11.2", "192.168.11.4"]
api_key   = ["0XKpToZs32abteyjeo7VGED-8kilfZ5xASozaZ9-", "FHUpTcDacBmSNXrHCTSwSKPJ2DY2tV22cWcLuelY", "QaiyESlyKVQjjpsCikFie6lZw41d0RLOMEiHpTOi"] 

def api_put(bridge_ip, api_key, id, key, value)
  res = Faraday.put "http://" + bridge_ip + "/api/" + api_key + "/lights/" + id + "/state", "{\"hue\": #{value*100}}"
=begin
  client = Faraday.new(:url => "http://" + bridge_ip)
  res = client.put do |req|
    req.url  "/api/" + api_key + "/lights/" + id + "/state"
    req.headers['Content-Type'] = 'application/json'
#    req.body = "{\"hue\": #{value*100}}"
    req.body = "{\"hue\": #{value*100}}".to_json
  end
=end
  p "http://" + bridge_ip + "/api/" + api_key + "/lights/" + id + "/state"
  p key
  p value
  p '==='
  p res
end

loop do
  # 十分な長さのメッセージを読み取る
  message = socket.recv(100)

  # バイトで表示
  puts message.unpack("H*")[0]
  val = message.unpack("H*")[0].scan(/.{1,2}/)[15..-2].collect{|c| c.to_s.hex.chr}.join
  bridge = val.slice!(0).to_i
  id = val.slice!(0)
  p bridge
  p id

  if val =~ /on/
    api_put(bridge_ip[bridge - 1], api_key[bridge - 1], id, "on", "true")
  elsif val =~ /off/
    api_put(bridge_ip[bridge - 1], api_key[bridge - 1], id, "on", "false")
  elsif val =~ /\d+/
    api_put(bridge_ip[bridge - 1], api_key[bridge - 1], id, "hue", val.to_i)
  else
    val =  "err: " + val
  end
  p val

end
