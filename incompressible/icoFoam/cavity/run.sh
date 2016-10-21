#!/bin/sh
#PJM --rsc-list "node=1"
#PJM --rsc-list "elapse=00:30:00"
#PJM -s
#PJM --name job
#PJM --stgin-dir "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/lib ./lib"
#PJM --stgin-dir "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/lib/dummy ./lib"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/blockMesh ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/setFields ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/icoFoam ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/foamToVTK ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/bin/tools/RunFunctions ./"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/etc/controlDict ./etc/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/etc/cellModels ./etc/"
#PJM --stgin-dir ". ./cavity recursive=3"
#PJM --stgout-dir "./cavity ./cavity.out recursive=3"
#
. /work/system/Env_base
#
export LD_LIBRARY_PATH=../lib:${LD_LIBRARY_PATH}
export PATH=../bin:${PATH}
export WM_PROJECT_SITE=../etc

cd cavity
. ../RunFunctions
echo "$(getApplication)"
# Set application name
application=`getApplication`

runApplication blockMesh
runApplication setFields
runApplication $application

echo "$(pwd)/.."
ls -l ..
# Convert to VTK
../bin/foamToVTK