������Ҫ�޸ĵĵط�

1��docker-compose.yaml
����1���޸�Ϊgitlab�ϵ���Ŀ���ƣ�ע���뱣�����ġ�:��

2��docker-compose-development.yaml
����1���޸�Ϊgitlab�ϵ���Ŀ���ƣ�ע���뱣�����ġ�:��

3��/timer/timing.cron
����Ҫ���еĶ�ʱ�ű����ø��ļ��У����ڿɸ�ʽ�ο�timing.cron.bak�ļ���
��ע����ʹ�þ���·��������·��Ϊ��/var/www/html;���һ����ӱ�ע��Ϣ��û�еĻ������в���


------------------------------�ָ���---------------------------------
��ά��Ҫȷ�ϵĵط�

1��ȷ��jenkins������ȡ�����¾���
docker.listcloud.cn:5000/nginx-php7
2������php5.X�İ汾���޸�Dockerfile�ļ����޸�����
	FROM docker.listcloud.cn:5000/nginx-php5.6
	FROM docker.listcloud.cn:5000/nginx-php5
3��docker-compose.yaml��docker-compose-development.yaml��Ҫ������һ�е�����
4��./timer/timing.cronΪ���ö�ʱ�ű����ɲο�:timing.cron.bak
5��./devops/configΪ����nginx���õĵط�
	default.confҪ�޸�����
		listen
		server_name
		access_log
		error_log
		root

6��./devops/cicd/bin��Ҫ�޸�config�����ļ�
7��./devops/cicd/bin/cd-shell/test-shell��Ҫ�޸�test.sh�����ļ�
8����Ŀ¼����Ҫ��.env_dev��.env_prod�ļ�
9��ȷ������������ص�˽�вֿ⾵�� /etc/docker/daemon.json
	{ "insecure-registries": ["docker.ops.colourlife.com:5000"] }
10��./ci.sh dev		���������ʾ����������Ϊdev ��ʽΪprod
   ./cd.sh dev auto	��Ҫ������������
	��һ���������ж���ĿҪִ�еĻ���,�ֱ�Ϊ��dev��prod��
	�ڶ���������ָ��ȫ�Զ����������Զ������𣬷ֱ�Ϊ��auto��manual

��ȷ��������Ϣ֮����ִ��cicd

------------------------------�ָ���---------------------------------
Jenkins���ã�

JOB_CI-shell:
cd /home/jenkins/workspace
chmod -R 777 /home/jenkins
cd $JOB_NAME/devops/cicd/bin
./ci.sh dev

JOB_CD
��������������:
dirname=JOB_ci_NAME
JOB_CD-shell:
export dir_name=$dirname
cd /home/jenkins/workspace/$dirname/devops/cicd/bin
./cd.sh dev auto

JOB_Pipeline
node(){
	stage('test_ci'){
		build 'test_ci'
	}
	stage('test_cd'){
		build 'test_cd'
	}
}

webhook����
����һ��
Build when a change is pushed to GitLab. GitLab CI Service  +  Secret token
ֱ��ʹ��

��������
Build when a change is pushed to GitLab. GitLab CI Service  +  ����Զ�̹���
openssl rand -hex 12		�����֤����
http://jenkins��������ַ:8080/buildByToken/build?job=jenkins��Ŀ��&token=tokenֵ

------------------------------�ָ���---------------------------------

����̸֮��

1���뿪��ȷ�ϴ������Ƿ��л����������ݡ��磺ͼƬ��Ӧ����־��
2��Ӧ�öԻ��������Ƿ������ԡ�
3����ʽ��������ʱ��������Ҫֱ���滻ԭ�е���������ɾ��ԭ�汾��������������ͣԭ��������
4������������Ҫ��ǰ���ص�����������Ȼһ��ɾ������������������¹ʡ�
5���ֶ���ȡ�����󣬺�������ʹ��CD���̣�ԭ���ֶ���ȡ������������ű���ͬ����ʱ���޷�ɾ��ԭ�е�������