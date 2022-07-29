
%% Generate waveform
fs = 100e3;
bitRate = 1e3;
samplesPerBit = fs/bitRate;

msg = 'yangtiming';
begin_='&@@'
end_= ' '
all=[begin_,msg,end_]
msgBits = str_to_bits_unicode(all);
txW = [msgBits].'
parameter=ones(1,100);
txWave=(txW.*parameter).';
txWave=txWave(:);
txWave=txWave.'


function msg_bits = str_to_bits_unicode(msgStr)

    native=unicode2native(msgStr);%转成本地编码
    msgBin=de2bi(native,8,'left-msb');%转成8bit
    len = size(msgBin,1).*size(msgBin,2);
    msg_bits = reshape(double(msgBin).',len,1).';

end

