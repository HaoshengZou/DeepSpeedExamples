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
    ZERO_STAGE=0
fi
mkdir -p $OUTPUT

deepspeed --include=localhost:0,1,2,3,4,5,6 main.py \
   --data_path /mnt/cephfs/admin/ds-learn/data/dahoas_rm_static \
   --data_split 2,4,4 \
   --model_name_or_path /mnt/cephfs/nlp_group/huan/baichuan-7B/ \
   --num_padding_at_beginning 1 \
   --per_device_train_batch_size 6 \
   --per_device_eval_batch_size 6 \
   --max_seq_len 512 \
   --learning_rate 5e-5 \
   --weight_decay 0.1 \
   --num_train_epochs 1 \
   --disable_dropout \
   --gradient_accumulation_steps 1 \
   --lr_scheduler_type cosine \
   --num_warmup_steps 0 \
   --seed 0414 \
   --gradient_checkpointing \
   --zero_stage 3 \
   --deepspeed \
   --output_dir $OUTPUT \
   &> $OUTPUT/training.log
