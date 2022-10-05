#!/bin/bash

docker container start WRF_container
#cd /home/lammoc/docker/volumes/GFS_volume
#./baixa_gfs_0p25.sh
docker exec WRF_container bash -c "paralelo/namelists/operacional/sistema.sh"
docker exec WRF_container bash -c "paralelo/namelists/operacional/sistema2.sh"
cd /home/lammoc/wrf-docker/scripts
./gerafiguras.sh
