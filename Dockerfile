FROM darknet:latest as darknet

WORKDIR /

# Copy in required dependencies
COPY --from=darknet /darknet/darknet.so .
COPY --from=darknet /darknet/darknet.py .
COPY --from=darknet /darknet/cfg ./cfg
COPY --from=darknet /darknet/data ./data

WORKDIR darknet

# RUN wget https://pjreddie.com/media/files/yolov3.weights
# RUN wget http://pjreddie.com/media/files/yolo9000.weights
# RUN wget https://archive.org/download/WildlifeSampleVideo/Wildlife.mp4

# CMD ["./darknet", "detector", "test", "./cfg/coco.data", "./cfg/yolov3.cfg", "yolov3.weights", "./data/horses.jpg", "-dont_show"]
# #CMD ["./darknet", "detector", "demo", "./cfg/coco.data", "./cfg/yolov3.cfg", "yolov3.weights", "Wildlife.mp4", "-out_filename", "Wildlife-out.avi", "-dont_show"]

# prepare data
RUN wget https://pjreddie.com/media/files/VOCtrainval_11-May-2012.tar
RUN wget https://pjreddie.com/media/files/VOCtrainval_06-Nov-2007.tar
RUN wget https://pjreddie.com/media/files/VOCtest_06-Nov-2007.tar
RUN wget https://pjreddie.com/media/files/darknet53.conv.74
RUN wget https://pjreddie.com/media/files/voc_label.py

RUN tar xf VOCtrainval_11-May-2012.tar
RUN tar xf VOCtrainval_06-Nov-2007.tar
RUN tar xf VOCtest_06-Nov-2007.tar

RUN python voc_label.py
RUN cat 2007_train.txt 2007_val.txt 2012_*.txt > train.txt

RUN sed -i -e "s/train  = \/home\/pjreddie\/data\/voc\/train.txt/train = train.txt/g" ./cfg/voc.data \
    && sed -i -e "s/valid  = \/home\/pjreddie\/data\/voc\/2007_test.txt/valid = 2007_test.txt/g" ./cfg/voc.data 

RUN sed -i -e "s/batch=1/batch=64/g" ./cfg/yolov3-voc.cfg \
    && sed -i -e "s/subdivisions=1/subdivisions=16/g" ./cfg/yolov3-voc.cfg 

CMD ["./darknet", "detector", "train", "cfg/voc.data", "cfg/yolov3-voc.cfg", "darknet53.conv.74", "-dont_show"]
