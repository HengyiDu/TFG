#!/bin/bash
# Limpiamos procesos en segundo plano
pkill -f "rosbag play"
pkill -f static_transform_publisher 
pkill -f nodelet
pkill -f rviz
sleep 1
cd rosbag_recordings
# Uso del tiempo simulado
rosparam set use_sim_time true
# Publicamos las transformaciones estáticas
rosrun tf2_ros static_transform_publisher 0 0 0 -1.04 0 -1.5708 \
      cam1_link camera_depth_optical_frame      __name:=tf_opt_cam1 &
rosrun tf2_ros static_transform_publisher 0.6 0 0 1.047 0 -1.5708 \
      cam1_link camera2_depth_optical_frame     __name:=tf_opt_cam2 &
rosrun tf2_ros static_transform_publisher 0.3 0.5196 0 3.1416 0 -1.5708 \
      cam1_link camera3_depth_optical_frame    __name:=tf_opt_cam3 &
# Reproducimos las grabaciones de rosbag
rosbag play --clock -l record1.bag \
    /camera/depth/image_rect_raw:=/cam1/depth/image_rect_raw \
    /camera/depth/camera_info:=/cam1/depth/camera_info \
    /tf:=/tf &
rosbag play --clock -l record2.bag \
    /camera/depth/image_rect_raw:=/cam2/depth/image_rect_raw \
    /camera/depth/camera_info:=/cam2/depth/camera_info \
    /tf:=/tf_ignore &      
rosbag play --clock -l record3.bag \
    /camera/depth/image_rect_raw:=/cam3/depth/image_rect_raw \
    /camera/depth/camera_info:=/cam3/depth/camera_info \
    /tf:=/tf_ignore & 
# Inicializamos el gestor de nodos de nodelet
rosrun nodelet nodelet manager __name:=nodelet_manager &
sleep 1
# Cargamos los nodos de procesamiento de imágenes y nubes de puntos
rosrun nodelet nodelet load depth_image_proc/point_cloud_xyz nodelet_manager \
       __name:=pc_cam1  image_rect:=/cam1/depth/image_rect_raw \
       camera_info:=/cam1/depth/camera_info  points:=/cam1/points &
rosrun nodelet nodelet load depth_image_proc/point_cloud_xyz nodelet_manager \
       __name:=pc_cam2  image_rect:=/cam2/depth/image_rect_raw \
       camera_info:=/cam2/depth/camera_info  points:=/cam2/points &
rosrun nodelet nodelet load depth_image_proc/point_cloud_xyz nodelet_manager \
       __name:=pc_cam3  image_rect:=/cam3/depth/image_rect_raw \
       camera_info:=/cam3/depth/camera_info  points:=/cam3/points &

# Publicamos las imágenes de las cámaras
rosrun relay_tools relay_cam2.py &
rosrun relay_tools relay_cam3.py &

sleep 1
# Iniciamos RViz para visualizar los datos
rviz