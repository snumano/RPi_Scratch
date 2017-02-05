# TCPSocket を使うため socket ライブラリを読み込みます
require "socket"

# localhost の TCP 番号 42001 番に接続します
socket = TCPSocket.open("localhost", 42001)

loop do
  # 十分な長さのメッセージを読み取る
  message = socket.recv(100)

  # バイトで表示
  puts message.unpack("H*")[0]
  p message.unpack("H*")[0].scan(/.{1,2}/)[15..-2].collect{|c| c.to_s.hex.chr}.join.to_i
end
