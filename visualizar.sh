#!/bin/bash

cd rosbag_recordings
# 1) Asegúrate de que ROS usa el tiempo del bag
rosparam set use_sim_time true

# 2) Publica el static transform para la primera cámara
rosrun tf2_ros static_transform_publisher \
  0 0 0   0 0 0 \
  camera_link cam1_link  &

# 3) Publica el static transform para la segunda cámara
rosrun tf2_ros static_transform_publisher \
  1 0 0   0 0 3.14159  \
  camera_link cam2_link &

rosbag play --clock record1.bag \
  /camera/depth/image_rect_raw:=/cam1/depth/image_rect_raw \
  /camera/depth/camera_info:=/cam1/depth/camera_info \
  /tf:=/tf &

# 5) Reproduce record2.bag remapeando a /cam2
rosbag play record2.bag \
  /camera/depth/image_rect_raw:=/cam2/depth/image_rect_raw \
  /camera/depth/camera_info:=/cam2/depth/camera_info \
  /tf:=/tf &

# 6) Arranca un único nodelet manager en modo standalone
rosrun nodelet nodelet manager __name:=nodelet_manager &
sleep 1 

# 7) Lanza el nodo de visualización de imágenes de profundidad
rosrun nodelet nodelet \
  load depth_image_proc/point_cloud_xyz nodelet_manager \
  __name:=point_cloud_xyz_cam1 \
  image_rect:=/cam1/depth/image_rect_raw \
  camera_info:=/cam1/depth/camera_info \
  points:=/cam1/points &

# 8) Lanza el nodo de visualización de imágenes de profundidad para la segunda cámara
rosrun nodelet nodelet \
  load depth_image_proc/point_cloud_xyz nodelet_manager \
  __name:=point_cloud_xyz_cam2 \
  image_rect:=/cam2/depth/image_rect_raw \
  camera_info:=/cam2/depth/camera_info \
  points:=/cam2/points &

# 9) Finalmente, lanza RViz
rviz

