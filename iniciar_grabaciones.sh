#!/bin/sh

# Terminal 1
gnome-terminal -- bash -c "rosbag record -O record1.bag \
  /camera/depth/image_rect_raw \
  /camera/depth/camera_info \
  /tf; exec bash"

read dummy

# Terminal 2  
gnome-terminal -- bash -c "rosbag record -O record2.bag \
  /camera/color/image_raw \
  /camera/color/camera_info \
  /tf; exec bash"

# read dummy

# # Terminal 3
# gnome-terminal -- bash -c "rosbag record -O record3.bag \
#   /camera/infra1/image_rect_raw \
#   /camera/infra1/camera_info; exec bash"