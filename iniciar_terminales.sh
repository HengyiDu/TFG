#!/bin/bash
gnome-terminal -- bash -c "roscore; exec bash"

sleep 2  # Esperamos a que roscore inicie

gnome-terminal -- bash -c "roslaunch realsense2_camera rs_camera.launch \
  align_depth:=false \
  enable_color:=false \
  enable_infra1:=false \
  enable_infra2:=false \
  enable_pointcloud:=false \
  allow_no_texture_point_cloud:=true \
  depth_width:=640 \
  depth_height:=480 \
  depth_fps:=30 \
  initial_reset:=true; exec bash" 
