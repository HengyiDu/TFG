#!/bin/bash

# Limpiamos procesos en segundo plano
pkill -f "rosbag play"
pkill -f static_transform_publisher 
pkill -f nodelet
pkill -f rviz
sleep 1

cd rosbag_recordings

# 1) Todos los nodos usarán el reloj del bag
rosparam set use_sim_time true

# 2) Publicamos las transformaciones estáticas , se pueden quitar estas tf
# rosrun tf2_ros static_transform_publisher 0 0 0 1.5708 -1.5708 0 \
#        camera_link cam1_link __name:=tf_cam1 &
# rosrun tf2_ros static_transform_publisher 1 0 0 3.1416 0 -1.5708 \
#        camera_link cam2_link   __name:=tf_cam2 &

# arreglar los frames id y luego los ejes de las camaras

rosrun tf2_ros static_transform_publisher 1 0 0 0 0 -1.5708 \
      cam1_link camera_depth_optical_frame      __name:=tf_opt_cam1 &
rosrun tf2_ros static_transform_publisher 0 0 1 0 3.1416 0 \
      camera_depth_optical_frame camera2_depth_optical_frame     __name:=tf_opt_cam2 &

# 3) Reproduce los bags.
rosbag play --clock -l record1.bag \
    /camera/depth/image_rect_raw:=/cam1/depth/image_rect_raw \
    /camera/depth/camera_info:=/cam1/depth/camera_info \
    /tf:=/tf &

rosbag play --clock -l record2.bag \
    /camera/depth/image_rect_raw:=/cam2/depth/image_rect_raw \
    /camera/depth/camera_info:=/cam2/depth/camera_info \
    /tf:=/tf_ignore &      # /tf del segundo bag sigue mapeado a otro nombre

# 4) Nodelet manager y PointClouds
rosrun nodelet nodelet manager __name:=nodelet_manager &
sleep 1

rosrun nodelet nodelet load depth_image_proc/point_cloud_xyz nodelet_manager \
       __name:=pc_cam1  image_rect:=/cam1/depth/image_rect_raw \
       camera_info:=/cam1/depth/camera_info  points:=/cam1/points &

rosrun nodelet nodelet load depth_image_proc/point_cloud_xyz nodelet_manager \
       __name:=pc_cam2  image_rect:=/cam2/depth/image_rect_raw \
       camera_info:=/cam2/depth/camera_info  points:=/cam2/points &

# 5) Arranca RViz después de que /clock ya fluya
# source devel/setup.bash <-- dentro de .bashrc
rosrun relay_tools relay_cam2.py &

rviz   # en Global Options fija “Fixed Frame” a cam1_link (o cam2_link)
