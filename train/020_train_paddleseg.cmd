@ECHO off

SET VENV_DIR=venv_win_train
SET SRC_DIR=src
SET DATASET_DIR=dataset
SET TRAIN_DIR=train

if not exist .\%VENV_DIR% (
	echo Preparing virtual environment...
	py -3.11 -m venv %VENV_DIR%
	if not exist .\%VENV_DIR% (
		exit /B
	)
)

if not exist .\%TRAIN_DIR% (
	mkdir .\%TRAIN_DIR%
)

call .\%VENV_DIR%\scripts\activate.bat

if not exist .\%VENV_DIR%\Lib\site-packages\paddle (
	pip install paddlepaddle-gpu	
)

if not exist .\%VENV_DIR%\Lib\site-packages\paddleseg\ (
	pip install git+https://github.com/PaddlePaddle/PaddleSeg.git
	pip uninstall numpy -y & pip install numpy==1.26.4	
)

set CUDA_VISIBLE_DEVICES=0
python .\%SRC_DIR%\train.py ^
       --config .\%SRC_DIR%\pp_liteseg_small.yml ^
       --save_interval 100 ^
       --save_dir %TRAIN_DIR% ^
	   --do_eval ^
	   --use_vdl