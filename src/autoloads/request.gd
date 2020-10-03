# HTTP Manager is ued to send HTTP GET or POST Requests to a server
# supports asynchronous calls with callback function see: on_request_completed

extends Node

var requests = []

func _ready():
	requests = []

func send (url, query = '', data = '', callback = null, parent = null, callbackparams = []):

#	print("http node created..")

	var request = HTTPRequest.new()
	#request.set_script(preload("res://game/autoloads/http.gd"))

	# default for HTTP Request
	request.max_redirects = 5
	# disabling use_threads as not supported for html5
	if OS.get_name() == 'HTML5':
		request.use_threads = false
	else:
		request.use_threads = true
#	request.set_block_signals(false)
	request.body_size_limit = 1024*1024*5

	#get_tree().get_root().add_child(request)
	add_child(request)

	_send (request, url, query, data, callback, parent, callbackparams)
	requests.append(request)
	return request

func cancel(request):
	request.cancel()


# general request completion information
# use this func signature for callback methods
# call this func to get response
func on_request_completed(result, response_code, headers, body, params = []):
	#disconnect("request_completed", self, "_on_request_completed")
	if result == HTTPRequest.RESULT_SUCCESS and response_code == HTTPClient.RESPONSE_OK:

		# TODO: check for Content-Type: text/html; charset=UTF-8
		# to automatically convert from json and get_string from utf8

		var body_parsed = parse_json(body.get_string_from_ascii())
		# body is a PoolByteArray
		# body = body.get_string_from_ascii()
		body = body.get_string_from_utf8()


		#print("Request succeeded - body: ", body, " headers: ", headers)

		return {"headers": headers, "body": body, "body_parsed": body_parsed, "params": params}
	else:
		printerr("Request failed - Code: ", result, " HTTP Status: ", response_code)
		return false


# send query to url with parameters query and postdata data
# on completion call callback on parent
# use signature of on_request_complete for callback func
func _send(request, url, query = '', data = '', callback = null, parent = null, callbackparams = []):

	var method = HTTPClient.METHOD_GET;
	if data:
		method = HTTPClient.METHOD_POST
		data = _buildpost(data)
	if query:
		query = _buildquery(url, query)

	# setup callbacks to custom func
	if !callback or !parent:
		callback = "on_request_completed"
		parent = self

	# check if connection to signal is still available
	if !request.is_connected("request_completed", parent, callback):
		request.connect("request_completed", parent, callback, callbackparams, CONNECT_ONESHOT)
		request.connect("request_completed", self, "_remove_node", [request], CONNECT_ONESHOT | CONNECT_DEFERRED)
	else :
		printerr("Connecting to signal: request_completed on parent: ", parent, " with method ", callback, " failed. already connected..")

	# include /etc/ssl/certs/ca-certificates.crt into project settings
	# if you want to make a validated connection to https servers
	var check_certificate = false
	if ProjectSettings.has_setting("network/ssl/certificates"):
		check_certificate = true

	# START HTTP REQUEST
	request.request(url + query, _header(data), check_certificate, method, data )

#	print("starting ", method, " Request to url: ", url+query, " data ", data, " returns: ", code)

# generates header for reuqest
func _header(data):
	var header = [
		"Content-Type: application/x-www-form-urlencoded",
		#"Content-Type: application/json",
	]
	if data:
		header.append("Content-Length: " + str(data.length()))
	return header

# skip json, use query function instead
func _buildpost(data):
	var result = null
	if data:
		var httpClient = HTTPClient.new()
		result = httpClient.query_string_from_dict(data)
	return result

# creates query string of possible array
func _buildquery(url, query):
	var result = ""
	# concatinate string arrays to one string and encode it properly
	if typeof( query ) == TYPE_ARRAY or typeof( query ) == TYPE_STRING_ARRAY :
		result = PoolStringArray(query).join("&").percent_encode()

	# make querystring out of dictionaries - hopefull encoding it automatically?
	elif typeof ( query ) == TYPE_DICTIONARY :
		var httpClient = HTTPClient.new()
		result = httpClient.query_string_from_dict(query)

	# just use ready to use query string
	elif typeof ( query ) == TYPE_STRING :
		result = query

	# check if url already has a ?
	if result:
		if url.find('?') == -1:
			result = '?' + result
		else:
			result = '&' + result
	return result

# removes self from tree
#warning-ignore-all:unused_variable
func _remove_node(result, response_code, headers, body, request):
	if request:
		# print_debug("http node removed..", "code: ", response_code, " ", request)
		requests.remove(requests.find(request))
		request.queue_free()
