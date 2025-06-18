#!/usr/bin/env python3
import sys, numpy as np, pcl

def load_and_clean(path):
    cloud = pcl.load(path)                  # nube original
    arr = cloud.to_array()                  # Nx3 ó Nx4  (XYZ[RGB])
    mask = ~np.isnan(arr).any(axis=1)       # filas sin NaN
    arr_clean = arr[mask].astype(np.float32)
    cloud_clean = pcl.PointCloud()
    cloud_clean.from_array(arr_clean)       # nube sin NaN
    return cloud_clean

def aabb_dims(cloud):
    pts = cloud.to_array()
    min_xyz, max_xyz = pts.min(0), pts.max(0)
    return max_xyz - min_xyz                # dx,dy,dz

def dens_xy(cloud, dx, dy):
    return cloud.size / (dx*dy*1e4)         # pt/cm²

def ruido_z(cloud, voxel=0.005):
    vg = cloud.make_voxel_grid_filter()
    vg.set_leaf_size(voxel, voxel, voxel)
    fil = vg.filter()
    return np.std(fil.to_array()[:, 2])

if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Uso:  eval_intrinseco.py nube.pcd")
    cloud = load_and_clean(sys.argv[1])
    if cloud.size == 0:
        sys.exit("La nube quedó vacía tras eliminar NaN.")

    dx, dy, dz = aabb_dims(cloud)
    print(f"AABB (mm): {dx*1000:.1f} x {dy*1000:.1f} x {dz*1000:.1f}")
    print(f"Densidad XY: {dens_xy(cloud, dx, dy):.2f} pt/cm²")
    print(f"Ruido Z: {ruido_z(cloud)*1000:.2f} mm")
