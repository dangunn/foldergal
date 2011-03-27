# resize an image using the PIL image library
# free from:  http://www.pythonware.com/products/pil/index.htm
# tested with Python24        vegaseat     11oct2005

import Image
import sys

imageFile = sys.argv[1];

# open an image file (.bmp,.jpg,.png,.gif) you have in the working folder
im1 = Image.open(imageFile)

MAX_HEIGHT=450.0
MAX_WIDTH=400.0

height=im1.size[1]
width=im1.size[0]

if (height > MAX_HEIGHT):
  f=MAX_HEIGHT/height
  width=int(width*f)
  height=int(height*f)

if (width > MAX_WIDTH):
  f=MAX_WIDTH/width
  width=int(width*f)
  height=int(height*f)

print "w %s h %s" % (width, height)

# adjust width and height to your needs
# use one of these filter options to resize the image
#im2 = im1.resize((width, height), Image.NEAREST)      # use nearest neighbour
#im3 = im1.resize((width, height), Image.BILINEAR)     # linear interpolation in a 2x2 environment
#im4 = im1.resize((width, height), Image.BICUBIC)      # cubic spline interpolation in a 4x4 environment
im5 = im1.resize((width, height), Image.ANTIALIAS)    # best down-sizing filter

ext = ".jpg"
#im2.save("NEAREST" + ext)
#im3.save("BILINEAR" + ext)
#im4.save("BICUBIC" + ext)
im5.save("out" + ext)
print "Done.. image out" + ext + " saved"
