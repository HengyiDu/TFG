#!/usr/bin/env python3
import rospy
import tf2_ros
from sensor_msgs.msg import PointCloud2
from sensor_msgs.point_cloud2 import read_points, create_cloud_xyz32
import pcl_ros
import pcl
import os
from tf2_sensor_msgs.tf2_sensor_msgs import do_transform_cloud

class PointCloudTransformer:
    def __init__(self):
        rospy.init_node('pcd_transformer_saver', anonymous=True)
        
        # Tiempo simulado
        rospy.set_param('use_sim_time', True)
        
        # Buffer TF2 y listener
        self.tf_buffer = tf2_ros.Buffer()
        self.tf_listener = tf2_ros.TransformListener(self.tf_buffer)
        
        # Suscriptores a las nubes de puntos
        rospy.Subscriber("/cam1/points", PointCloud2, self.callback_cam1)
        rospy.Subscriber("/cam2/points_fixed", PointCloud2, self.callback_cam2)
        rospy.Subscriber("/cam3/points_fixed", PointCloud2, self.callback_cam3)
        
        # Contador para nombres de archivos
        self.counter = 0
        self.output_dir = "transformed_pcds"
        os.makedirs(self.output_dir, exist_ok=True)
        
        rospy.loginfo("Nodo listo para transformar y guardar PCDs.")

    def transform_and_save(self, cloud_msg, cam_name):
        try:
            # Obtener transformación al marco cam1_link
            transform = self.tf_buffer.lookup_transform(
                "cam1_link",  # Marco destino
                cloud_msg.header.frame_id,  # Marco origen
                rospy.Time(0),  # Tiempo (0 = último disponible)
                rospy.Duration(1.0)  # Timeout
            )
            
            # Aplicar transformación a la nube de puntos
            transformed_cloud = do_transform_cloud(cloud_msg, transform)
            
            # Guardar como PCD
            pcd_filename = f"{self.output_dir}/{cam_name}_{self.counter}.pcd"
            pcl_cloud = pcl.PointCloud()
            pcl_cloud.from_list(list(read_points(transformed_cloud)))
            pcl.save(pcl_cloud, pcd_filename, format="pcd")
            
            rospy.loginfo(f"Guardado {pcd_filename}")
            self.counter += 1
            
        except (tf2_ros.LookupException, tf2_ros.ConnectivityException, tf2_ros.ExtrapolationException) as e:
            rospy.logerr(f"Error en TF: {e}")

    def callback_cam1(self, msg):
        self.transform_and_save(msg, "cam1")

    def callback_cam2(self, msg):
        self.transform_and_save(msg, "cam2")

    def callback_cam3(self, msg):
        self.transform_and_save(msg, "cam3")

if __name__ == '__main__':
    try:
        transformer = PointCloudTransformer()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass