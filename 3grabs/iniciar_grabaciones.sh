#!/bin/bash

cd rosbag_recordings

rosparam set use_sim_time false

rosbag record -O record1.bag \
  --duration=5 \
  /camera/depth/image_rect_raw \
  /camera/depth/camera_info \
  /tf

echo "Press Enter to continue..."
read dummy

rosbag record -O record2.bag \
  --duration=5 \
  /camera/depth/image_rect_raw \
  /camera/depth/camera_info \
  /tf

echo "Press Enter to continue..."
read dummy

rosbag record -O record3.bag \
  --duration=5 \
  /camera/depth/image_rect_raw \
  /camera/depth/camera_info \
  /tf

cd ..