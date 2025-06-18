#!/usr/bin/env bash
# clean_pcd.sh – Z passthrough → XY passthrough → SOR → VoxelGrid
set -e

if [ $# -ne 8 ]; then
  echo "Uso: $0 in.pcd out.pcd z_min z_max xy_half meanK stdDev voxel"
  exit 1
fi

IN="$1"; OUT="$2"
ZMIN="$3"; ZMAX="$4";  XY="$5"
MEANK="$6"; STD="$7";  VOX="$8"

TMP_1=$(mktemp --suffix=.pcd)
TMP_2=$(mktemp --suffix=.pcd)
TMP_3=$(mktemp --suffix=.pcd)
TMP_4=$(mktemp --suffix=.pcd)

echo "1 Passthrough Z [$ZMIN,$ZMAX]..."
pcl_passthrough_filter "$IN" "$TMP_1" z "$ZMIN" "$ZMAX"

echo "2 Passthrough X (±$XY m)..."
pcl_passthrough_filter "$TMP_1" "$TMP_2" x "-$XY" "$XY"

echo "3 Passthrough Y (±$XY m)..."
pcl_passthrough_filter "$TMP_2" "$TMP_3" y "-$XY" "$XY"

echo "4 Statistical Outlier Removal (K=$MEANK, σ=$STD)..."
pcl_outlier_removal "$TMP_3" "$TMP_4" -method statistical -meanK "$MEANK" -stddevMulThresh "$STD"

echo "5 VoxelGrid (leaf=$VOX m)..."
pcl_voxel_grid "$TMP_4" "$OUT" -leaf "$VOX" "$VOX" "$VOX"

rm -f "$TMP_1" "$TMP_2" "$TMP_3" "$TMP_4"
echo "-------- Nube filtrada guardada en $OUT--------"