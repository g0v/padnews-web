Padnews = require \padnews
pad = new Padnews \sgyfCRGiBZC \g0v

pub = './public'

require! express
app     = express!
app
  ..use app.router
  ..use express.static pub
  ..set 'view engine' \jade
  ..get '/' (req, res) -> res.render \index news: pad.news
server  = require(\http).Server app
io      = require(\socket.io).listen server

pad.run do
  10000
  (event, data) ->
    io.emit \updated data

io.sockets.on \connection (socket) ->
  socket.emit \news pad.news

server.listen 8888
