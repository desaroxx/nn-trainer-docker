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
CMD wget https://pjreddie.com/media/files/VOCtrainval_11-May-2012.tar
CMD wget https://pjreddie.com/media/files/VOCtrainval_06-Nov-2007.tar
CMD wget https://pjreddie.com/media/files/VOCtest_06-Nov-2007.tar
CMD wget https://pjreddie.com/media/files/darknet53.conv.74
CMD wget https://pjreddie.com/media/files/voc_label.py

CMD tar xf VOCtrainval_11-May-2012.tar
CMD tar xf VOCtrainval_06-Nov-2007.tar
CMD tar xf VOCtest_06-Nov-2007.tar

CMD python voc_label.py
CMD cat 2007_train.txt 2007_val.txt 2012_*.txt > train.txt
CMD echo "classes= 20\ntrain = train.txt\nvalid = 2007_test.txt\nnames = data/voc.names\nbackup = backup" > cfg/voc.data
