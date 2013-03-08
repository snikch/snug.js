# Snug

Snug reduces network overhead and processing time by resizing images selected in a `input[type=file]` on the client side before they’re sent to your server.

## Usage

Automatically resize all images to 600px wide:

```
new Snug({width: 600});

// This is effectively bound to `form input[type=file]` elements.
```

Specifying a custom dimensions callback:

```
var getDimensions = function(width, height){
	return { width: width / 2, height: height * 2 };
}
new Snug({ dimensions: getDimensions })
```

Specifying which forms to use:

```
new Snug({ forms: [document.getElementById('snugMe')], width: 600 })
```

Specifying the quality for JPEG compression:

```
new Snug({ width: 900, quality: 70 })
```

Handling the `imageload` event:

```
var imageDidLoad = function(image, element){
	var thumbImageId = element.id + "_thumbnail";
	document.getElementById(thumbImageId).src = image.src
}
new Snug({ imageload: imageDidLoad });

// File input #image would load into element #image_thumbnail etc.
```

## Handling data on the Server

The data sent is in the format "data:`mime_type`;base64,`base64_encoded_data`".

Ruby on Rails example of saving this information into a file:

```
match, mime, encoded = *data.match(/^data:(.+\/.+);base64,(.*)/)
	ext = MIME::Types[mime].first.extensions.first
	path = Dir::tmpdir + "mypic." + ext
	File.open(path, 'wb') do |f|
		f.write Base64.decode64(encoded)
	end
end
```

Note: You should obviously not hard code a filename like that, as it is non-atomic.


## Under the hood

Snug attaches to the `onchange` event of your file inputs. When you select an image, it uses a `canvas` to resize the image to the appropriate size, then stores the data into a hidden element with the name of the file input (and ensures the file input no longer gets submitted).

## Why
There are two benefits to doing this, one of which applies to most people, the other to a limited group.

Firstly, by doing this you’re reducing the time spent uploading images to the server, so your app will appear snappier as less data is being uploaded (and possibly processed).

Secondly, and this is the reason I created this, Heroku was choking on image manipulation. Each dyno only has 512mb of Ram and ran 3 processes – so they would often run out of memory. I could have used a cloud provider to handle the processing of images, but this method has the secondary benefit of reducing the upload time for users.


## TODO
* Check browser compatibility (Tested in Chrome only)

## Who

Created with love by [Mal Curtis](http://github.com/snikch)

Twitter: [snikchnz](http://twitter.com/snikchnz)

## License

MIT. See license file.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
