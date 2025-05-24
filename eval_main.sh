#!/bin/bash

# As shown in 3_in_1_eval, only BLIP + UniDet (2D) + CLIP is used for evaluation,
# this is also confirmed by https://arxiv.org/pdf/2501.09732

EVAL_DIR=$1
IS_COMPLEX=$2

module load miniforge3
source /apps/miniforge3/enable_miniforge.sh >/dev/null 2>&1
conda activate t2i-compbench


# BLIP
cd BLIPvqa_eval
python BLIP_vqa.py --out_dir=$EVAL_DIR
cd ..


# UniDet
cd UniDet_eval
if [ "$IS_COMPLEX" = "True" ]; then
    python 2D_spatial_eval.py --outpath $EVAL_DIR --complex
else
    python 2D_spatial_eval.py --outpath $EVAL_DIR
fi
cd ..


# CLIP
python CLIPScore_eval/CLIP_similarity.py --outpath=$EVAL_DIR


# Combine
cd 3_in_1_eval
python 3_in_1.py --outpath=$EVAL_DIR
cd ..
