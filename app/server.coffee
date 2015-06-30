# server.coffee

# BASE SETUP
# =============================================================================

# set our port
port = process.env.PORT || 8080

# call the packages we need
express = require 'express'
app = express()
server = require 'http'
	.createServer app
bodyParser = require 'body-parser'
io = require 'socket.io'
	.listen(server)
device = require 'express-device'
mongoose = require 'mongoose'

try
	mongoose.connect 'mongodb://localhost'
catch ex
	console.log ex

#set the view engine
app.set 'view engine', 'ejs'
	.set 'views', __dirname + '/views'

app.use express.static __dirname + 'content'
	.use express.static __dirname + 'scripts'
	.use device.capture()
	.use bodyParser.urlencoded { extended: true }
	.use bodyParser.json()

# Socket.IO SETUP
# =============================================================================
io.sockets.on 'connection', (socket) ->
	io.sockets.emit 'blast', { msg:"someone connected" }
	socket.on 'blast', (data, fn) ->
		console.log data
		io.sockets.emit 'blast', { msg:data.msg }
		fn()

# Register Routes
# =============================================================================
router = express.Router()
router.get '/', (req, res) ->
	res.render 'index', {}

apiRouter = express.Router()
apiRouter.get '/', (req, res) ->
	res.json { message: 'hooray! welcome to our api!' }

BearsController = require './controllers/bears-controller'
app.use '/api', new BearsController()
	.use '/api', apiRouter
	.use '/', router

# START THE SERVER
# =============================================================================
server.listen port
console.log 'Magic happens on port ' + port