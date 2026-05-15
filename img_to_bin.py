###########################################################################################
# bin.py: Dump almost any image file in the current directory into ".bin" as RGB565 format
###########################################################################################
# Claude AI Opus 4.7 was used to generate this python code
# This code may not be perfect, but it functions as we expected
###########################################################################################
# Authors: Zarif Karim, Nikhil Sampath, Arnav Muthiayen
# Date:    5/14/26
###########################################################################################
# Python Version: 2.7.3
###########################################################################################

import os
from PIL import Image
import struct

def convert_to_16bit_binary(input_image_path, output_file_path):
    img = Image.open(input_image_path)

    if img.size != (640, 480):
        print("Resizing image from " + str(img.size) + " to 640x480")
        img = img.resize((640, 480), Image.ANTIALIAS)

    img = img.convert('RGB')

    with open(output_file_path, 'wb') as f:
        for y in range(480):
            for x in range(640):
                r, g, b = img.getpixel((x, y))

                r5 = (r >> 3) & 0x1F
                g6 = (g >> 2) & 0x3F
                b5 = (b >> 3) & 0x1F

                pixel_16bit = (r5 << 11) | (g6 << 5) | b5

                f.write(struct.pack('<H', pixel_16bit))

    print("Converted '" + input_image_path + "' to '" + output_file_path + "'")


script_dir = os.path.dirname(os.path.abspath(__file__))
valid_extensions = ('.jpg', '.jpeg', '.png', '.bmp')

for filename in os.listdir(script_dir):
    if filename.lower().endswith(valid_extensions):
        input_path = os.path.join(script_dir, filename)
        output_path = os.path.join(script_dir, os.path.splitext(filename)[0] + '.bin')
	if os.path.exists(output_path):
            print("Skipping " + filename + " because " + os.path.basename(output_path) + " already exists")
            continue
        convert_to_16bit_binary(input_path, output_path)
