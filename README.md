# 配置文件
  * wp_config.php
## 开发需要修改的地方

1、docker-compose.yaml
将第1行修改为gitlab上的项目名称，注意请保留最后的“:”
 
2、docker-compose-development.yaml
将第1行修改为gitlab上的项目名称，注意请保留最后的“:”

3、/timer/timing.cron
将需要运行的定时脚本放置该文件中，基于可格式参考timing.cron.bak文件。
备注：请使用绝对路径，代码路径为：/var/www/html;最后一行添加备注信息，没有的话则运行不了


------------------------------分割线---------------------------------
运维需要确认的地方

1、确保jenkins上能拉取到以下镜像
docker.listcloud.cn:5000/nginx-php7
2、如需php5.X的版本，修改Dockerfile文件，修改如下
```
	FROM docker.listcloud.cn:5000/nginx-php5.6
	FROM docker.listcloud.cn:5000/nginx-php5
```
3、docker-compose.yaml与docker-compose-development.yaml需要更换第一行的名称
4、./timer/timing.cron为放置定时脚本，可参考:timing.cron.bak
5、./devops/config为放置nginx配置的地方
	default.conf要修改如下
		listen
		server_name
		access_log
		error_log
		root

6、./devops/cicd/bin需要修改config配置文件
7、./devops/cicd/bin/cd-shell/test-shell需要修改test.sh测试文件
8、更目录下需要有.env_dev和.env_prod文件
9、确保部署端能下载到私有仓库镜像 /etc/docker/daemon.json
```
	{ "insecure-registries": ["docker.ops.colourlife.com:5000"] }
```
10、./ci.sh dev		输入参数表示环境：测试为dev 正式为prod
   ./cd.sh dev auto	需要传两个参数，
	第一个：用于判断项目要执行的环境,分别为：dev、prod；
	第二个：用于指定全自动化部署或半自动化部署，分别为：auto、manual

请确认以上信息之后再执行cicd

------------------------------分割线---------------------------------
Jenkins配置：

JOB_CI-shell:
```
cd /home/jenkins/workspace
chmod -R 777 /home/jenkins
cd $JOB_NAME/devops/cicd/bin
./ci.sh dev
```
JOB_CD
参数化构建过程:
dirname=JOB_ci_NAME
JOB_CD-shell:
```
export dir_name=$dirname
cd /home/jenkins/workspace/$dirname/devops/cicd/bin
./cd.sh dev auto
```
JOB_Pipeline
```
node(){
	stage('test_ci'){
		build 'test_ci'
	}
	stage('test_cd'){
		build 'test_cd'
	}
}
```
webhook生成
方法一：
Build when a change is pushed to GitLab. GitLab CI Service  +  Secret token
直接使用

方法二：
Build when a change is pushed to GitLab. GitLab CI Service  +  触发远程构建
openssl rand -hex 12		身份验证令牌
http://jenkins服务器地址:8080/buildByToken/build?job=jenkins项目名&token=token值

------------------------------分割线---------------------------------

经验之谈：

1、与开发确认代码中是否有会有增量数据。如：图片、应用日志。
2、应用对缓存数据是否依赖性。
3、正式环境更新时，尽量不要直接替换原有的容器（即删除原版本容器），可先暂停原有容器。
4、增量数据需要提前挂载到宿主机，不然一旦删除容器，会造成数据事故。
5、手动拉取容器后，后续则不能使用CD流程；原因：手动拉取的容器名称与脚本不同，届时将无法删除原有的容器。
