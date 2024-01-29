#!/usr/bin/env python3

# capture_training_images.py
# Low effort script used to capture images for the beard monitor training dataset
#   Captures 1 image every 10(ish) seconds
#   Are there better and smarter ways of doing this? Absolutely
# fswebcam options used:
#   -S 10   skip first 10 images, necessary as the first few images have poor color balancing
#   -q      keep the fswebcam logging quiet

import os, time
from datetime import datetime

target_dir = '../images'
while True:
	time_suffix = datetime.now().strftime("%m-%d-%y_%H%M%S")
	image_name = f'training_image_{time_suffix}.jpg'
	print(f'Capturing Image: {image_name}')
	os.system(f'fswebcam -r 1280x720 --no-banner {target_dir}/{image_name} -S 10 -q')
	time.sleep(10)
