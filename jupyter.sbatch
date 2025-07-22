#!/bin/bash
#SBATCH --job-name=jupyter_lab       # 作业名称
#SBATCH --output=/home/caichang/slurm_test/slurm_output/jupyter_%j.out   # 标准输出
#SBATCH --error=/home/caichang/slurm_test/slurm_output/jupyter_%j.err    # 错误输出
#SBATCH --nodes=1                    # 使用 1 个节点
#SBATCH --ntasks=1                   # 启动 1 个任务
#SBATCH --cpus-per-task=4            # 每个任务使用 4 个 CPU 核心
#SBATCH --mem=100G                   # 分配 100GB 内存
#SBATCH --gres=gpu:0                 # 不分配 GPU
#SBATCH --partition=Tsinghua_local   # 指定分区
#SBATCH --nodelist=relics2           # 只在 relics2 节点上运行

# --- Job Setup ---
echo "Job starting on node: $(hostname)"
echo "SLURM Job ID: $SLURM_JOB_ID"
echo "SLURM Node List: $SLURM_JOB_NODELIST"

# --- Environment Activation ---
echo "Activating Conda environment..."
# 使用推荐的方式初始化 conda for bash
eval "$(conda shell.bash hook)"
conda activate base
echo "Conda environment activated: $(conda info --envs | grep '*')"
echo "Python version: $(python --version)"
echo "Jupyter Lab version: $(jupyter lab --version)"

# --- Find an available port ---
echo "Searching for an available port..."
while true; do
    PORT=$(shuf -i 20000-30000 -n 1)
    # 使用 netstat 或 ss 检查端口是否被监听
    if ! ss -tln | awk '{print $4}' | grep -q ":$PORT$" ; then
        break
    fi
done
echo "Found available port: $PORT"

# --- Set Node Information ---
# 获取运行节点的IP地址，这比硬编码更可靠
NODE_IP=$(hostname -i | awk '{print $NF}')

# --- Print Connection Instructions ---
# 在作业的输出文件中打印清晰的连接指南
echo "------------------------------------------------------------------"
echo "Jupyter Lab is running on node: $SLURM_JOB_NODELIST"
echo "IP Address: $NODE_IP"
echo "Port: $PORT"
echo ""
echo "To connect from your local machine, use the following SSH tunnel command:"
# 假设需要通过 relics-login 节点跳转
# echo "ssh -N -f -L ${PORT}:${NODE_IP}:${PORT} ${USER}@relics-login"
# 假设可以直接连接到计算节点 d
echo "ssh -N -f -L ${PORT}:${NODE_IP}:${PORT} relics-login
echo ""
echo "After establishing the tunnel, open this URL in your browser:"
echo "http://localhost:${PORT}"
echo "------------------------------------------------------------------"

# --- Start Jupyter Lab ---
# 启动 Jupyter Lab，监听在获取到的IP和端口上
echo $PWD
echo $NODE_IP
echo "jupyter lab --no-browser --port=${PORT} --ip=${NODE_IP} "
jupyter lab --no-browser --port=${PORT} --ip=${NODE_IP} 