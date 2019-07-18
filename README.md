# README

## 总体架构

![1563273180665](../../../Typora/%E7%94%B5%E8%B5%9B/assets/1563273180665.png)



## 文件列表

```
ADC_DRIVER.v        // ADC驱动
DAC_DRIVER.v        // DAC驱动
DDS_wrapper.v       // 测试用DDS模块，可选择输出signed or unsigned的数据
DOWNSAMP.v          // 下采样模块，可配置参数为SAMPLE_RATE. 即每隔2^(SAMPLE_RATE)输出一次
HALF_AMP.v          // 测试用DSP模块，目前配置为原样输出
INTERPOLATION.v     // 插值模块，同样配置参数为SAMPLE_RATE
led_test.v          // 配置板上LED，确保bit文件正常写入
NO_DOWNSAMP.v       // 无下采样
NO_INTERPOLATION.v  // 无插值直接输出
rstpulse.v          // 复位脉冲生成
top.v               // 有下采样与插值top module
top_nosp.v          // 无下采样与插值top module
top_nosp_tb.v       // testbench, 设置SAMPLE_RATE即可测试有下采样和插值的top module
```

## 注意事项
- ip核生成的FIFO的宽度要根据SAMPLE_RATE和DATA_WIDTH改变. 默认SAMPLE_RATE = 4, DATA_WIDTH = 14
- 如果不插值，FIFO_WIDTH=DATA_WIDTH
- 如果插值，FIFO_WIDTH=DATA_WIDTH+SAMPLE_RATE
- 与AD相连的FIFO是异步FIFO，与DA相连的FIFO是同步FIFO，配置时要加上almost full 和almost empty
- 与DA相连的FIFO Threshold Assert Value的大小应该设置为FIFO深度的一半(有插值的时候设置一下，无插值的时候设置不设置都行)
- DDS ip核配置可能不太对，想测试的时候自己改一下

## 定标

ADDA连起来带宽35M，6M内较为平稳

