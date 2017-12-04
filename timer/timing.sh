#! /bin/bash

#定时任务

#调用定时开户接口
result=$(curl -X POST 127.0.0.1:8705/account/timingCreateAccount);
echo $result>>logs.txt;

#定时激活粮票劵
activateResult=$(curl -X PUT 127.0.0.1:8705/ticket/activate);
echo $activateResult>>logs.txt;

