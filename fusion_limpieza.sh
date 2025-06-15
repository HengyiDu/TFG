#!/usr/bin/env bash

# Según el número de cámaras, se concatenan los archivos PCD
# y se limpia la nube de puntos resultante.

#Comentar los casos que no se vayan a usar y descomentar los que sí

# pcl_concatenate_points_pcd 2grabs/transformed_pcds/cam1_.pcd \
#     2grabs/transformed_pcds/cam2_.pcd 
# ./clean_pcd.sh 2grabs/output.pcd 2grabs/output_clean.pcd 0.35 0.45 0.08 50 0.8 0.003

pcl_concatenate_points_pcd 3grabs/transformed_pcds/cam1_0.pcd \
    3grabs/transformed_pcds/cam2_1.pcd \
    3grabs/transformed_pcds/cam3_5.pcd
./clean_pcd.sh 3grabs/output.pcd 3grabs/output_clean.pcd 0.35 0.45 0.075 45 0.8 0.003

pcl_concatenate_points_pcd 4grabs/transformed_pcds/cam1_1.pcd \
    4grabs/transformed_pcds/cam2_1.pcd \
    4grabs/transformed_pcds/cam3_1.pcd \
    4grabs/transformed_pcds/cam4_0.pcd
./clean_pcd.sh 4grabs/output.pcd 4grabs/output_clean.pcd 0.35 0.45 0.07 40 0.8 0.003