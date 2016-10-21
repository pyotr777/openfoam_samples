#! /bin/sh -x
#PJM --rsc-list "node=6"
#PJM --rsc-list "elapse=01:30:00"
#PJM -s
#PJM --name job
#PJM --stgin-dir "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/lib ./lib"
#PJM --stgin-dir "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/lib/fjmpi ./lib"
#PJM --stgin-dir "/home/ra000007/a03106/OpenFOAM/ThirdParty-2.4.0/platforms/S64FXFccDPOpt/lib ./lib"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/lib/dummy/libmetisDecomp.so ./lib/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/blockMesh ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/surfaceFeatureExtract ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/snappyHexMesh ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/createBaffles ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/mergeOrSplitBaffles ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/setFields ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/createPatch ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/interDyMFoam ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/decomposePar ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/reconstructPar ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/platforms/S64FXFccDPOpt/bin/foamToVTK ./bin/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/bin/tools/RunFunctions ./"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/etc/controlDict ./etc/"
#PJM --stgin "/home/ra000007/a03106/OpenFOAM/OpenFOAM-2.4.0/etc/cellModels ./etc/"
#PJM --stgin-dir "mixerVesselAMI mixerVesselAMI recursive=3"
#PJM --stgout-dir "mixerVesselAMI out recursive=3"
#
. /work/system/Env_base
#
export LD_LIBRARY_PATH=../lib:${LD_LIBRARY_PATH}
export PATH=../bin:${PATH}
export WM_PROJECT_SITE=../etc
export MPI_BUFFER_SIZE=20000000

cd mixerVesselAMI
. ../RunFunctions
echo "$(getApplication)"
# Set application name
application=`getApplication`

mv 0.org 0

# Meshing
runApplication blockMesh
runApplication surfaceFeatureExtract
runApplication snappyHexMesh -overwrite
runApplication createBaffles -overwrite
runApplication mergeOrSplitBaffles -split -overwrite

# Initialize alpha
runApplication setFields

# Get rid of zero faced patches
runApplication createPatch -overwrite

# Decompose
runApplication decomposePar -force

# Run
runParallel $application 6

# Reconstruct
runApplication reconstructPar -noFunctionObjects

echo "$(pwd)/.."
ls -l ..
# Convert to VTK
../bin/foamToVTK

