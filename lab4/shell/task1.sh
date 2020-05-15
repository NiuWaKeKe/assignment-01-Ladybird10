#!usr/bin/env bash
if [[ $1 == "-h" ]];then
        echo "HELP：";
        echo "-h            #查看帮助";
        echo "-f 文件名 -c 压缩百分比 -o 输出位置   #对jpeg格式图片进行图片质量压缩";
        echo "-f 文件名 -size 大小 -o 输出位置      #对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率";
        echo "-f 文件名 -wm 文本水印 嵌入坐标 -o 输出位置          #对图片批量添加自定义文本水印";
        echo "-f 文件名 -rn -f|-l 前缀/后缀 -o 输出位置           #批量重命名统一添加文件名前缀或后缀";
        echo "-f 文件名 -ttjpg -o 输出位置                          #将png/svg图片统一转换为jpg格式图片";

elif [[ $1 == "-f" ]];then
        if [[ $3 == "-c" ]];then
                echo "压缩";
                for file in $2/*
                do
                        na=$file;
                        na1=".jpg";
                        outname=${na##*/}
                        if [[ $file == *$na1* ]];then
                                echo $outname;
                                convert -quality $4 $file $6/$outname;
                        fi
                done
                echo "质量压缩fin";
        elif [[ $3 == "-size" ]];then
                echo "压缩分辨率";
                for file in $2/*
                do
                        na=$file;
                        na1=".jpg";
                        na2=".png";
                        na3=".svg";
                        outname=${na##*/};
                        if [[ $file == *na1* || $file == *$na2* || $file == *$na3* ]];then
                                convert -resize $4 $file $6/$outname;
                        fi
                done
                echo "等比例压缩分辨率fin";
        elif [[ $3 == "-wm" ]];then
                echo "自定义文本水印";
                for file in $2/*
                do
                        na=$file;
                        outname=${na##*/};
                        convert $file -draw "text $5 $4" $7/$outname;
                done
                echo "自定义文本水印fin";
        elif [[ $3 == "-rn" ]];then
                echo "重命名";
                for file in $2/*
                do
                        na=$file;
                        outname=${na##*/}
                        if [[ $4 == "-f" ]];then
                                newname=$7/$5$outname;
                        elif [[ $4 == "-b" ]];then
                                newname=$7/$outname$5;
                        else
                                echo "error";
                        fi
                        mv $file $newname;
                done
                echo "重命名fin";
        elif [[ $3 == "-ttjpg" ]];then
                echo "转换为jpg格式";
                for file in $2/*
                do
                        na=$file;
                        na1=".png";
                        na2=".svg";
                        na3=".jpg";
                        outname=${na##*/};
                        outname=${outname%%.*};
                        if [[ $file == *$na1* || $file == *$na2* ]];then
                                echo $outname1;
                                convert $file $5/$outname1$na3;
                        fi
                done
                echo "转换fin";
        else
                echo "error";
        fi
else
        echo "error";
fi