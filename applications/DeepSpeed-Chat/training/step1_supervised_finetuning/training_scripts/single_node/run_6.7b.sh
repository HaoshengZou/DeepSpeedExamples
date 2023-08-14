#!/bin/bash
# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team
OUTPUT=$1
ZERO_STAGE=$2
if [ "$OUTPUT" == "" ]; then
    OUTPUT=./output
fi
if [ "$ZERO_STAGE" == "" ]; then
    ZERO_STAGE=3
fi
mkdir -p $OUTPUT

deepspeed main.py \
   --data_path /mnt/cephfs/admin/ds-learn/data/dahoas_rm_static \
   --data_split 2,4,4 \
   --model_name_or_path /mnt/cephfs/nlp_group/huan/baichuan-7B/ \
   --per_device_train_batch_size 6 \
   --per_device_eval_batch_size 6 \
   --max_seq_len 512 \
   --learning_rate 3e-5 \
   --weight_decay 0. \
   --num_train_epochs 50 \
   --gradient_accumulation_steps 1 \
   --lr_scheduler_type cosine \
   --num_warmup_steps 0 \
   --seed 0414 \
   --gradient_checkpointing \
   --zero_stage $ZERO_STAGE \
   --deepspeed \
   --output_dir $OUTPUT \
   &> $OUTPUT/training.log
