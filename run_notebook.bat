set src=C:\development
set backend=tensorflow
docker run -it -p 0.0.0.0:8888:8888 -v %src%:/src/workspace --env KERAS_BACKEND=%backend% subsurface-ml-docker