#!/bin/bash

rosbag play vista1.bag --clock \
  /camera/depth/image_rect_raw:=/cam1/depth/image_rect_raw \
  /camera/depth/camera_info:=/cam1/depth/camera_info \
  /tf:=/tf_cam1 &

rosbag play vista2.bag --clock \
  /camera/depth/image_rect_raw:=/cam2/depth/image_rect_raw \
  /camera/depth/camera_info:=/cam2/depth/camera_info \
  /tf:=/tf_cam2 &

rosbag play vista3.bag --clock \
  /camera/depth/image_rect_raw:=/cam3/depth/image_rect_raw \
  /camera/depth/camera_info:=/cam3/depth/camera_info \
  /tf:=/tf_cam3 &
