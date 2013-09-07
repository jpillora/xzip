
compress = (str) ->
  buffer = new (if window.Uint8Array isnt `undefined` then Uint8Array else Array)(str.length)
  for i in [0..str.length]
    buffer[i] = str.charCodeAt(i) & 0xff
  return btoa String.fromCharCode.apply null, (new Zlib.Gzip(buffer)).compress()

xhook (xhr) ->
  xhr.beforeSend (callback) ->
    if xhr.body
      compressed = compress xhr.body
      console.log xhr.body, compressed
      if xhr.body.length > compressed.length
        xhr.setRequestHeader 'Content-Encoding', 'base64-gzip'
        xhr.body = compressed
    callback()
  return