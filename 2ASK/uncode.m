
rx = out.rxWave(:);
%% 当接入Relay模块时，的01毛刺去除模块
i=11
while(i<length(rx)-41)
        i=i+1;
    if((rx(i+10)==rx(i-10))&& (rx(i)~=rx(i+10)))
        
        rx(i)=rx(i+10);
   
    end
 
end
%% 码元同步基于计数器的锁相环方法
y = rx.';
len=length(rx);

z=zeros(1,int8(len/100));


m = 1;
counter=-2^32;
count_plot=[];
for i =1:len-1
    count_plot(i)=counter;
    if((y(i)-0.5)*(y(i+1)-0.5)<=0)
        a=0.75;
        counter = a*counter+2^32/100;
    else
        a=1;
        counter = a*counter+2^32/100;
    end    
    if(counter<=2^31)

       continue;
    else
        counter = -2^31;
        if(y(i)>=0.5)
            z(m) = 1;
        else
            z(m) = 0;
        end
        m = m+1;
    end 
end
x=1000:1:3000;
plotyy(x,y(1000:3000),x,count_plot(1000:3000),'plot')
%%
[ startlocation,endlocation,flag ]  = frame_byte_sync(z);
startlocation
endlocation
x=z((startlocation+16):length(z));
if flag
    msgStr='none';
    msgStr = bits_to_str_unicode(x(1:length(x)-rem(length(x),8)))
end

%% 帧同步
function [ startlocation,endlocation,flag ] = frame_byte_sync( db )

fbegin = [0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0];
fend   = [0,0,1,0,0,0,1,1,0,0,1,0,0,0,1,1];
K=length(db);
startlocation=0;
endlocation=0;
flag_b=0;
flag_e=0;
flag=0;
    for i=1:(K-15)
        flag_beign = sum(~xor(db(i:i+15),fbegin));
        flag_end = sum(~xor(db(i:i+15),fend));
        if(flag_beign == 16)
            startlocation = i;
            flag_b=1;
        end
        if(flag_end == 16)
            endlocation = i;
            flag_e=1;
        end
        if flag_b==1
            break
        end
    end
if flag_b 
    flag=1;
end
end

%% 恢复ASCII码
function msgStr = bits_to_str_unicode(msg_bits)

    bit1=reshape(msg_bits,8,numel(msg_bits)/8).';%整形成8bit表示的字节
    native1=bi2de(bit1,'left-msb').';%转成编码
    b=native2unicode(native1);
	disp(char(b));

end
