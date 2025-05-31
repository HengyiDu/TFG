#!/bin/bash

rosrun nodelet nodelet standalone depth_image_proc/point_cloud_xyz \
  image_rect:=/cam1/depth/image_rect_raw \
  camera_info:=/cam1/depth/camera_info &

rosrun nodelet nodelet standalone depth_image_proc/point_cloud_xyz \
  image_rect:=/cam2/depth/image_rect_raw \
  camera_info:=/cam2/depth/camera_info &

rosrun nodelet nodelet standalone depth_image_proc/point_cloud_xyz \
  image_rect:=/cam3/depth/image_rect_raw \
  camera_info:=/cam3/depth/camera_info &

rviz