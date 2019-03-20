#!/bin/bash



# The following block can be used by the job system
# to ensure this script is runnable before actually attempting
# to run it.
#HowGalaxy run the Docker 
if [ -n "$ABC_TEST_JOB_SCRIPT_INTEGRITY_XYZ" ]; then
    exit 42
fi

GALAXY_SLOTS="1"; export GALAXY_SLOTS;
export GALAXY_SLOTS
PRESERVE_GALAXY_ENVIRONMENT="False"
GALAXY_LIB="/home/galaxy/galaxy/lib"
if [ "$GALAXY_LIB" != "None" -a "$PRESERVE_GALAXY_ENVIRONMENT" = "True" ]; then
    if [ -n "$PYTHONPATH" ]; then
        PYTHONPATH="$GALAXY_LIB:$PYTHONPATH"
    else
        PYTHONPATH="$GALAXY_LIB"
    fi
    export PYTHONPATH
fi

GALAXY_VIRTUAL_ENV="/home/galaxy/galaxy/.venv"
if [ "$GALAXY_VIRTUAL_ENV" != "None" -a -z "$VIRTUAL_ENV" \
     -a -f "$GALAXY_VIRTUAL_ENV/bin/activate" -a "$PRESERVE_GALAXY_ENVIRONMENT" = "True" ]; then
    . "$GALAXY_VIRTUAL_ENV/bin/activate"
fi
echo "$GALAXY_SLOTS" > '/export/job_work_dir/001/1414/__instrument_core_galaxy_slots' 
date +"%s" > /export/job_work_dir/001/1414/__instrument_core_epoch_start
cd /export/job_work_dir/001/1414
rm -rf working; mkdir -p working; cd working; sudo docker inspect rcaloger/crosslabel > /dev/null 2>&1
[ $? -ne 0 ] && sudo docker pull rcaloger/crosslabel > /dev/null 2>&1

sudo docker run -e '"GALAXY_SLOTS=$GALAXY_SLOTS"' -v /home/galaxy/galaxy:/home/galaxy/galaxy:ro -v /home/galaxy/galaxy/tools/mytool/rCASC_wrappers/CrossLabel:/home/galaxy/galaxy/tools/mytool/rCASC_wrappers/CrossLabel:ro -v /export/job_work_dir/001/1414:/export/job_work_dir/001/1414:ro -v /export/job_work_dir/001/1414/working:/export/job_work_dir/001/1414/working:rw -v /export/galaxy/database/files:/export/galaxy/database/files:rw -w /export/job_work_dir/001/1414/working --net none --rm -u root rcaloger/crosslabel /export/job_work_dir/001/1414/tool_script.sh; return_code=$?; if [ -f /export/job_work_dir/001/1414/working/crosslabel.tar.gz ] ; then cp /export/job_work_dir/001/1414/working/crosslabel.tar.gz /export/galaxy/database/files/002/dataset_2562.dat ; fi; cd '/export/job_work_dir/001/1414'; 
if [ "$GALAXY_LIB" != "None" ]; then
    if [ -n "$PYTHONPATH" ]; then
        PYTHONPATH="$GALAXY_LIB:$PYTHONPATH"
    else
        PYTHONPATH="$GALAXY_LIB"
    fi
    export PYTHONPATH
fi
if [ "$GALAXY_VIRTUAL_ENV" != "None" -a -z "$VIRTUAL_ENV"      -a -f "$GALAXY_VIRTUAL_ENV/bin/activate" ]; then
    . "$GALAXY_VIRTUAL_ENV/bin/activate"
fi
GALAXY_PYTHON=`command -v python`
export PATH=$PATH:'/export/_conda/envs/__samtools@1.3.1/bin' ; python "/export/job_work_dir/001/1414/set_metadata_8oR9Qu.py" "/export/job_work_dir/001/1414/registry.xml" "/export/job_work_dir/001/1414/working/galaxy.json" "/export/job_work_dir/001/1414/metadata_in_HistoryDatasetAssociation_2613_DHSKLo,/export/job_work_dir/001/1414/metadata_kwds_HistoryDatasetAssociation_2613_2c9nN5,/export/job_work_dir/001/1414/metadata_out_HistoryDatasetAssociation_2613_PCA2c4,/export/job_work_dir/001/1414/metadata_results_HistoryDatasetAssociation_2613_qvSWdk,/export/galaxy/database/files/002/dataset_2562.dat,/export/job_work_dir/001/1414/metadata_override_HistoryDatasetAssociation_2613_9SNvQT" "/export/job_work_dir/001/1414/metadata_in_HistoryDatasetAssociation_2612_xr7QOD,/export/job_work_dir/001/1414/metadata_kwds_HistoryDatasetAssociation_2612_oO0Aod,/export/job_work_dir/001/1414/metadata_out_HistoryDatasetAssociation_2612_IPux1J,/export/job_work_dir/001/1414/metadata_results_HistoryDatasetAssociation_2612_gtUSVL,/export/galaxy/database/files/002/dataset_2561.dat,/export/job_work_dir/001/1414/metadata_override_HistoryDatasetAssociation_2612_zDTwz4" 5242880; sh -c "exit $return_code"
echo $? > /export/job_work_dir/001/1414/galaxy_1414.ec
date +"%s" > /export/job_work_dir/001/1414/__instrument_core_epoch_end
