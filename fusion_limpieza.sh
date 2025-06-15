#!/usr/bin/env bash

# Según el número de cámaras, se concatenan los archivos PCD
# y se limpia la nube de puntos resultante.

#Comentar los casos que no se vayan a usar y descomentar los que sí

# pcl_concatenate_points_pcd 2grabs/rosbag_recordings/cam1_1749590597276130.pcd \
#     2grabs/rosbag_recordings/cam2_1749590613788292.pcd 
# ./clean_pcd.sh 2grabs/output.pcd 2grabs/output_clean.pcd 0.35 0.45 0.08 50 0.8 0.003

pcl_concatenate_points_pcd 3grabs/rosbag_recordings/cam1_1749572117618343.pcd \
    3grabs/rosbag_recordings/cam2_1749572181868129.pcd \
    3grabs/rosbag_recordings/cam3_1749572220098401.pcd
./clean_pcd.sh 3grabs/output.pcd 3grabs/output_clean.pcd 0.35 0.45 0.075 45 0.8 0.003

# pcl_concatenate_points_pcd 4grabs/rosbag_recordings/cam1_1749590597209414.pcd \
#     4grabs/rosbag_recordings/cam2_1749590613821650.pcd \
#     4grabs/rosbag_recordings/cam3_1749590640708418.pcd \
#     4grabs/rosbag_recordings/cam4_1749590663592452.pcd
# ./clean_pcd.sh 4grabs/output.pcd 4grabs/output_clean.pcd 0.35 0.45 0.07 40 0.8 0.003