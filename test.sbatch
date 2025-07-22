#!/bin/bash
#SBATCH --job-name=test_job        # 作业名称
#SBATCH --output=out_%j.txt       # 输出文件名，%j 会被替换为 SLURM 作业ID
#SBATCH --error=out_%j_error.txt  # 错误输出文件名，%j 会被替换为 SLURM 作业ID
#SBATCH --nodes=1                   # 使用 1 个节点
#SBATCH --ntasks=1                  # 启动 1 个任务
#SBATCH --cpus-per-task=1           # 每个任务使用 4 个 CPU 核心
#SBATCH --mem=8G                    # 分配 8GB 内存
#SBATCH --gres=gpu:0                # 不分配 GPU，若想分配 GPU 请修改为 --gres=gpu:1
#SBATCH --partition=Tsinghua_local  # 指定分区


# 指定在 relics2 节点上运行
#SBATCH --nodelist=relics2


# 作业执行的命令
echo "Job is running on node: $(hostname)"
date
echo "Job is running on node: $(hostname)" >> test_job_output.txt  # 输出更多信息
sleep 10  # 增加作业执行时间
echo "Job finished." >> test_job_output.txt  # 输出更多信息
