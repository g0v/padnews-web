if process.env.NODETIME_ACCOUNT_KEY
  require \nodetime .profile do
    accountKey: process.env.NODETIME_ACCOUNT_KEY
    appName: \congress-text-live

Padnews = require \padnews
pad = new Padnews \FRzDUBto4Vj

pub = './public'

require! express
(app     = express!)
  ..use app.router
  ..use express.static pub
  ..set 'view engine' \jade
  ..get '/'         (req, res) -> res.render \index news: pad.news
  ..get '/json/all' (req, res) ->
    res
      ..setHeader \Access-Control-Allow-Origin '*'
      ..json pad.news
  ..get '/json'     (req, res) ->
    res
      ..setHeader \Access-Control-Allow-Origin '*'
      ..json do
        total: pad.news.length
        latest: pad.news.slice pad.news.length - 42
  ..get '/json/:id(\\d+)' (req, res) ->
    entry = pad.news[parseInt req.params.id, 10]
    res
      ..setHeader \Access-Control-Allow-Origin '*'
      ..json entry, if entry then 200 else 404
server  = require(\http).Server app
(io     = require(\socket.io).listen server)
  ..set 'log level' 1

op-from-event =
  create: \add
  update: \replace
  remove: \remove

pad.run do
  10000
  (event, data, i, diff) ->
    if event is \ready
      server.listen process.env.PORT or 5000
    else
      patch =
        op: op-from-event[event]
        path: "/#i"
        value: data
      io.sockets.emit \patch, patch
