Padnews = require \padnews
pad = new Padnews \sgyfCRGiBZC \g0v

pub = './public'

require! express
app     = express!
app
  ..use app.router
  #..use express.static pub
  ..set 'view engine' \jade
  ..get '/'     (req, res) -> res.render \index news: pad.news
  ..get '/json' (req, res) -> res.json pad.news
server  = require(\http).Server app
io      = require(\socket.io).listen server

pad.run do
  10000
  (event, data, i, diff) ->
    patch =
      op: if event is \create then \add else \replace
      path: "/#i"
      value: data
    io.sockets.emit \patch, patch

io.sockets.on \connection (socket) ->
  socket.emit \msg 'http://g0v.today'

server.listen 8888
