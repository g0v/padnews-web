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
  ..get '/json' (req, res) ->
    res.json do
      total: pad.news.length
      latest: pad.news.slice pad.news.length - 42
server  = require(\http).Server app
io      = require(\socket.io).listen server

# wait for awhile, lame hack
later = !->

setTimeout ->
  later := (event, data, i, diff) !->
    patch =
      op: if event is \create then \add else \replace
      path: "/#i"
      value: data
    io.sockets.emit \patch, patch
, 30000

pad.run do
  10000
  (event, data, i, diff) ->
    later event, data, i, diff

io.sockets.on \connection (socket) ->
  socket.emit \msg 'http://g0v.today'

server.listen process.env.PORT or 8888
